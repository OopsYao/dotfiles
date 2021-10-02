# ohmyzsh setting
# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-vi-mode zsh-syntax-highlighting zsh-autosuggestions history-substring-search)
source $ZSH/oh-my-zsh.sh

# Bind j and k for in vim mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

export EDITOR='nvr -s --remote-wait-silent'

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

# See https://askubuntu.com/questions/383462/unable-to-paste-with-xclip-outside-of-terminal
alias clip="xclip -selection clipboard"

mkfile() { mkdir -p "$(dirname "$1")" && touch "$1" ; }
alias e="nvim"
alias rg="ranger"
alias cat="bat"
alias ls="exa --icons"
alias plz="sudo"
alias pls="sudo"
alias please="sudo"

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

# Banner
if [[ -o login ]] then else
    pfetch
fi

# Miniconda
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
