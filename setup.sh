#!/usr/bin/env bash
# Dev environment setup for the ASiPSS frontend (React + Vite + JavaScript).
# After cloning the repo, run from the repo folder:   bash setup.sh
# macOS / Linux / WSL: use Terminal.   Windows: use Git Bash (installed with Git).

cd "$(dirname "$0")" || exit 1
NODE_VERSION="$(tr -d '[:space:]' < .nvmrc 2>/dev/null)"
NODE_VERSION="${NODE_VERSION:-24}"

# Vite needs Node 20.19+ or 22.12+
node_ok() {
  command -v node >/dev/null 2>&1 && node -e '
    const [a, b] = process.versions.node.split(".").map(Number);
    process.exit((a === 20 && b >= 19) || (a === 22 && b >= 12) || a >= 23 ? 0 : 1)'
}

case "$(uname -s)" in
  MINGW* | MSYS* | CYGWIN*)  # Windows (Git Bash): install Node LTS with winget
    if ! node_ok; then
      echo "Installing Node.js LTS (Windows may ask for permission)..."
      winget install -e --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements
      export PATH="/c/Program Files/nodejs:$PATH"
    fi ;;
  *)  # macOS, Linux, WSL: install Node with nvm
    command -v curl >/dev/null || { echo "Please install curl first (Ubuntu: sudo apt install curl)"; exit 1; }
    export NVM_DIR="$HOME/.nvm"
    if [ ! -s "$NVM_DIR/nvm.sh" ]; then
      echo "Installing nvm..."
      touch "$HOME/.$(basename "${SHELL:-bash}")rc"  # nvm adds itself to this file (a new Mac has no ~/.zshrc)
      curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
    fi
    # shellcheck source=/dev/null
    . "$NVM_DIR/nvm.sh" --no-use
    nvm install "$NODE_VERSION" && nvm alias default "$NODE_VERSION" ;;
esac

node_ok || { echo "Node.js 20.19+ or 22.12+ is required, and it could not be installed."; exit 1; }
echo "Using Node $(node -v) and npm $(npm -v)"

if [ -f package-lock.json ]; then npm ci; else npm install; fi || exit 1

echo
echo "Setup complete. Open a new terminal, then run:  npm run dev"
