{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  versionCheckHook,
  nix-update-script,

  withAsync ? true,
  withBlockStorage ? true,
  withCompute ? true,
  withContainerInfra ? true,
  withDns ? true,
  withIdentity ? true,
  withImage ? true,
  withLoadBalancer ? true,
  withNetwork ? true,
  withObjectStore ? true,
  withPlacement ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openstack-rs";
  version = "0.10.0";
  src = fetchFromGitHub {
    owner = "gtema";
    repo = "openstack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NDiqIhpKP7iGEAgAnaBekqjjWM7KqZPpdtPu/mEp1NU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-S4FivjHkWC5tA1l4cheJsTECRfv8zyQbR88BqCeKFuc=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildNoDefaultFeatures = true;
  buildFeatures =
    lib.optional withAsync "openstack_sdk/async"
    ++ lib.optional withBlockStorage "openstack_cli/block_storage"
    ++ lib.optional withCompute "openstack_cli/compute"
    ++ lib.optional withContainerInfra "openstack_cli/container_infra"
    ++ lib.optional withDns "openstack_cli/dns"
    ++ lib.optional withIdentity "openstack_cli/identity"
    ++ lib.optional withImage "openstack_cli/image"
    ++ lib.optional withLoadBalancer "openstack_cli/load_balancer"
    ++ lib.optional withNetwork "openstack_cli/network"
    ++ lib.optional withObjectStore "openstack_cli/object_store"
    ++ lib.optional withPlacement "openstack_cli/placement";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd osc \
      --bash <($out/bin/osc completion bash) \
      --fish <($out/bin/osc completion fish) \
      --zsh <($out/bin/osc completion zsh)
  '';

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenStack CLI and TUI implemented in Rust";
    homepage = "https://github.com/gtema/openstack";
    changelog = "https://github.com/gtema/openstack/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lykos153 ];
    mainProgram = "osc";
  };
})
