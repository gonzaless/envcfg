#!/usr/bin/env bash

os_type() {
    case "$OSTYPE" in
        linux-gnu*)
            echo "linux"
            ;;
        darwin*)
            echo "darwin"
            ;;
        cygwin* | msys* | win32*)
            echo "windows"
            ;;
        *)
            echo "$OSTYPE"
            return 1
            ;;
    esac
}

