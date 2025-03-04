alias d='docker'
alias dc='docker-compose'
alias de='docker exec -it $(docker ps | peco | cut -d " " -f 1) /bin/bash'
alias -g lb='`git branch | fzf --prompt "GIT BRANCH> " --no-multi | sed -e "s/^\*\s*//g"`'
alias k=kubectl
alias vim=nvim
