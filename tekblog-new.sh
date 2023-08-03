#!/bin/sh

TEKBLOG_SRC="$HOME/src/tekblog"

_usage(){
    echo "$0 TITLE"
    echo "Create a new tekblog post with TITLE"
}
if [ $# -lt 1 ]; then _usage; exit 1; fi

NOW="$(date +%Y-%m-%d)"
FILENAME="$(echo "$@" | tr -d '!,' | tr '[:upper:] ' '[:lower:]-')"

nvim "${TEKBLOG_SRC}/_posts/${NOW}-${FILENAME}.md"
