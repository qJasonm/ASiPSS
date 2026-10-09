#!/usr/bin/env bash
# Dev environment setup for all of ASiPSS: the frontend (React + Vite) and the backend (FastAPI).
# After cloning the repo, run from the repo folder:   bash setup.sh
# To set up only one part:   bash frontend/setup.sh   or   bash backend/setup.sh
# macOS / Linux / WSL: use Terminal.   Windows: use Git Bash (installed with Git).

cd "$(dirname "$0")" || exit 1

echo "=== Frontend ==="
bash frontend/setup.sh || { echo "Frontend setup failed."; exit 1; }
echo
echo "=== Backend ==="
bash backend/setup.sh || { echo "Backend setup failed."; exit 1; }

echo
echo "All set. Open a new terminal, then start each part in its own terminal:"
echo "  Backend:   cd backend && uv run fastapi dev"
echo "  Frontend:  cd frontend && npm run dev"
