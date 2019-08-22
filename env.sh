#!/bin/sh

source /home/isucon/env_variables.sh

[ ! -d $GOPATH/src ] && mkdir -p $GOPATH/src

exec $*
