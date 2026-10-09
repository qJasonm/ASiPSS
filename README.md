

## Project layout

| Folder | What's in it |
|---|---|
| `frontend/` | The website: React + Vite (JavaScript). Node.js runs it. |
| `backend/` | The API: FastAPI (Python). [uv](https://docs.astral.sh/uv/) manages Python and its packages. |
| `setup.sh` | Sets up both. `frontend/setup.sh` and `backend/setup.sh` set up just one part. |

## First-time setup (once per computer)

`setup.sh` installs Node.js and uv if you don't have them. uv then installs the right Python version, so you don't need to install Python yourself. Last, the script installs each part's packages.

### Mac

1. **Open Terminal.** Press `Cmd + Space`, type *Terminal*, press Enter.
2. **Get the code:**
   ```bash
   git clone <repo-url>
   cd <repo-folder>
   ```
   On a new Mac, the first `git` command opens a popup asking to install the **Command Line Tools**. Click **Install**, wait until it finishes, then run `git clone` again.
3. **Run the setup:**
   ```bash
   bash setup.sh
   ```
4. **Close Terminal and open a new one** so it can find Node and uv.

**About permissions on Mac:**
- Typing `bash setup.sh` runs the script directly, so you **don't** need `chmod` and you **don't** need `sudo`.
- If you'd rather type `./setup.sh` and get `permission denied`, run this once: `chmod +x setup.sh`
- If macOS asks whether Terminal can access your Documents or Desktop folder, click **Allow**.

### Windows

1. **Install Git** from <https://git-scm.com/downloads/win> and keep the default options. This also installs **Git Bash**, which runs the setup script.
2. **Open Git Bash** from the Start menu.
3. **Get the code:**
   ```bash
   git clone <repo-url>
   cd <repo-folder>
   ```
   If the repo is private, a window opens asking you to sign in to GitHub.
4. **Run the setup:**
   ```bash
   bash setup.sh
   ```
   When Windows asks *"Do you want to allow this app to make changes to your device?"*, click **Yes**. That's the Node.js installer.
5. **Close Git Bash and open a new one** so it can find Node and uv.

**Use Git Bash, not PowerShell or Command Prompt.** They can't run `.sh` files.

### Linux / WSL

Same as Mac: open a terminal, clone, `cd` into the folder, run `bash setup.sh`.

## Running the app

Run the backend and the frontend at the same time, each in its own terminal window. Press `Ctrl + C` in a terminal to stop that part.

**Terminal 1, backend:**
```bash
cd <repo-folder>/backend
uv run fastapi dev
```
The API runs at <http://127.0.0.1:8000>. Open <http://127.0.0.1:8000/docs> to see and try every endpoint.

**Terminal 2, frontend:**
```bash
cd <repo-folder>/frontend
npm run dev
```
Open <http://localhost:5173>. When the frontend requests a path starting with `/api` (for example `fetch('/api/health')`), the dev server forwards it to the backend. Name every backend route `/api/...` so this works.

### Backend commands (run inside `backend/`)

| Command | What it does |
|---|---|
| `uv run fastapi dev` | Starts the API; it restarts when you save a file |
| `uv add <package>` | Adds a Python package (updates `pyproject.toml` and `uv.lock`) |
| `uv remove <package>` | Removes a Python package |
| `uv sync` | Installs the packages listed in `uv.lock` |
| `uv run <command>` | Runs a command with the project's Python and packages |

Use `uv add`, not `pip install`. uv keeps the packages in `backend/.venv`, so you don't need to activate a virtual environment.

### Frontend commands (run inside `frontend/`)

| Command | What it does |
|---|---|
| `npm run dev` | Starts the dev server; the page reloads when you save a file |
| `npm run build` | Builds the production version into `dist/` |
| `npm run preview` | Serves the `dist/` build locally |
| `npm run lint` | Checks the code for common mistakes |

## After pulling new changes

| If this changed | Run |
|---|---|
| `frontend/package.json` | `cd frontend && npm install` |
| `backend/pyproject.toml` or `backend/uv.lock` | `cd backend && uv sync` |

Running `bash setup.sh` again also works.

## Troubleshooting

| Problem | Fix |
|---|---|
| `node`, `npm` or `uv: command not found` | Close the terminal and open a new one. Still missing? Run `bash setup.sh` again. |
| Windows: `winget: command not found` | Open the Microsoft Store, update **App Installer**, then run `bash setup.sh` again. |
| Mac: `git clone` asks for a password and rejects yours | GitHub doesn't accept your account password in the terminal. Use a personal access token as the password, or sign in through GitHub Desktop. |
| Port 5173 is already in use | Vite picks the next free port; open the address it prints. |
| Port 8000 is already in use | The backend is probably still running in another terminal. Stop it there with `Ctrl + C`. |
| Frontend shows errors for `/api/...` requests | Start the backend (`cd backend && uv run fastapi dev`). |
