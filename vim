#!/bin/bash

#set -x

# command to start vim (mvim is for MacVim)
VIMSTART=mvim

# files directories to look for
REPOMARKERS=(".git" ".hg" ".svn")

checkfile () {
    local dir=$1
    local file=$2

    if [[ -d $dir && -e "$dir/$file" ]]; then
        echo "$( basename $dir )"
        return 0
    fi
    return 1
}

checkfiles () {
    local dir=$1
    local files="${@:2}"

    for file in ${files[@]}
    do
        if checkfile $dir $file; then
            return 0
        fi
    done
    return 1
}

# Finds files/dirs $2 walking up from path $1
# returns directory name (without path) where the file/dir was found
findup () {
    local dir=$1
    local files="${@:2}"

    while [[ $dir != "/" ]]
    do
        if checkfiles $dir $files; then
            return 0
        fi
        dir="$( dirname $dir )"
    done

    return 1
}

# check if servername $1 exists in Vim
checkexists () {
    local servername=$1

    while read s
    do
        if [[ "$servername" == "$s" ]]; then
            return 0
        fi
    done < <($VIMSTART --serverlist)
    return 1
}

# returns true if open in new tab is configured
checktabs () {
    if [[ $(defaults read org.vim.MacVim MMOpenInCurrentWindow) != 0 && \
          $(defaults read org.vim.MacVim MMOpenFilesInTabs) != 0 ]]
    then
        return 0
    fi
    return 1
}

servername=$( findup $PWD ${REPOMARKERS[@]} | tr "[:lower:]" "[:upper:]" )
if [[ "$servername" ]]; then
    opts="--servername $servername"
    if checktabs; then
        opts="$args --remote-tab-silent"
    else
        opts="$args --remote-silent"
    fi
fi
$VIMSTART $args "$@"
