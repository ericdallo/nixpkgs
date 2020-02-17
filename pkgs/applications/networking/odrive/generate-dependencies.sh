#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

node2nix \
  --nodejs-10 \
  --development \
  --node-env ../../../development/node-packages/node-env.nix \
  --input node-packages.json \
  --output node-packages.nix \
  --composition odrive.nix \
