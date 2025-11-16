{
  lib,
  stdenv,
  fetchFromSourcehut,
  bspwm,
  sxhkd,
  dmenu,
  physlock,
  setroot,
  xclip,
  rxvt-unicode,
  # urxvt-perls,
  qutebrowser,
  zathura,
  # zathura-pdf-mupdf,
  zsh,
  zsh-autosuggestions,
  clipnotify,
  picom,
  unclutter-xfixes,
  coord,
}:

stdenv.mkDerivation rec {
  name = "tiles";
  version = "0.2";
  propagatedBuildInputs = [
  bspwm
  sxhkd
  dmenu
  physlock
  setroot
  xclip
  rxvt-unicode
  # urxvt-perls
  qutebrowser
  zathura
  # zathura-pdf-mupdf
  zsh
  zsh-autosuggestions
  clipnotify
  picom
  unclutter-xfixes
  coord
      ];
  src = fetchFromSourcehut {
    owner = "~geb";
    repo = "tiles";
    rev = version;
    hash = "sha256-HsKE8zxYsTMKFLLL6tki77eG9SVZm8lVimPnIvYinJA=";
  };
  dontUnpack = true;
  installPhase = "install -Dm755 $src/coord $out/bin/coord";
  meta = {
    description = "A minimalist desktop environment which doesn't require a mouse designed to be efficient with voice input.";
    homepage = "https://git.sr.ht/~geb/tiles";
    changelog = "https://git.sr.ht/~geb/tiles/tree/${version}/item/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
