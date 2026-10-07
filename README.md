# ASiPSS Frontend

React + Vite + JavaScript.

## First-time setup (once per computer)

`setup.sh` installs Node.js (if you don't have it) and the project's packages.

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
4. **Close Terminal and open a new one** so it can find Node.

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
5. **Close Git Bash and open a new one** so it can find Node.

**Use Git Bash, not PowerShell or Command Prompt.** They can't run `.sh` files.

### Linux / WSL

Same as Mac: open a terminal, clone, `cd` into the folder, run `bash setup.sh`.

## Running the app

```bash
cd <repo-folder>
npm run dev
```

Open <http://localhost:5173>. Press `Ctrl + C` in the terminal to stop it.

| Command | What it does |
|---|---|
| `npm run dev` | Starts the dev server; the page reloads when you save a file |
| `npm run build` | Builds the production version into `dist/` |
| `npm run preview` | Serves the `dist/` build locally |
| `npm run lint` | Checks the code for common mistakes |

## After pulling new changes

If someone added packages (`package.json` changed), run `npm install`. Running `bash setup.sh` again also works.

## Troubleshooting

| Problem | Fix |
|---|---|
| `node: command not found` or `npm: command not found` | Close the terminal and open a new one. Still missing? Run `bash setup.sh` again. |
| Windows: `winget: command not found` | Open the Microsoft Store, update **App Installer**, then run `bash setup.sh` again. |
| Mac: `git clone` asks for a password and rejects yours | GitHub doesn't accept your account password in the terminal. Use a personal access token as the password, or sign in through GitHub Desktop. |
| Port 5173 is already in use | Vite picks the next free port; open the address it prints. |
