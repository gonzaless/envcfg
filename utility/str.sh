#!/usr/bin/env bash

to_lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

version_lte() {
    if [[ -z $1 || -z $2 ]]; then
        fatal_error "version_lte is called with '$1' and '$2' while two non empty version arguments are expected"
    fi
    printf '%s\n' "$1" "$2" | sort -C -V
}

