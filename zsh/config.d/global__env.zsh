[ -e "${HOME}/.bin" ] && export PATH=$HOME/.bin:$PATH
[ -e "${HOME}/.local/bin" ] && export PATH=$HOME/.local/bin:$PATH
[ -e "${HOME}/.local/share/bin" ] && export PATH=$HOME/.local/share/bin:$PATH
[ -e "${HOME}/dotfiles/bin" ] && export PATH=$HOME/dotfiles/bin:$PATH
[ -e "${HOME}/Applications" ] && export PATH=$HOME/Applications:$PATH
[ -e "${HOME}/Applications/balena-cli" ] && export PATH=$HOME/Applications/balena-cli:$PATH
# [ -e "${HOME}/dotfiles/zsh/zfunctions" ] && fpath=( "${HOME}/dotfiles/zsh/zfunctions" $fpath )
