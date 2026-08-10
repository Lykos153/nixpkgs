{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-bootstrap-breadcrumbs2";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "django-bootstrap-breadcrumbs2";
    inherit version;
    hash = "sha256-E88Ze05A6dFXi3IWaOUxYQyltplVZ2eS7pQC4B78Hq0=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  pythonImportsCheck = [ "django_bootstrap_breadcrumbs" ];

  meta = {
    description = "Django breadcrumbs for Bootstrap 2, 3 or 4";
    homepage = "https://pypi.org/project/django-bootstrap-breadcrumbs2/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
