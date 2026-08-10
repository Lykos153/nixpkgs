{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "lingua-language-detector";
  version = "2.2.0";

  pyproject = true;

  # lingua-rs' own git tags follow the Rust *crate* version
  # (Cargo.toml `[package] version`), which is decoupled from the Python
  # package version.
  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = "lingua-rs";
    tag = "v1.8.0";
    hash = "sha256-oDzmNjjVj/PiV9DHsjKC4uMtDeW8KLawj/5eK5l80ZE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-DazKsJ6j62NZSMRLhNLi0LpWrTGapXOQ/ebbF7MCj7Y=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  # Drop helper for cross-compiling for Windows
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"pyo3/generate-import-lib", ' ""
  '';

  pythonImportsCheck = [ "lingua" ];

  meta = {
    description = "Accurate natural language detection for short and mixed-language text";
    homepage = "https://github.com/pemistahl/lingua-rs";
    changelog = "https://github.com/pemistahl/lingua-rs/blob/v1.8.0/RELEASE_NOTES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lykos153 ];
    platforms = lib.platforms.unix;
  };
}
