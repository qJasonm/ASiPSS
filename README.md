

## Contents

- [How the project fits together](#how-the-project-fits-together)
- [First-time setup](#first-time-setup-once-per-computer)
- [Running the app](#running-the-app)
- [Frontend](#frontend)
- [Backend](#backend)
- [The backend virtual environment (.venv)](#the-backend-virtual-environment-venv)
- [Git: what to commit](#git-what-to-commit)
- [After pulling new changes](#after-pulling-new-changes)
- [Troubleshooting](#troubleshooting)

## How the project fits together

The project has two parts that run at the same time while you develop:

- **Frontend** (`frontend/`): the website people see and click on. It is built with **React** (JavaScript) and run by **Vite**, a development server that reloads the page every time you save a file.
- **Backend** (`backend/`): the API that the website talks to. It is built with **FastAPI** (Python). It receives requests such as "give me the data" or "save this", does the work, and sends back JSON.

```
Browser  --->  Frontend (Vite, port 5173)  --- /api/... --->  Backend (FastAPI, port 8000)
```

During development, any request the frontend makes to a path starting with `/api` is forwarded to the backend automatically. That's why every backend route starts with `/api`.

```
ASiPSS/
  setup.sh              Sets up both parts (run this first)
  frontend/
    setup.sh            Sets up only the frontend
    index.html          The single HTML page; React fills it in
    src/
      main.jsx          Starts React and renders <App />
      App.jsx           The main component: start editing here
      App.css, index.css  Styles
      assets/           Images and files you import in code
    public/             Files served as-is (e.g. /favicon.svg)
    package.json        Frontend libraries and npm commands
    package-lock.json   Exact library versions (generated, commit it)
    vite.config.js      Vite settings, including the /api forwarding
  backend/
    setup.sh            Sets up only the backend
    app/
      main.py           The FastAPI app and its routes
    pyproject.toml      Backend libraries (managed by uv)
    uv.lock             Exact library versions (generated, commit it)
    .python-version     The Python version the project uses (3.13)
    .venv/              Python + installed libraries (created by setup, not in git)
```

## First-time setup (once per computer)

`setup.sh` installs everything you need:

- **Node.js**, which runs the frontend, and the frontend's libraries.
- **uv**, a tool that manages Python for the backend. uv installs the right Python version, creates the backend's virtual environment, and installs the backend's libraries. You do **not** need to install Python yourself.

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

### Setting up only one part

`bash frontend/setup.sh` or `bash backend/setup.sh` sets up just that part. Running any of the setup scripts again is safe.

## Running the app

You need **two terminals open at the same time**: one runs the backend, the other runs the frontend. Each one keeps running until you stop it.

**In VS Code:** open a terminal with **Terminal > New Terminal**. It opens in the repo folder. Click the **split** icon (or the **+**) in the terminal panel to get a second one.

**Terminal 1, backend:**
```bash
cd backend
uv run fastapi dev
```
Wait until it prints that the server is running at `http://127.0.0.1:8000`.

**Terminal 2, frontend:**
```bash
cd frontend
npm run dev
```
Then open <http://localhost:5173> in your browser.

**To stop** either one, click into its terminal and press `Ctrl + C` (on Mac too, not `Cmd`).

Both servers restart or reload on their own when you save a file, so you can leave them running while you work.

## Frontend

### What it does

The frontend is everything that runs in the browser: pages, buttons, forms and layout. React lets you build the page out of **components**, which are JavaScript functions that return HTML-like code (JSX). Vite serves the app while you develop and builds the final files for deployment.

### Where to start editing

- `frontend/src/App.jsx` is the main component. Change it and save; the browser updates immediately.
- Put new components in new files in `frontend/src/` (for example `src/NoteList.jsx`) and import them into `App.jsx`.
- Put images you use in code in `src/assets/` and import them (`import logo from './assets/logo.png'`).
- Put files that must keep their exact name and path in `public/`. `public/favicon.svg` is available at `/favicon.svg`.

### Calling the backend

Use `fetch` with a path that starts with `/api`. Vite forwards it to the backend, so you don't write `http://127.0.0.1:8000` anywhere.

Reading data (GET):
```jsx
import { useEffect, useState } from 'react'

function BackendStatus() {
  const [status, setStatus] = useState('loading...')

  useEffect(() => {
    fetch('/api/health')
      .then((res) => res.json())
      .then((data) => setStatus(data.status))
      .catch(() => setStatus('backend not reachable'))
  }, [])

  return <p>Backend status: {status}</p>
}
```

Sending data (POST):
```js
const res = await fetch('/api/notes', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ title: 'First note', body: 'Hello' }),
})
const data = await res.json()
```

The backend must be running (terminal 1) for these requests to work. The forwarding is set up in `frontend/vite.config.js` and only applies to `npm run dev`.

### Adding a frontend library

Run these inside `frontend/`:

| Command | What it does |
|---|---|
| `npm install <package>` | Adds a library the app uses, e.g. `npm install react-router` |
| `npm install -D <package>` | Adds a tool only developers need, e.g. a test runner |
| `npm uninstall <package>` | Removes a library |

npm records the library in `package.json` and `package-lock.json`. Commit both files so your teammates get it too.

### Frontend commands

Run these inside `frontend/`:

| Command | What it does |
|---|---|
| `npm run dev` | Starts the dev server at <http://localhost:5173>; the page reloads when you save a file |
| `npm run build` | Builds the production version into `dist/` |
| `npm run preview` | Serves the `dist/` build locally to check it |
| `npm run lint` | Checks the code for common mistakes |

## Backend

### What it does

The backend is a Python program that answers HTTP requests. Each **route** (also called an endpoint) is a Python function connected to a URL path. FastAPI takes care of turning requests into function arguments, checking the data, and turning your return value into JSON.

All backend code currently lives in `backend/app/main.py`.

### Getting to the backend

From the repo folder:
```bash
cd backend
```
Run every backend command (`uv run ...`, `uv add ...`, `uv sync`) from inside `backend/`. If you see `No pyproject.toml found`, you're in the wrong folder.

### Starting and trying the API

```bash
cd backend
uv run fastapi dev
```

- The API runs at <http://127.0.0.1:8000>.
- Open <http://127.0.0.1:8000/docs> to see every route and try it out from the browser: click a route, then **Try it out**, then **Execute**. This page updates automatically when you add routes.
- The server restarts automatically when you save a `.py` file.

### Adding a route

Add a function to `backend/app/main.py`, decorated with the HTTP method and path. Start every path with `/api`.

Reading data (GET), with a value taken from the URL:
```python
@app.get("/api/hello/{name}")
def hello(name: str):
    return {"message": f"Hello, {name}"}
```
Open <http://127.0.0.1:8000/api/hello/Ana> and you get `{"message": "Hello, Ana"}`.

Receiving data (POST): describe the expected JSON with a Pydantic model, and FastAPI checks every request against it.
```python
from pydantic import BaseModel


class Note(BaseModel):
    title: str
    body: str = ""


@app.post("/api/notes")
def create_note(note: Note):
    return {"saved": note}
```
If a request is missing `title`, FastAPI answers with status `422` and an error message explaining what's wrong. Your function doesn't run.

FastAPI's tutorial covers everything else: <https://fastapi.tiangolo.com/tutorial/>.

### Adding a backend library

Use **uv**, not pip. Run this inside `backend/`:

```bash
uv add pandas
```

That one command:
1. Installs pandas into `backend/.venv`.
2. Adds it to `pyproject.toml`.
3. Pins the exact version in `uv.lock`.

You don't edit `pyproject.toml` yourself. Commit `pyproject.toml` and `uv.lock` so your teammates get the library too.

You can run `uv add` while the backend server is running, from a second terminal. The server uses the new library the next time it reloads (save a `.py` file to trigger that). If you added the `import` before installing and the server shows `ModuleNotFoundError`, save the file again after `uv add`.

| Instead of (pip) | Run inside `backend/` | What it does |
|---|---|---|
| `pip install pandas` | `uv add pandas` | Installs and records a library |
| `pip install "pandas>=2.2"` | `uv add "pandas>=2.2"` | Same, with a minimum version |
| `pip install pytest` (tool only developers need) | `uv add --dev pytest` | Records it as a development-only library |
| `pip install -r requirements.txt` | `uv add -r requirements.txt` | Adds every library listed in the file |
| `pip uninstall pandas` | `uv remove pandas` | Uninstalls and removes it from the records |
| `pip install --upgrade pandas` | `uv sync --upgrade-package pandas` | Upgrades to the newest allowed version |
| `pip list` | `uv pip list` | Lists installed libraries |
| | `uv tree` | Shows which library depends on which |

**Why not `pip install`?** It installs the library only on your computer without recording it, so the code breaks for everyone else. The backend's `.venv` doesn't contain pip at all, so `pip install` would install into some other Python on your computer, even with the venv activated. (`uv pip install` exists too, but it has the same "not recorded" problem. Use `uv add`.)

**Windows:** if `uv add`, `uv remove` or `uv sync` fails with "access denied" or "file in use", stop the backend server with `Ctrl + C`, run the command again, then restart the server. Windows locks files a running program has loaded.

### Running other Python code

Put `uv run` in front of the command and it uses the backend's Python and libraries:

| Command | What it does |
|---|---|
| `uv run python script.py` | Runs a Python file |
| `uv run python` | Opens an interactive Python shell where you can `import pandas`, etc. |
| `uv run pytest` | Runs tests (after `uv add --dev pytest`) |

### Backend commands

Run these inside `backend/`:

| Command | What it does |
|---|---|
| `uv run fastapi dev` | Starts the API at <http://127.0.0.1:8000>; it restarts when you save a file |
| `uv add <package>` | Adds a library |
| `uv remove <package>` | Removes a library |
| `uv sync` | Installs exactly what's in `uv.lock` (run after pulling) |
| `uv run <command>` | Runs a command with the backend's Python and libraries |

## The backend virtual environment (.venv)

### What it is

A **virtual environment** is a folder that holds its own copy of Python plus the libraries one project needs. The backend's lives in `backend/.venv`. It keeps this project's library versions separate from your other projects and from the Python that came with your computer.

- `uv sync` (run by `setup.sh`) creates it and installs the libraries from `uv.lock` into it.
- It's listed in `.gitignore`, so it's never pushed. Everyone builds their own from `uv.lock`, and everyone ends up with identical versions.

### Do I need to activate it?

**No.** Every `uv run` and `uv add` command uses `backend/.venv` automatically, whether or not it's activated. You never have to create, activate or install into it by hand.

Activating is only useful if you want to type `python` or `fastapi` directly, without `uv run` in front.

### Checking whether it's active

When a venv is active, your terminal prompt starts with its name:

```
(asipss-backend) yourname@computer backend %
```

Or run:
```bash
echo $VIRTUAL_ENV
```
If it prints nothing, no venv is active. If it prints a path ending in `backend/.venv`, this project's venv is active.

### Activating and deactivating it (optional)

From inside `backend/`:

| | Command |
|---|---|
| Activate (Mac / Linux / WSL) | `source .venv/bin/activate` |
| Activate (Windows, Git Bash) | `source .venv/Scripts/activate` |
| Deactivate (all) | `deactivate` |

Activation only lasts for that terminal window. Even with it active, add libraries with `uv add`, not `pip install`.

### Using it in VS Code

Tell VS Code to use the venv's Python. Otherwise the editor underlines `import fastapi` as missing, even though the code runs fine.

1. Install the **Python** extension (by Microsoft) if you haven't.
2. Press `Cmd + Shift + P` (Mac) or `Ctrl + Shift + P` (Windows/Linux) and choose **Python: Select Interpreter**.
3. Pick the entry whose path is in `backend/.venv`. If it isn't listed, choose **Enter interpreter path...** and enter:
   - Mac / Linux: `backend/.venv/bin/python`
   - Windows: `backend\.venv\Scripts\python.exe`

New VS Code terminals may then activate the venv automatically. That's fine; `uv` commands work either way.

### If it gets broken

Delete the `backend/.venv` folder, then run `uv sync` inside `backend/`. uv rebuilds it from `uv.lock`.

### Python version

The project uses Python 3.13, set in `backend/.python-version`. uv downloads that version into its own folder if your computer doesn't have it, so the Python you have installed elsewhere doesn't matter. Changing the version is a team decision: it means editing `.python-version` and `requires-python` in `pyproject.toml`, then committing both.

## Git: what to commit

| Commit these | Never commit these (already in `.gitignore`) |
|---|---|
| Your code in `frontend/src/` and `backend/app/` | `frontend/node_modules/` (frontend libraries) |
| `frontend/package.json` and `frontend/package-lock.json` | `backend/.venv/` (Python and backend libraries) |
| `backend/pyproject.toml`, `backend/uv.lock`, `backend/.python-version` | `.env` files (passwords and secret keys) |

When you add a library, commit the files the add command changed in the same commit as the code that uses it.

## After pulling new changes

| If this changed | Run |
|---|---|
| `frontend/package.json` or `frontend/package-lock.json` | `cd frontend && npm install` |
| `backend/pyproject.toml` or `backend/uv.lock` | `cd backend && uv sync` |

Not sure what changed? Run `bash setup.sh` from the repo folder. It does both, and it's safe to run any time.

## Troubleshooting

| Problem | Fix |
|---|---|
| `node`, `npm` or `uv: command not found` | Close the terminal and open a new one. Still missing? Run `bash setup.sh` again. |
| `No pyproject.toml found` | You're not in the backend folder. Run `cd backend` first. |
| `npm error enoent Could not read package.json` | You're not in the frontend folder. Run `cd frontend` first. |
| `ModuleNotFoundError: No module named '...'` | If a teammate added the library, run `uv sync`. If it's new, run `uv add <name>`. Start the server with `uv run`, not plain `python`. |
| VS Code underlines imports like `fastapi` as missing | Select the `backend/.venv` interpreter (see [Using it in VS Code](#using-it-in-vs-code)). |
| `pip: command not found` | Use `uv add <package>` instead (see [Adding a backend library](#adding-a-backend-library)). |
| Frontend shows errors for `/api/...` requests | The backend isn't running. Start it in a second terminal: `cd backend && uv run fastapi dev`. |
| Port 8000 is already in use | The backend is probably still running in another terminal. Stop it there with `Ctrl + C`. |
| Port 5173 is already in use | Vite picks the next free port; open the address it prints. |
| Windows: `uv` says "access denied" or "file in use" | Stop the backend server with `Ctrl + C`, run the command again, then restart the server. |
| Windows: `winget: command not found` | Open the Microsoft Store, update **App Installer**, then run `bash setup.sh` again. |
| Mac: `git clone` asks for a password and rejects yours | GitHub doesn't accept your account password in the terminal. Use a personal access token as the password, or sign in through GitHub Desktop. |
