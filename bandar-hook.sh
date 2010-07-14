#!/bin/bash

# Based on ftp://ftp.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/scripts/x.sh

LIB=`dirname $0`/lib/
PATH=$LIB:$PATH

TP=`mktemp`
trap "rm -f $TP; exit" INT TERM EXIT

source $HOME/.bandarrc

cat - > $TP
dos2unix $TP
fix_patch $TP
${VISUAL:-${EDITOR:-vi}} $TP < /dev/tty
file=`rename-patch $TP`
echo "filename is $file"

cd $TREE

quilt import $file
quilt push && quilt ref && quilt pop && quilt push

trap - INT TERM EXIT

