{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
  nix-update-script,

  yt-dlp,
  ffmpeg
}:

buildGoModule (finalAttrs: {
  pname = "danzo";
  version = "1.34";

  src = fetchFromGitHub {
    owner = "Tanq16";
    repo = "danzo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B7mh/qJHuqotlszC7ijzTZOiv8ZbKFkfq3sIfBdHsUk=";
  };

  vendorHash = "sha256-K5jObdBOi8X1G3HJ79XVYjZeXKd7BdZD9DQJpc7h3Yc=";

  ldflags = [
    "-X github.com/tanq16/danzo/cmd.DanzoVersion=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/danzo \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg yt-dlp ]}
      '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Swiss army knife of multi-service CLI download utilities written on Go.";
    homepage = "https://github.com/Tanq16/danzo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lykos153 ];
    mainProgram = "danzo";
  };
})
