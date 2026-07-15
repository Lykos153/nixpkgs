{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "uwsgi-tools";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Vl4QlFxQ7W9DeBaKKmCbt9HCxbIasj7dGtX3PRWrY1Y=";
  };

  build-system = [ setuptools ];

  doCheck = false; # no test suite shipped in the sdist

  pythonImportsCheck = [ "uwsgi_tools" ];

  meta = {
    description = "Curl-like client and reverse proxy for the uwsgi protocol";
    homepage = "https://github.com/andreif/uwsgi-tools";
    license = lib.licenses.mit;
    mainProgram = "uwsgi_curl";
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
