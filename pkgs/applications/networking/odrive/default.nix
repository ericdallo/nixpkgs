{ buildEnv, fetchFromGitHub, stdenv, nodejs, electron, pkgs, runtimeShell, lib}:

let
  packageName = with lib; concatStrings (map (entry: (concatStrings (mapAttrsToList (key: value: "${key}-${value}") entry))) (importJSON ./node-packages.json));

  nodePackages = import ./odrive.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

in nodePackages."${packageName}".override {

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  nativeBuildInputs = [
    pkgs.makeWrapper
  ];

  postInstall = ''
    makeWrapper ${nodejs}/bin/npm $out/bin/odrive \
      --add-flags "start"
  '';
  
  meta = with stdenv.lib; {
    description = "GUI client for Google Drive";
    homepage = "https://github.com/liberodark/odrive";
    license = licenses.gpl3;
    maintainers =  with maintainers; [ ericdallo ];
    platforms = platforms.all;
  };
}
