MACHINE="$(hostnamectl hostname).local"
#MACHINE=`echo $SSH_CONNECTION | cut -d' ' -f3`

_localeditor() {
    IDE=$1
    shift

    CMD=ITERM-TRIGGER-remote-editor
    FILENAMES=( "$@" )

    if [[ ${#FILENAMES[@]} == 0 ]]; then
        FILENAMES=.
    fi

    if [[ ${#FILENAMES[@]} == 1 && -d ${FILENAMES[0]} ]]; then
        FILENAMES[0]=$(cd ${FILENAMES[0]}; pwd)
        FTYPE=directory
    else
        FTYPE=file
        for (( i=0; i < ${#FILENAMES[@]}; i++ )); do
            FILENAME=${FILENAMES[i]}
            if [[ -f ${FILENAME} ]]; then
                DIRNAME=$(cd $(dirname ${FILENAME}); pwd)
                FILENAMES[i]=${DIRNAME}/$(basename ${FILENAME})
            else
                1>&2 echo "Not a valid file: ${FILENAME}"
                exit 1
            fi
        done
    fi

    echo ${CMD} ${IDE} ${FTYPE} ${MACHINE} ${FILENAMES[@]}
}

localcursor() {
    _localeditor "cursor" "$@"
}

localcode() (
    _localeditor "code" "$@"
)

export -f localcode
export -f localcursor

