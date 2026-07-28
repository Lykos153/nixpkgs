# pkgs/by-name/wg/wger/frontend.nix
#
# Reproduces the "builder" stage of extras/docker/production/Dockerfile:
#   npm ci --production            (bootstrap, htmx.org, datatables.net-bs5, @popperjs/core)
#   npm run build:css:sass         (wger/core/static/scss/main.scss -> bootstrap-compiled.css)
#   npm pack @wger-project/react-components@<devDep version> && unpack into node_modules
#
# NOTE: untested. In particular the react-components fetch below needs a
# real integrity hash from the npm registry, and npmDepsHash needs to be
# computed with `prefetch-npm-deps package-lock.json` against the *actual*
# 2.6.0 tag's lockfile (I only inspected master's).
{
  lib,
  stdenv,
  fetchNpmDeps,
  fetchurl,
  npmHooks,
  nodejs,
  sass,
  src,
  version,
}:

let
  # `npm pack @wger-project/react-components@<version>` resolves to a tarball at
  # https://registry.npmjs.org/@wger-project/react-components/-/react-components-<version>.tgz
  # Pin this to whatever version.py / package.json's devDependencies pins for
  # the 2.6.0 tag (it was 26.7.24 on master at the time of writing — verify
  # against the tag, not master).
  reactComponentsVersion = "26.7.24";
  reactComponents = fetchurl {
    url = "https://registry.npmjs.org/@wger-project/react-components/-/react-components-${reactComponentsVersion}.tgz";
    hash = "sha256-/bZhLCr4LoVojNg3SRi4JG14Xwg/UyDNz+kClp1+f/k=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wger-frontend";
  inherit version src;

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    sass
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-Ygu3GmN18UoEu8YQGkSNjeWu0jv3gSurjatkrEiECSo=";
  };

  # npmConfigHook's default install target is `npm ci`; we only want the
  # production deps like the Dockerfile does.
  npmInstallFlags = [ "--omit=dev" ];

  buildPhase = ''
    runHook preBuild

    npm run build:css:sass

    mkdir -p node_modules/@wger-project/react-components
    tar -xzf ${reactComponents} -C node_modules/@wger-project/react-components --strip-components=1

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r node_modules $out/node_modules
    cp wger/core/static/bootstrap-compiled.css $out/
    cp wger/core/static/bootstrap-compiled.css.map $out/

    runHook postInstall
  '';

  dontFixup = true;
})
