{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  flask,
}:

buildPythonPackage rec {
  pname = "flask-basicauth";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "Flask-BasicAuth";
    inherit version;
    hash = "sha256-3169SJ3AkUwiRBnaBZ2ZHrcpiKAc3UuVbVKTLOfVAf8=";
  };

  # Upstream only ships a legacy setup.py (no pyproject.toml); setuptools
  # provides the implicit legacy build backend.
  build-system = [ setuptools ];

  dependencies = [ flask ];

  # No test suite is shipped in the sdist (only in the git repo).
  doCheck = false;

  pythonImportsCheck = [ "flask_basicauth" ];

  meta = {
    description = "HTTP basic access authentication for Flask";
    homepage = "https://github.com/jpvanhal/flask-basicauth";
    changelog = "https://github.com/jpvanhal/flask-basicauth/blob/master/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
