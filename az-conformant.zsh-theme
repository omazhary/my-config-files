function get_pwd() {
    echo "${PWD/$HOME/~}"
}

SEGMENT_SEPARATOR=$(echo "\ue0b0")

local host_name="%{%F{255}%K{069}%n@%m%F{069}%K{026}${SEGMENT_SEPARATOR}%}"
local path_string="%{%F{255}%K{026}$(get_pwd)%F{026}%K{255}${SEGMENT_SEPARATOR}%}"
local prompt_icon="%{%F{033}%K{255}>> %}"

PROMPT='

${host_name}${path_string}
${prompt_icon}${reset_color}'
