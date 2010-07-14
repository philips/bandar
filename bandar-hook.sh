#!/bin/bash

# Based on ftp://ftp.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/scripts/x.sh

LIB=`dirname $0`/lib/
PATH=$LIB:$PATH

TP=`mktemp`
TP_BUF=`mktemp`
file=""

cleanup()
{
	rm -f $TP $TP_BUF $file; exit
}

trap "cleanup" INT TERM EXIT

source $HOME/.bandarrc

[ "z$BANDAR_TREE" != "z" ] && TREE=$BANDAR_TREE

cat - > $TP
dos2unix $TP
fix_patch $TP
cp $TP $TP_BUF
${VISUAL:-${EDITOR:-vi}} $TP_BUF < /dev/tty
diff $TP $TP_BUF
[ $? -ne 0 ] || exit
mv $TP_BUF $TP
file=`rename-patch $TP`
echo "filename is $file"

cd $TREE

quilt import $file
quilt push && quilt ref && quilt pop && quilt push

cleanup

trap - INT TERM EXIT
