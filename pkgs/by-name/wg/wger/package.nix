{
  lib,
  python3Packages,
  fetchFromGitHub,
  callPackage,
}:

let
  version = "2.6";
  src = fetchFromGitHub {
    owner = "wger-project";
    repo = "wger";
    tag = version;
    hash = "sha256-x2CgVlrBOBTV3+88KP7ug11Lf7CwVJ6qOcsxKWCJQWg=";
  };

  frontend = callPackage ./frontend.nix { inherit src version; };

in
python3Packages.buildPythonApplication rec {
  pname = "wger";
  inherit version src;
  pyproject = true;

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    boto3
    celery
    crispy-bootstrap5
    cryptography
    django-activity-stream
    django-allauth
    django-axes
    django-bootstrap-breadcrumbs2
    django-cors-headers
    django-crispy-forms
    django-environ
    django-filter
    django-formtools
    django-prometheus
    django-recaptcha
    django-redis
    django-simple-history
    django-sortedm2m
    django-storages
    djangorestframework
    djangorestframework-simplejwt
    drf-spectacular
    easy-thumbnails
    flower
    fontawesomefree
    gevent
    icalendar
    invoke
    lingua-language-detector
    markdown-it-py
    markdownify
    nh3
    openfoodfacts
    packaging
    pillow
    psycopg
    reportlab
    requests
    tqdm
    tzdata
  ];
  pythonRelaxDeps = true;


  pythonImportsCheck = [ "wger" ];

  postInstall = ''
    mkdir -p $out/share/wger
    ln -s ${frontend}/node_modules $out/share/wger/node_modules
    cp ${frontend}/bootstrap-compiled.css $out/${python3Packages.python.sitePackages}/wger/core/static/bootstrap-compiled.css
    cp ${frontend}/bootstrap-compiled.css.map $out/${python3Packages.python.sitePackages}/wger/core/static/bootstrap-compiled.css.map

    export DJANGO_SETTINGS_MODULE=settings.main
    export SECRET_KEY=nix-build-dummy-key
    export DATABASE_URL=sqlite:///build.sqlite3
    export STATIC_ROOT=$out/share/wger/static
    PYTHONPATH=$out/${python3Packages.python.sitePackages}:$PYTHONPATH \
      python3 manage.py collectstatic --no-input
  '';

  passthru = {
    inherit frontend;
  };

  meta = {
    description = "Self hosted FLOSS fitness/workout, nutrition and weight tracker";
    homepage = "https://wger.de";
    changelog = "https://github.com/wger-project/wger/releases/tag/${version}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "wger";
    maintainers = with lib.maintainers; [ lykos153 ];
    platforms = lib.platforms.linux;
  };
}
