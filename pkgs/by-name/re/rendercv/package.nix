{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "rendercv";
  version = "2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rendercv";
    repo = "rendercv";
    tag = "v${version}";
    hash = "sha256-bIEuzMGV/l8Cunc4W04ESFYTKhNH+ffkA6eXGbyu3A0=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = [
    python3Packages.jinja2
  ];

  pythonRelaxDeps = [
    python3Packages.phonenumbers
    python3Packages.email-validator
    python3Packages.pydantic
    python3Packages.pydantic-extra-types
    python3Packages.pycountry
    python3Packages.ruamel-yaml
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = ["--version"];

  meta = {
    description = "The engine of the RenderCV App ";
    homepage = "https://rendercv.com/";
    changelog = "https://github.com/rendercv/rendercv/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [lykos153];
    mainProgram = "rendercv";
  };
}
