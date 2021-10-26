#!/usr/bin/env bash

repo() {
    repo=$(git remote show origin -n | grep "Fetch" | awk '{print $3}')
    repo=${repo:15:-4}

    echo "${repo}"
}

current_branch() {
    git symbolic-ref --short -q HEAD
}

previous_branch() {
    git describe --all $(git rev-parse @{-1}) | cut -c7-
}

colorstring() {
    declare -A MYMAP
    MYMAP[red]="\\e[91m"
    MYMAP[green]="\\e[92m"
    MYMAP[yellow]="\\e[93m"
    MYMAP[blue]="\\e[94m"
    MYMAP[magenta]="\\e[95m"
    MYMAP[cyan]="\\e[96m"

    line="${1}"
    re='<([^/>]+)>'

    while [[ $line =~ $re ]]; do
        color="${BASH_REMATCH:1:${#BASH_REMATCH}-2}"

        if [[ "${MYMAP[${color}]}" == "" ]]; then break; fi

        line=${line/${BASH_REMATCH}/${MYMAP[${color}]}}

        # and replace the closing
        line=${line/<\/${color}>/\\e[0m}
    done

    echo -en "${line}"
}

write() {
    str=$(colorstring "${1}")
    echo -en "${str}"
}

writeln() {
    write "${1}"
    echo ""
}

gh_exists() {
    gh > /dev/null 2>&1
    [[ "${?}" != "127" ]] && echo "1" || echo "0"
}
