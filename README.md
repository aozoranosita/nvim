## nvim_config
my neovim configuration on MacOS

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
4. for theme-boththefish, you need to install powerline fonts and set the font in your terminal( including poerline fonts)
```bash
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
```
