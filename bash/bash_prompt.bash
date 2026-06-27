__c() {
    local n="$1"
    [[ -n "$TERM" && "$TERM" != dumb ]] && printf '\[%s\]' "$(tput setaf "$n" 2>/dev/null)"
  }

  P_RESET='\['"$(tput sgr0 2>/dev/null)"'\]'
  P_RED="$(__c 1)"
  P_GREEN="$(__c 2)"
  P_YELLOW="$(__c 3)"
  P_BLUE="$(__c 4)"
  P_PURPLE="$(__c 5)"
  P_CYAN="$(__c 6)"
  P_BRIGHT_BLACK="$(__c 8)"
  P_PINK="$(__c 218)"

  __prompt_git() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

    local branch dirty ahead behind stash
    branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
    [[ -n "$branch" ]] && printf ' %s%s%s' "$P_BRIGHT_BLACK" "$branch" "$P_RESET"

    if ! git diff --no-ext-diff --quiet --exit-code --ignore-submodules 2>/dev/null ||
       [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
      dirty=1
    fi

    if [[ -n "$dirty" ]]; then
      printf ' %s*%s' "${P_PINK:-$P_PURPLE}" "$P_RESET"
    fi

    ahead="$(git rev-list --count @{upstream}..HEAD 2>/dev/null)"
    behind="$(git rev-list --count HEAD..@{upstream} 2>/dev/null)"
    stash="$(git stash list 2>/dev/null | wc -l | tr -d ' ')"

    local ab=
    [[ "$ahead" =~ ^[1-9] ]] && ab+="⇡$ahead"
    [[ "$behind" =~ ^[1-9] ]] && ab+="⇣$behind"
    [[ "$stash" =~ ^[1-9] ]] && ab+="≡"

    [[ -n "$ab" ]] && printf ' %s%s%s' "$P_CYAN" "$ab" "$P_RESET"
  }

  __prompt_command() {
    local status=$?
    history -a
    history -n
    [[ -z "$TMUX" && -n "$TERM" && "$TERM" != dumb ]] && printf '\e[5 q'

    local login=
    # if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    #   login="${P_YELLOW}${USER}${P_RESET}@${P_GREEN}${HOSTNAME%%.*}${P_RESET}:"
    # fi

    local venv=
    [[ -n "$VIRTUAL_ENV" ]] && venv="${P_BRIGHT_BLACK}$(basename "$VIRTUAL_ENV")${P_RESET} "

    local symbol_color="$P_PURPLE"
    [[ "$status" -ne 0 ]] && symbol_color="$P_RED"

    PS1="\n${login}${P_BLUE}\W${P_RESET}$(__prompt_git)\n${venv}${symbol_color}❯${P_RESET} "
    PS2="${P_PURPLE}❯${P_RESET} "
    }

PROMPT_COMMAND=__prompt_command
