## nvim_config
my neovim configuration on MacOS
use this within tmux or color collapse

## usage
### keybindings
<leader> is set to `,` by default
<space>e to open Neotree
<leader>e to fussy findings
<space>c to CopilotChatOpen
<leader>rf to start R session
<leader>d to run R line under cursor
<leader>m3j to run 3 lines (m means motion, like `m)`to run cursor to end of the section)
<leader>bb to run between markers
<F5> for `uv run python` 

### command
`:te` to open terminal
<Tab> to accept copilot suggestion
<CR> to accept COC suggestion
select coc suggestion with arrow keys <up> and <down>

## Prerequisites
neovim >= 0.10.0
clang, python3, R, fzf, tmux, fish

## Installation
1. Clone this repository to your ~/.config/ directory
2. Install clang, python3, R, fzf,
```bash
brew install fzf
# install clang if you don't have installed, you can check it by 
clang --version
xcode-select --install 
```
3. R setup
```bash
brew install r
```
```R
install.packages(c('languageserver', 'httpgd'))
```

## other settings
### .tmux.conf
1. Install tmux
2. Copy .tmux.conf to your ~/ directory

### fish
1. Install fish
2. install fisher
```zsh
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
``` 
3. Install theme and plugins
```fish
fisher install oh-my-fish/theme-bobthefish
fisher install jethrokuan/z
fisher install jethrokuan/fzf
```
4. install nerd font for neotree and theme-bobthefish
```fish
brew install --cask font-hack-nerd-font
```
in terninal settings, select this font
