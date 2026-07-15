{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  python3,
  flutter344,
  uwsgi,
  makeWrapper,
  nixosTests,
}:

let
  version = "0.7.9";

  src = fetchFromGitHub {
    owner = "TomBursch";
    repo = "kitchenowl";
    tag = "v${version}";
    hash = "sha256-blSxBxplZR0LdyptDqg6L6gCK59t5TS+6ykrltoHsWY=";
  };

  # ---------------------------------------------------------------------
  # NLTK data: the recipe/ingredient parser needs the averaged perceptron
  # POS tagger at runtime (see backend/Dockerfile's `nltk.download(...)`
  # step). Fetched as a fixed-output derivation instead of downloaded at
  # build- or run-time.
  # ---------------------------------------------------------------------
  nltkData = fetchzip {
    url = "https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/taggers/averaged_perceptron_tagger_eng.zip";
    hash = "sha256-MgEM1KqyjFc9FPmOrLf7c9BgzbJwx+ii5qM5I+ewhLc=";
    stripRoot = false;
    extension = "zip";
    postFetch = ''
      mkdir -p $out/taggers-tmp
      mv $out/* $out/taggers-tmp/ 2>/dev/null || true
      mkdir -p $out/taggers
      mv $out/taggers-tmp $out/taggers/averaged_perceptron_tagger_eng
    '';
  };

  # ---------------------------------------------------------------------
  # Frontend: Flutter web build
  # ---------------------------------------------------------------------
  frontend = flutter344.buildFlutterApplication {
    pname = "kitchenowl-web";
    inherit version src;

    sourceRoot = "${src.name}/kitchenowl";
    targetFlutterPlatform = "web";

    pubspecLock = lib.importJSON ./pubspec.lock.json;
    # kitchenowl's pubspec.lock has no git-hosted (as opposed to pub.dev
    # hosted) packages, so no `gitHashes` entries are needed.

    flutterBuildFlags = [ "--no-web-resources-cdn" ];

    meta = {
      description = "Web frontend for KitchenOwl";
      homepage = "https://github.com/TomBursch/kitchenowl";
      license = lib.licenses.agpl3Plus;
      maintainers = [ ];
    };
  };

  # ---------------------------------------------------------------------
  # Backend: Flask/uWSGI application environment
  # ---------------------------------------------------------------------
  pythonEnv = python3.withPackages (
    ps: with ps; [
      apispec
      apispec-webframeworks
      apscheduler
      blurhash-python
      celery
      dbscan1d
      flask
      flask-apscheduler
      flask-basicauth
      flask-bcrypt
      flask-jwt-extended
      flask-migrate
      flask-socketio
      flask-sqlalchemy
      gevent
      greenlet
      ingredient-parser-nlp
      lark
      litellm
      marshmallow
      mlxtend
      nltk
      numpy
      oic
      pandas
      prometheus-client
      prometheus-flask-exporter
      psycopg2 # replaces upstream's psycopg2-binary; nix builds it against nixpkgs' libpq
      python-socketio
      recipe-scrapers
      requests
      requests-hardened
      sqlalchemy
      sqlite-icu
      tqdm
      uwsgi-tools
      werkzeug
    ]
  );

  uwsgiWithPython = uwsgi.override {
    plugins = [
      "python3"
      "http"
    ];
    python3 = pythonEnv;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kitchenowl";
  inherit version src;

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kitchenowl
    cp -r backend/app $out/share/kitchenowl/app
    cp -r backend/migrations $out/share/kitchenowl/migrations
    cp -r backend/templates $out/share/kitchenowl/templates
    cp backend/wsgi.py backend/manage.py backend/manage_default_items.py \
       backend/upgrade_default_items.py $out/share/kitchenowl/

    ln -s ${frontend} $out/share/kitchenowl/web
    ln -s ${nltkData} $out/share/kitchenowl/nltk_data

    mkdir -p $out/bin

    # Runs the application under uWSGI, serving both the API and the
    # prebuilt Flutter web assets, analogous to the upstream Docker image's
    # [web] wsgi.ini section + entrypoint.sh.
    makeWrapper ${uwsgiWithPython}/bin/uwsgi $out/bin/kitchenowl \
      --set NLTK_DATA "${nltkData}" \
      --add-flags "--chdir $out/share/kitchenowl" \
      --add-flags "--plugin python3,http" \
      --add-flags "--wsgi-file wsgi.py --callable app" \
      --add-flags "--master --enable-threads --lazy-apps --single-interpreter --vacuum --die-on-term --need-app" \
      --add-flags "--http-websockets --http-keepalive" \
      --add-flags "--static-map /=${frontend} --route '^\\/(?!api)(?!mcp)[^\\.]*$ static:${frontend}/index.html'"

    # `flask db upgrade`, `python manage.py ...` etc.
    makeWrapper ${pythonEnv}/bin/python $out/bin/kitchenowl-manage \
      --set NLTK_DATA "${nltkData}" \
      --add-flags "$out/share/kitchenowl/manage.py" \
      --run "cd $out/share/kitchenowl"

    makeWrapper ${pythonEnv}/bin/flask $out/bin/kitchenowl-flask \
      --set NLTK_DATA "${nltkData}" \
      --set FLASK_APP "wsgi.py" \
      --run "cd $out/share/kitchenowl"

    runHook postInstall
  '';

  passthru = {
    inherit frontend pythonEnv;
    tests.kitchenowl = nixosTests.kitchenowl or null;
  };

  meta = {
    description = "Self-hosted grocery list and recipe manager";
    longDescription = ''
      KitchenOwl is a self-hosted grocery list and recipe manager. The
      backend is a Flask/uWSGI application and the frontend is a Flutter
      web app; this derivation builds both and wires them together the
      same way the upstream Docker image does.
    '';
    homepage = "https://github.com/TomBursch/kitchenowl";
    changelog = "https://github.com/TomBursch/kitchenowl/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ lykos153 ];
    mainProgram = "kitchenowl";
    platforms = lib.platforms.linux;
  };
})
