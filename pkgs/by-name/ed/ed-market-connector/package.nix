{
  lib,
  python3,
  writeShellApplication,
  fetchFromGitHub,
}: let
  python-env = python3.buildEnv.override {
    extraLibs = with python3.pkgs; [
      requests
      pillow
      watchdog
      semantic-version
      psutil
      tkinter
    ];
    ignoreCollisions = false;
  };
  version = "5.13.1";
  src = fetchFromGitHub {
    owner = "EDCD";
    repo = "EDMarketConnector";
    tag = "Release/${version}";
    hash = "sha256-50OPbAXrDKodN0o6UibGUmMqQ/accF2/gNHnms+8rOI=";
  };
in
  writeShellApplication {
    name = "ed-market-connector";
    runtimeInputs = [python-env];
    text = ''
      exec python3 ${src}/EDMarketConnector.py "$@"
    '';

    meta = {
      description = "Downloads commodity market and other station data from the game Elite: Dangerous for use with all popular online and offline trading tools.";
      homepage = "https://github.com/EDCD/EDMarketConnector";
      changelog = "https://github.com/EDCD/EDMarketConnector/releases/tag/Release/${version}";
      license = lib.licenses.gpl2;
      maintainers = with lib.maintainers; [lykos153];
      mainProgram = "ed-market-connector";
    };
  }
