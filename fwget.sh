#!/bin/bash
# simple wget manager to let download parallelly but do not download on too many files at once

maxproc=2
nproc=`ps xau | grep  [w]get | wc -l`

url=$1

if test $# -eq 0; then
    echo -e "An url to download needed!";
    exit 0
fi

function procq {
    echo "Forked to background while $maxproc <= $nproc"
    while [ "$maxproc" -le "$nproc" ]
    do
        # keep process in this loop while there are too many wget process
        let "nproc = `ps xau | grep  [w]get | wc -l`"
        sleep 2
    done
    wget --no-verbose $url &
}

if [ "$maxproc" -le "$nproc" ]; then
    procq &
else
    wget --no-verbose $url &
    ps xau | grep  wget
fi


