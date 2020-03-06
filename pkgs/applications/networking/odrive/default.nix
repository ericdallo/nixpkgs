{ fetchurl,
  lib,
  symlinkJoin,
  appimageTools,
  stdenv
}:

let
  pname = "odrive";
  version = "0.3.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/liberodark/ODrive/releases/download/${version}/OpenDrive.${version}.AppImage";
    sha256 = "0jnz3cgl5306yq5cr1ql9s9glbfcajqf5s7rgf99zxfgmgkgydnp";
    name="${pname}-${version}.AppImage";
  };

  binary = appimageTools.wrapType2 {
    name = pname;
    inherit src;
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in symlinkJoin {
  inherit name;
  paths = [ binary ];

  postBuild = ''
      install -m 444 -D ${appimageContents}/odrive.desktop $out/share/applications/odrive.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/odrive.png \
        $out/share/icons/hicolor/512x512/apps/odrive.png

      substituteInPlace $out/share/applications/odrive.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
  '';
  
  meta = with stdenv.lib; {
    description = "GUI client for Google Drive";
    homepage = "https://github.com/liberodark/odrive";
    license = licenses.gpl3;
    maintainers =  with maintainers; [ ericdallo ];
    platforms = platforms.all;
  };
}
