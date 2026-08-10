{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-activity-stream";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "django-activity-stream";
    inherit version;
    hash = "sha256-M6RnupuamWnL7Xay/WXpShmSjkjw7CsuW7GFUXcDbtI=" ;
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  pythonImportsCheck = [ "actstream" ];

  meta = {
    description = "Generate generic activity streams from the actions on your site";
    homepage = "https://github.com/justquick/django-activity-stream";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
