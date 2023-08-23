# ohmyzsh setting
# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-vi-mode zsh-autosuggestions history-substring-search zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Bind j and k for in vim mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Proxy
proxy_socks="socks5://localhost:7891"
proxy_http="http://localhost:7890"
alias fuckgfw="export http_proxy=$proxy_http && export https_proxy=$proxy_http \
    && export HTTP_PROXY=$proxy_http && export HTTPS_PROXY=$proxy_http"
alias unfuckgfw="unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY"
alias fuckgit="git config --global http.proxy '$proxy_socks' \
    && git config --global https.proxy '$proxy_socks'"
alias unfuckgit="git config --global --unset http.proxy \
    && git config --global --unset https.proxy"
fuckgfw

# X11: https://askubuntu.com/a/383473
# Wayland: https://superuser.com/a/1377550
clip() {
  if [[ "$XDG_SESSION_TYPE" = "wayland" ]]; then
    wl-copy
  else
    xclip -selection clipboard
  fi
}

mkfile() { mkdir -p "$(dirname "$1")" && touch "$1" ; }
alias e="nvim"
alias cat="bat"
alias ls="exa --icons"
alias plz="sudo"
alias pls="sudo"
alias please="sudo"
# Fix issues on some remotes as then do not recognize alacritty
alias ssh="TERM=xterm-256color ssh"
alias lzd="lazydocker"

if command -v thefuck &> /dev/null
then
    eval $(thefuck --alias fk)
fi

# Ranger shell prompt indicator (nested shell)
if [ -n "$RANGER_LEVEL" ]; then export PS1="[RG] $PS1"; fi

# z https://github.com/rupa/z
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# Easy python/conda virtual env
venv() {
    venv_dir=${1:=./.venv}
    if [[ -f "$venv_dir/pyvenv.cfg" ]]; then
        source $venv_dir/bin/activate 
    else
        conda activate $venv_dir \
        && alias deactivate="conda deactivate && unalias deactivate"
    fi
}
# Activate pyvenv if possible
if [[ -f "./.venv/pyvenv.cfg" ]]; then
    venv
fi

# Greeting
if [[ -o login ]] then else
    if command -v neofetch &> /dev/null
    then
        # Only for home directory
        if [[ "$HOME" == "$(pwd)" ]] then
            if [[ "$XDG_SESSION_TYPE" == "wayland" ]] then
                neofetch --backend catimg
            else
                if [[ "$TERM" == "xterm-kitty" ]] then
                    neofetch --backend kitty
                else
                    neofetch
                fi
            fi
        fi
    fi
fi

# Miniconda
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# Update system and neovim plugins
alias btw="yay && nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"

# Pyenv https://github.com/pyenv/pyenv
if command -v pyenv &> /dev/null
then
    eval "$(pyenv init -)"
fi
