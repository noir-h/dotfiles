# ~/.zshrc
if [[ -f ~/.zsh/alias.zsh ]]; then
  source ~/.zsh/alias.zsh
fi

# eval
eval "$(starship init zsh)"
eval "$(mise activate zsh)"

# >>> ghq peco settings >>>
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^y' peco-src
# <<< ghq peco settings <<<

# search a destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

# share .zshhistory
setopt inc_append_history
setopt share_history

# >>> peco   settings >>>
function gke-activate() {
  name="$1"
  zone_or_region="$2"
  if echo "${zone_or_region}" | grep '[^-]*-[^-]*-[^-]*' > /dev/null; then
    echo "gcloud container clusters get-credentials \"${name}\" --zone=\"${zone_or_region}\""
    gcloud container clusters get-credentials "${name}" --zone="${zone_or_region}"
  else
    echo "gcloud container clusters get-credentials \"${name}\" --region=\"${zone_or_region}\""
    gcloud container clusters get-credentials "${name}" --region="${zone_or_region}"
  fi
}
function kx-complete() {
  _values $(gcloud container clusters list | awk '{print $1}')
}
function kx() {
  name="$1"
  if [ -z "$name" ]; then
    line=$(gcloud container clusters list | peco)
    name=$(echo $line | awk '{print $1}')
  else
    line=$(gcloud container clusters list | grep "$name")
  fi
  zone_or_region=$(echo $line | awk '{print $2}')
  gke-activate "${name}" "${zone_or_region}"
}
#compdef kx-complete kx

function gcloud-activate() {
  name="$1"
  project="$2"
  echo "gcloud config configurations activate \"${name}\""
  gcloud config configurations activate "${name}"
}
function gx-complete() {
  _values $(gcloud config configurations list | awk '{print $1}')
}
function gx() {
  name="$1"
  if [ -z "$name" ]; then
    line=$(gcloud config configurations list | peco)
    name=$(echo "${line}" | awk '{print $1}')
  else
    line=$(gcloud config configurations list | grep "$name")
  fi
  project=$(echo "${line}" | awk '{print $4}')
  gcloud-activate "${name}" "${project}"
}
#compdef gx-complete gx
# <<< peco cdr settings <<<

[[ -s "/Users/igarashisora/.gvm/scripts/gvm" ]] && source "/Users/igarashisora/.gvm/scripts/gvm"

# zsh-completions, zsh-autosuggestions
source <(kubectl completion zsh)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# compinit を実行して補完システムを初期化
autoload -Uz compinit && compinit

# fzf history
function fzf-select-history() {
    BUFFER=$(history -n -r 1 | sort -u | fzf --query "$LBUFFER" --reverse)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

eval "$(sheldon source)"

export XDG_CONFIG_HOME="$HOME/.config"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


