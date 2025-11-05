#!/bin/sh

trigger_editor_remote_editing() (
    # Enable bash-style arrays in zsh (if running in zsh)
    setopt ksh_arrays 2> /dev/null || true

    REMOTE_EDITOR=$1
    FTYPE=$2
    MACHINE=$3
    FILEPATHS=( "$@" )
    FILEPATHS=( "${FILEPATHS[@]:3}" )

    # Logging configuration
    LOGFILE=/tmp/iterm-trigger-remote-editor.log
    TS="["$(date "+%Y-%m-%d %H:%M:%S")"]"

    # Parse and validate IDE argument
    case "$1" in
        cursor)
            IDE='/usr/local/bin/cursor'
            ;;
        code)
            IDE='/usr/local/bin/code'
            ;;
        *)
            echo "${TS} Error: Invalid REMOTE_EDITOR type '${REMOTE_EDITOR}'. Must be 'cursor' or 'code'." >> ${LOGFILE}
            exit 1
            ;;
    esac

    echo "${TS} Triggered: ""$@" >> ${LOGFILE}

    if [[ "${FTYPE}" == "directory" ]]; then
        # Open directory as a workspace folder
        CMD="${IDE} --folder-uri vscode-remote://ssh-remote+${MACHINE}${FILEPATHS[@]}"
        echo "${TS} ${CMD}" >> ${LOGFILE}
        ${CMD}

    elif [[ "${FTYPE}" == "file" ]]; then
        # Open each file individually
        for FN in ${FILEPATHS[@]}; do
            CMD="${IDE} --file-uri vscode-remote://ssh-remote+${MACHINE}${FN}"
            echo "${TS} ${CMD}" >> ${LOGFILE}
            ${CMD}
        done

    else
        # Invalid file type argument
        echo "${TS} Error: Invalid file type '${FTYPE}'. Must be 'directory' or 'file'." >> ${LOGFILE}
        exit 1
    fi
)

trigger_editor_remote_editing "$@"

