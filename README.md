# gt — simple git flow CLI

A minimal, fast git workflow tool. Works on **Mac, Windows, Linux**.

## Install

**Mac / Linux**
```bash
curl -fsSL https://raw.githubusercontent.com/procloudify/gt/main/install.sh | bash
```

**Mac (Homebrew)**
```bash
brew tap procloudify/gt
brew install gt
```

**Windows — PowerShell (recommended, no Scoop needed)**
```powershell
iwr https://raw.githubusercontent.com/procloudify/gt/main/install.ps1 | iex
```
> Requires Git for Windows (includes Git Bash). [Download here](https://git-scm.com/download/win) if you don't have it.

**Windows (Scoop)**
```powershell
scoop bucket add gt https://github.com/procloudify/scoop-gt
scoop install gt
```

---

## Update

```bash
gt update
```

Works on Mac, Linux, and Windows (Git Bash / WSL). Checks the current version and only downloads if there's something newer.

**Windows (Scoop)**
```powershell
scoop update gt
```

---

## Uninstall

```bash
gt uninstall
```

Works on Mac, Linux, and Windows (Git Bash / WSL). Confirms before removing.

**Windows (Scoop)**
```powershell
scoop uninstall gt
```

---

## Commands

| Command | What it does |
|---|---|
| `gt init` | Init repo + `.version` + `.gitignore` |
| `gt push [major\|minor\|patch]` | Bump version + commit + push `main` |
| `gt dev [message]` | Commit + push to `dev` branch |
| `gt branch <name>` | Create + push a new branch |
| `gt switch [name]` | Switch branch (interactive picker if no name) |
| `gt pull [branch]` | Pull from branch (default: current) |
| `gt merge [branch]` | Merge branch into current |
| `gt status` | Pretty status + version info |
| `gt log [n]` | Last n commits (default: 10) |
| `gt version [major\|minor\|patch]` | Bump `.version` file only |

## Examples

```bash
# Start a new project
gt init
gt branch feature/login

# Work + save to dev
gt dev "added login form"

# Ship to main with version bump
gt push           # 1.0.0 → 1.0.1 (patch)
gt push minor     # 1.0.1 → 1.1.0
gt push major     # 1.1.0 → 2.0.0

# Pull latest
gt pull
gt pull main

# Merge a feature
gt switch main
gt merge feature/login

# See what's going on
gt status
gt log 20
```

## How versioning works

`gt` keeps a `.version` file in your project root. Every `gt push` reads it, bumps the patch number (or major/minor if you specify), writes the new version back, and uses it as the commit message.

## License

MIT
