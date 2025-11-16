{
  lib,
  stdenv,
  fetchFromSourcehut,
  python3,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  name = "coord";
  version = "1.0";
  propagatedBuildInputs = [
    (python3.withPackages (
      pythonPackages: with pythonPackages; [
        pyqt6
      ]
    ))
  ];
  src = fetchFromSourcehut {
    owner = "~geb";
    repo = "coord";
    rev = version;
    hash = "sha256-noEU8VXrFjhXd39R0Ps9m1/K2lt4fOXsjnNuVCDlknM=";
  };
  dontUnpack = true;
  installPhase = ''
  install -Dm755 $src/coord $out/bin/coord
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "coord displays coordinates on the screen and prints the position of the one you type.";
    homepage = "https://git.sr.ht/~geb/coord";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
