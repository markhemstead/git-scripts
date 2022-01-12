#!/usr/bin/env bash

# Options parsing in bash
declare -A longOpts=()
args=()

# loop through $[@] and find --${1}
allargs=("$@")
for (( i = 0; i < ${#@}; i++ )); do
    arg=${allargs[i]}

    # If it starts with -- then it's a longOpt
    if [[ "${arg}" =~ --* ]]; then
        # Formats: --arg value, --arg "value", --arg=value --arg="value"
        pattern='^--([a-z0-9_-]+)=(.+)'
        if [[ ${arg} =~ $pattern ]]; then
            longOpts+=(["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}")
            continue
        fi

        # --arg value and --arg "value"
        pattern='^--([a-z0-9_-]+)$'
        if [[ "${arg}" =~ $pattern ]]; then
            key="${BASH_REMATCH[1]}"

            if [[ ${allargs[i+1]} != "" ]]; then
                if ! [[ ${allargs[i+1]} =~ "-" ]]; then
                    longOpts+=(["${key}"]="${allargs[i+1]}")
                    i=$((i+1))
                fi
                continue
            fi

            # just give it a 1
            longOpts+=(["${key}"]=1)
            continue
        fi
    fi

    # Must be an argument value
    args+=("${arg}")
done

colorstring() {
    # Some special strings to convert:
    # "<error>" => "<red,invert>"
    # "</error>" => "</red,invert>"

    declare -A MYMAP

    MYMAP[bold]="1"
    MYMAP[dim]="2"
    MYMAP[underline]="4"
    MYMAP[blink]="5"
    MYMAP[invert]="7"
    MYMAP[hidden]="8"

    # Dark colours
    MYMAP[dark_red]="31"
    MYMAP[dark_green]="32"
    MYMAP[dark_yellow]="33"
    MYMAP[dark_blue]="34"
    MYMAP[dark_magenta]="35"
    MYMAP[dark_cyan]="36"

    # Light colours
    MYMAP[red]="91"
    MYMAP[green]="92"
    MYMAP[yellow]="93"
    MYMAP[blue]="94"
    MYMAP[magenta]="95"
    MYMAP[cyan]="96"

    MYMAP[error]="91;1"

    line="${1}"
    re='<([^/>]+)>'

    while [[ $line =~ $re ]]; do
        styles="${BASH_REMATCH:1:${#BASH_REMATCH}-2}"

        IFS=',' read -ra colors <<< "${styles}"

        s="\\e["

        # if it's comma-separated, split it!
        for color in "${colors[@]}"; do
            if [[ "${MYMAP[${color}]}" == "" ]]; then break; fi

            s="${s};${MYMAP[${color}]}"
        done

        s="${s};m"

        line=${line/${BASH_REMATCH}/${s}}

        # and replace the closing
        line=${line/<\/${styles}>/\\e[0m}
        line=${line/<\/>/\\e[0m}
    done

    echo -n "${line}"
}

# $1 = the string
# $2 = whether to skip datetime(3) prepending
write() {
    d=""
    if ! [[ "${2}" == "1" ]]; then
        # With colours light magenta and dark magenta
        d=$(date +"[<magenta>%F %H:%M:%S</magenta><dark_magenta>.%3N</dark_magenta>] ")
    fi

    str=$(colorstring "${d}${1}")

    echo -en "${str}"
}

writeln() {
    write "${1}" "${2}"
    echo ""
}

to_boolean() {
    value="${1}"

    if [[ "${value}" == "yes" || "${value}" == "1" || "${value}" == "on" || "${value}" == "true" ]]; then
        echo "1"
        exit
    fi

    echo "0";
}
