{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = with pkgs; [
    nodejs
    curl
    git
    docker-client
    docker-compose
  ];
  shellHook = ''
    if [ -x "$HOME/.meteor/meteor" ]; then
      export PATH="$HOME/.meteor:$PATH"
    fi
    echo "DiceCloud development shell ready. Run ./scripts/dev.sh help"
  '';
}
