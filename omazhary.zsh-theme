# Basic characters and formatting
right_triangle() {
   echo $'\ue0b0'
}

prompt_indicator() {
    echo $'%B\u276f%b'
}

arrow_start() {
    echo "%{$FG[$ARROW_FG]%}%{$BG[$ARROW_BG]%}%B"
}

arrow_end() {
    echo "%b%{$reset_color%}%{$FG[$NEXT_ARROW_FG]%}%{$BG[$NEXT_ARROW_BG]%}$(right_triangle)%{$reset_color%}"
}

# Username@Host
username() {
    ARROW_FG="235"
    ARROW_BG="025"
    NEXT_ARROW_BG="221"
    NEXT_ARROW_FG="025"
    echo "$(arrow_start) %n@%m $(arrow_end)"
}

# Current Directory
directory() {
    ARROW_FG="235"
    ARROW_BG="221"
    NEXT_ARROW_BG="248"
    NEXT_ARROW_FG="221"
    GIT_LENGTH=`expr length "$(git_prompt_info)"`
    if [ $GIT_LENGTH -eq 0 ]; then
        NEXT_ARROW_BG="235"
    fi
    echo "$(arrow_start) %1~ $(arrow_end)"
}

# Git Settings
# > Set the git_prompt_info text
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
# > Set the git_prompt_status text
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}~%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}-%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}r%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}um%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}*%{$reset_color%}"
# > Git status function
git_status() {
   ARROW_FG="235"
   ARROW_BG="248"
   NEXT_ARROW_BG="235"
   NEXT_ARROW_FG="248"
   GIT_LENGTH=`expr length "$(git_prompt_info)"`
    if [ ! $GIT_LENGTH -eq 0 ]; then
        echo "$(arrow_start) $(git_prompt_info) $(arrow_end)"
    fi
}

PROMPT='%B$(username)$(directory)$(git_status)%b '
RPROMPT=''
