{ stdenv, fetchFromGitHub
, pkgs, makeWrapper, buildEnv
, nodejs, runtimeShell
}:

let
  nodePackages = import ./node.nix {
    inherit pkgs;
    system = stdenv.hostPlatform.system;
  };
  runtimeEnv = buildEnv {
    name = "ytmdesktop-runtime";
    paths = with nodePackages; [
      nodePackages."ws-^7.3.0"
      nodePackages."socket.io-^2.3.0"
      nodePackages."scribble-0.0.5"
      nodePackages."register-scheme-0.0.2"
      nodePackages."qrcode-generator-^1.4.4"
      nodePackages."npx-^10.2.2"
      nodePackages."node-vibrant-^3.1.5"
      nodePackages."node-fetch-^2.6.0"
      nodePackages."js-base64-^2.5.2"
      nodePackages."image-to-base64-^2.1.0"
      nodePackages."i18n-^0.10.0"
      nodePackages."electron-^9.0.4"
      nodePackages."electron-updater-^4.2.0"
      nodePackages."electron-store-^5.2.0"
      nodePackages."electron-native-notification-^1.2.1"
      nodePackages."electron-localshortcut-^3.2.1"
      nodePackages."electron-is-dev-^1.1.0"
      nodePackages."electron-google-analytics-^0.1.0"
      nodePackages."electron-clipboard-watcher-^1.0.1"
      nodePackages."electron-canvas-to-buffer-^2.0.0"
      nodePackages."discord-rpc-^3.1.0"
      nodePackages."ace-builds-^1.4.8"
      nodePackages."electron-builder-^22.7.0"
      nodePackages."husky-^3.1.0"
      nodePackages."prettier-^2.0.5"
      nodePackages."pretty-quick-^1.11.1"
    ];
  };

  name = "ytmdesktop-${version}";
  version = "1.11.0";

  src = stdenv.mkDerivation {
    name = "${name}-src";
    inherit version;

    src = fetchFromGitHub {
      owner = "ytmdesktop";
      repo = "ytmdesktop";
      rev = "v${version}";
      sha256 = "03jz6mz96fzpdzaksl4wnd9f9drnwk829v2633f5ki2x9b6f0f2n";
    };

    dontBuild = true;

    installPhase = ''
      mkdir $out
      cp -R . $out
    '';
  };
in stdenv.mkDerivation {
  inherit name version src;

  buildInputs = [ makeWrapper nodejs ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cat >$out/bin/ytmdesktop <<EOF
      #!${runtimeShell}
      ${nodejs}/bin/node ${src}/main.js
    EOF
  '';

  postFixup = ''
    chmod +x $out/bin/ytmdesktop
    wrapProgram $out/bin/ytmdesktop \
      --set NODE_PATH "${runtimeEnv}/lib/node_modules"
  '';

  meta = with stdenv.lib; {
    description = "YouTube Music Desktop App";
    license = licenses.cc0;
    homepage = "https://github.com/ytmdesktop/ytmdesktop";
    maintainers = with maintainers; [ ericdallo ];
    platforms = platforms.linux;
  };
}

