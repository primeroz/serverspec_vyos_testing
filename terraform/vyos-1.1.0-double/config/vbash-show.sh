#!/bin/vbash

[[ $1 == "show" ]] || ( echo "This weapper only support show commands" && exit 1 )

$ARGS=$@

source /opt/vyatta/etc/functions/script-template

run $ARGS
