{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  requests,
  pydantic,
  setuptools,
  tqdm,
}:

buildPythonPackage rec {
  pname = "openfoodfacts";
  version = "5.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GdJb6yMheQgM6yWtbO/DFpWpwqHM9EnzDgTgwEquckM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    pydantic
    setuptools
    tqdm
  ];

  pythonImportsCheck = [ "openfoodfacts" ];

  meta = {
    description = "Official Python SDK of Open Food Facts";
    homepage = "https://github.com/openfoodfacts/openfoodfacts-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
