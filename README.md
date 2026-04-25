# Neovim Configuration (`nvim_config`)

A personal, highly optimized Neovim configuration built for macOS (with cross-platform support for WSL/Windows). Designed to be used within `tmux` or any modern terminal with True Color support.

## 📦 Prerequisites

Ensure you have the following installed before setting up this configuration:
* **Neovim** (`>= 0.10.0`)
* **Compilers & Runtimes**: `clang`, `python3` (with `uv`), `R`
* **Tools**: `fzf`, `tmux`, `fish`

## 🚀 Installation

### 1. Clone the repository
Clone this configuration directly into your Neovim config directory:
```bash
git clone https://github.com/aozoranosita/nvim.git ~/.config/nvim
```

### 2. System Dependencies

Choose the installation commands based on your operating system:

#### 🍎 macOS
Install the core tools using [Homebrew](https://brew.sh/):
```bash
# Install core tools and uv (Python package manager)
brew install fzf r uv

# Install clang (via Xcode Command Line Tools)
xcode-select --install
# Verify installation: clang --version
```
#### 🐧 Arch Linux (WSL)

Update your package database and install the required tools using pacman:
```Bash
sudo pacman -Syu fzf r gcc uv
```
> **Note for WSL users**: > - This config uses SumatraPDF installed on the Windows host as the TeX viewer.
    To share the clipboard between Neovim (WSL) and Windows, ensure win32yank.exe is installed on your Windows system and accessible via your WSL $PATH.

#### 🪟 Windows

Install the required tools using Scoop:
```PowerShell
# Install core tools, uv, and SumatraPDF
scoop install fzf gcc uv sumatrapdf
```
> **Note**: Please install R from the official CRAN website. This config uses SumatraPDF as the default TeX viewer.

### 3. R Setup
Start an R session in your terminal and install the required packages for the R language server and plotting:
```R
install.packages(c('languageserver', 'httpgd'))
```

## ⌨️ Keybindings

The `<leader>` and `<localleader>` keys are both set to `,`.

| Keybinding | Action |
| :--- | :--- |
| `,` | `<leader>` and `<localleader>` key |
| `<Space>e` | Open Neo-tree (File Explorer) |
| `<Leader>e` | Open Fzf-lua (Fuzzy file finder) |
| `<Space>c` | Open Copilot Chat |
| `<F5>` | Run the current Python script via `uv` (`uv run python %`) |
| `<Localleader>rf` | Start R session |
| `<Localleader>d` | Run the R code line under the cursor |
| `<Localleader>m3j` | Run 3 lines of R code (supports standard motions) |
| `<Localleader>bb` | Run R code between markers |
| `jj` | Exit insert mode (`<ESC>`) |

### Auto-Completion & Suggestions
| Keybinding | Action |
| :--- | :--- |
| `<Tab>` | Accept GitHub Copilot suggestion / Select next item |
| `<CR>` | Accept Coc.nvim suggestion |
| `<C-j>` / `<C-k>` | Navigate Coc suggestions (Down / Up) |

### Commands
| Command | Action |
| :--- | :--- |
| `:te` | Open terminal buffer |

---

## 🛠️ Environment Setup

To get the full experience, including properly rendered icons and a styled prompt, please configure your terminal environment as follows:

### Fonts (Nerd Fonts)
Install `Hack Nerd Font` to ensure icons in Neo-tree and lualine render correctly:
```bash
brew install --cask font-hack-nerd-font
```
> **Note:** After installation, you must set "Hack Nerd Font" as the default font in your terminal emulator's preferences.

### Tmux
1. Install tmux: `brew install tmux`
2. Copy the `.tmux.conf` file from this repository to your home directory:
   ```bash
   cp .tmux.conf ~/.tmux.conf
   ```

### Fish Shell
1. Install fish: `brew install fish`
2. Install [Fisher](https://github.com/jorgebucaran/fisher) (Plugin Manager):
   ```bash
   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
   ```
3. Install the required Fish plugins and themes:
   ```bash
   fisher install oh-my-fish/theme-bobthefish
   fisher install jethrokuan/z
   fisher install jethrokuan/fzf
   ```
