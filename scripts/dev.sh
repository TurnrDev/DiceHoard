#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
app="$root/app"
compose=(docker compose -f "$root/docker-compose.dev.yml")

run_meteor() {
  if command -v meteor >/dev/null 2>&1; then
    command meteor "$@"
  elif [ -x "$HOME/.meteor/meteor" ]; then
    "$HOME/.meteor/meteor" "$@"
  else
    echo "Meteor is missing. Run: ./scripts/dev.sh bootstrap-meteor" >&2
    exit 1
  fi
}

case "${1:-help}" in
  bootstrap-meteor)
    if command -v meteor >/dev/null 2>&1 || [ -x "$HOME/.meteor/meteor" ]; then
      run_meteor --version
      exit 0
    fi
    echo "Installing the Meteor CLI into ~/.meteor using the official installer…"
    curl https://install.meteor.com/ | sh
    ;;
  up-db)
    "${compose[@]}" up -d mongo
    ;;
  down-db)
    "${compose[@]}" down
    ;;
  install)
    (cd "$app" && run_meteor npm install)
    ;;
  run)
    "${compose[@]}" up -d mongo
    cd "$app"
    export MONGO_URL="mongodb://meteor:meteor@127.0.0.1:27017/dicecloud?authSource=admin"
    export ROOT_URL="http://localhost:3000"
    run_meteor run --raw-logs --settings "$root/settings.dev.json"
    ;;
  help|*)
    cat <<'EOF'
Usage:
  ./scripts/dev.sh bootstrap-meteor  Install Meteor once (official installer).
  ./scripts/dev.sh up-db             Start only the local MongoDB container.
  ./scripts/dev.sh install           Install app Node dependencies.
  ./scripts/dev.sh run               Run Meteor locally with hot reload at :3000.
  ./scripts/dev.sh down-db           Stop the MongoDB container.
EOF
    ;;
esac
