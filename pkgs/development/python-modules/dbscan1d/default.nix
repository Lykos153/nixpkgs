{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
}:

buildPythonPackage rec {
  pname = "dbscan1d";
  version = "0.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QdOfk7PjqhtoMABSlxLwiprJ58D3AOJbStPVzNb5SjQ=";
  };

  # Upstream determines its version dynamically via setuptools-git-versioning,
  # which requires a git checkout and fails from a plain sdist. The version is
  # already known statically, so pin it instead of dealing with a nativeBuildInput
  # that shells out to git.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"' \
      --replace-fail '"setuptools>=41", "setuptools-scm",' '"setuptools>=41",'
  '';

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  # The sdist on PyPI doesn't include the tests/ directory (only the git
  # repo does), so there's nothing for pytest to collect; leaving a check
  # hook wired up here fails the build on "collected 0 items".
  doCheck = false;

  pythonImportsCheck = [ "dbscan1d" ];

  meta = {
    description = "Efficient implementation of the DBSCAN clustering algorithm for 1D arrays";
    homepage = "https://github.com/d-chambers/dbscan1d";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
