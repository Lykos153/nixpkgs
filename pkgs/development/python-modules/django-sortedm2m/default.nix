{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-sortedm2m";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-sortedm2m";
    tag = version;
    hash = "sha256-Jr3C6teU4On2PiJJV9vW4EEPEuknNCZRVMDMmrs6VY8=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  pythonImportsCheck = [ "sortedm2m" ];

  meta = {
    description = "Drop-in replacement for Django's ManyToManyField with sorted relations";
    homepage = "https://github.com/jazzband/django-sortedm2m";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
