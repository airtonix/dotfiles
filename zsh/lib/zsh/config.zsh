#!/usr/bin/env zsh

. "${DOTFILE_ROOT}/lib/sh/osinformation.sh"

function config_enable () {
    local name=$1

    enable_config_part "${name}__zgen"
    enable_config_part "${name}__profile"
    enable_config_part "${name}__config"
    enable_config_part "${name}__env"
    enable_config_part "${name}__aliases"

    list_configs
}

function edit_config () {
    local name=$1
    local regex="(${name:-"[a-zA-Z\-]*"})__([a-zA-Z\-]*).zsh"
    local configs=()

    for file in $DOTFILE_ROOT/config.d/available/*.zsh; do
        if [[ $file =~ $regex ]];
        then
            configs+=("${match[1]}__${match[2]}")
        fi
    done
    local count=${#configs[@]}

    if [ "${count}" -gt "0" ] && {
        echo $count items found

        for (( i = 1; i < ${count} + 1; i++ )) do
            echo "$i) ${configs[$i]}"
        done

        echo "Choose item to edit >"
        read choice

        micro $DOTFILE_ROOT/config.d/available/${configs[$choice]}.zsh
    }
}

function enable_config_part () {
    local name=$1
    [ -e "${DOTFILE_ROOT}/config.d/enabled/${name}.zsh" ] && {
        echo "💫 ${name} already enabled."
        return 0;
    }
    [ ! -e "${DOTFILE_ROOT}/config.d/available/${name}.zsh" ] && {
        return 0;
    }

    ln -s \
        "${DOTFILE_ROOT}/config.d/available/${name}.zsh" \
        "${DOTFILE_ROOT}/config.d/enabled/${name}.zsh"

    [ -e "${DOTFILE_ROOT}/config.d/available/${name}-${OSINFO_PLATFORM}.zsh" ] \
    && [ ! -e "${DOTFILE_ROOT}/config.d/enabled/${name}-${OSINFO_PLATFORM}.zsh" ] \
    && {
        ln -s \
            "${DOTFILE_ROOT}/config.d/available/${name}-${OSINFO_PLATFORM}.zsh" \
            "${DOTFILE_ROOT}/config.d/enabled/${name}-${OSINFO_PLATFORM}.zsh"
    }

    echo "✅ ${name} enabled."
}

function config_disable () {
    local name=$1

    disable_config_part "${name}__zgen"
    disable_config_part "${name}__profile"
    disable_config_part "${name}__config"
    disable_config_part "${name}__env"
    disable_config_part "${name}__aliases"

    list_configs
}

function disable_config_part () {
    local name=$1
    [ ! -e "${DOTFILE_ROOT}/config.d/enabled/${name}.zsh" ] && return 0;

    rm "${DOTFILE_ROOT}/config.d/enabled/${name}.zsh"

    [ -e "${DOTFILE_ROOT}/config.d/enabled/${name}-${OSINFO_PLATFORM}.zsh" ] && {
        rm "${DOTFILE_ROOT}/config.d/enabled/${name}-${OSINFO_PLATFORM}.zsh"
    }

    echo "✅ ${name} disabled."
}

function config_enabled_marker () {
    if test -n "$(find $DOTFILE_ROOT/config.d/enabled/ -maxdepth 1 -name "${1}*" -print -quit)"
    then
        echo "🔅"
    else
        echo "  "
    fi
}

function list_configs () {
    regex="([a-zA-Z\-]*)__([a-zA-Z\-]*).zsh"
    configs=()
    echo "🗒 Listing config modules";

    for file in $DOTFILE_ROOT/config.d/available/*.zsh; do
        if [[ $file =~ $regex ]];
        then
            configs+=("${match[1]}")
        fi
    done

    for config in $(echo "${configs[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '); do
        echo "$(config_enabled_marker $config) ${config}"
    done

}

function reload () {
    source ~/.zshrc
}

function config () {
    # echo "test ${@}"
    case "${1}" in
        enable)
            config_enable "${2}"
        ;;
        disable)
            config_disable "${2}"
        ;;
        list)
            list_configs "${2}"
        ;;
        edit)
            edit_config "${2}"
        ;;
        reload)
            reload
        ;;
        *)
            echo """
Commands are

enable    <item>                enables a config item
disable   <item>                disables an item
list      <enabled|available>   shows all available items
edit      partname              edits item
reload                          reloads profile
"""
        ;;
    esac

}
