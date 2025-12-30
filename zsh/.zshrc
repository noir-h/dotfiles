[ -f ~/.zsh/alias.zsh ] && source ~/.zsh/alias.zsh

# compinit を実行して補完システムを初期化
autoload -Uz compinit && compinit

# eval
eval "$(starship init zsh)"
eval "$(mise activate zsh)"
eval "$(sheldon source)"

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

# share .zshhistory
setopt inc_append_history
setopt share_history

# zsh-completions, zsh-autosuggestions
# source <(kubectl completion zsh)
# source <(docker completion zsh)
# source <(docker compose completion zsh)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export XDG_CONFIG_HOME="$HOME/.config"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# fzf history
function fzf-select-history() {
    BUFFER=$(history -n -r 1 | sort -u | fzf --query "$LBUFFER" --reverse)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

function ghq_fzf_cd_widget() {
  local repo
  repo=$(ghq list | fzf)
  [[ -n "$repo" ]] && cd "$(ghq root)/$repo"
  zle clear-screen
}
zle -N ghq_fzf_cd_widget
bindkey '^y' ghq_fzf_cd_widget

