{
  lib,
  buildPythonPackage,
  fetchgit,

  pbr,
  flake8,
  jsonschema,
  networkx,
  pyyaml,
  stevedore,

  nix-update-script,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "diskimage-builder";
  version = "3.38.0";

  # cannot use fetchFromGitea, because packing tar.gz archives is broken on that gitea instance
  src = fetchgit {
    url = "https://opendev.org/openstack/diskimage-builder.git";
    tag = version;
    hash = "sha256-1BfyPGeDuIemdMxXR0lHW6TN6+4CKgYUSd1LOpG36ps=";
  };

  env.PBR_VERSION = version;

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    flake8
    jsonschema
    networkx
    pyyaml
    stevedore
  ];

  passthru.updateScript = nix-update-script { };

  # nativeCheckInputs = [
  #   versionCheckHook
  # ];
  # versionCheckProgramArg = "--help";

  pythonImportsCheck = [ "diskimage_builder" ];

  meta = {
    homepage = "https://docs.openstack.org/diskimage-builder";
    changelog = "https://docs.openstack.org/releasenotes/diskimage-builder";
    description = "Image building tools for OpenStack";
    maintainers = with lib.maintainers; [ lykos153 ];
    license = lib.licenses.apsl20;
  };
}
