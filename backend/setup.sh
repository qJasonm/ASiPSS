#!/usr/bin/env bash
# Dev environment setup for the ASiPSS backend (FastAPI + Python, managed with uv).
# After cloning the repo, run from the repo folder:   bash backend/setup.sh
# macOS / Linux / WSL: use Terminal.   Windows: use Git Bash (installed with Git).

cd "$(dirname "$0")" || exit 1

# uv installs the Python version in .python-version and the packages in uv.lock
if ! command -v uv >/dev/null 2>&1; then
  echo "Installing uv..."
  case "$(uname -s)" in
    MINGW* | MSYS* | CYGWIN*)  # Windows (Git Bash): use uv's PowerShell installer
      powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex" ;;
    *)  # macOS, Linux, WSL
      command -v curl >/dev/null || { echo "Please install curl first (Ubuntu: sudo apt install curl)"; exit 1; }
      curl -LsSf https://astral.sh/uv/install.sh | sh ;;
  esac
  export PATH="$HOME/.local/bin:$PATH"  # where both installers put uv
fi

command -v uv >/dev/null 2>&1 || { echo "uv is required, and it could not be installed."; exit 1; }
echo "Using $(uv --version)"

[ -f pyproject.toml ] || { echo "pyproject.toml not found. Run this script from the repo folder after cloning."; exit 1; }
uv sync || exit 1

echo
echo "Setup complete. Open a new terminal, then run:  cd backend && uv run fastapi dev"
