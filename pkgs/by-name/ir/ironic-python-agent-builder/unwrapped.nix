{
  lib,
buildPythonPackage,
  fetchgit,

  pbr,
diskimage-builder,

  nix-update-script,
}:

buildPythonPackage rec {
  pname = "ironic-python-agent-builder";
  version = "6.0.0";

# cannot use fetchFromGitea, because packing tar.gz archives is broken on that gitea instance
src = fetchgit {
    url = "https://opendev.org/openstack/ironic-python-agent-builder.git";
    tag = version;
    hash ="";
  };

  env.PBR_VERSION = version;

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs =  [
    diskimage-builder
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://docs.openstack.org/ironic-python-agent-builder";
    changelog = "https://docs.openstack.org/releasenotes/ironic-python-agent-builder";
    description = "Tools and scripts to build a deployment, cleaning or inspection ramdisk based on Ironic Python Agent.";
    maintainers = with lib.maintainers; [ lykos153 ];
    license = lib.licenses.apsl20;
  };
}
