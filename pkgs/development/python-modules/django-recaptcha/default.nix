{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "django-recaptcha";
  version = "4.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "django_recaptcha";
    inherit version;
    hash = "sha256-cwl7lYcz9ltynU5GMMUfwr8UespvAmAX0YiY38JctMU=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ django ];

  meta = {
    description = "Django reCAPTCHA form field/widget app";
    homepage = "https://github.com/django-recaptcha/django-recaptcha";
    changelog = "https://github.com/django-recaptcha/django-recaptcha/blob/main/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
