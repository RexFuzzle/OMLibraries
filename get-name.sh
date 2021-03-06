#!/bin/sh

if test $# -ne 4; then
  echo "Usage: $0 /path/to/omc package.mo encoding standard"
  exit 1
fi
OMC=$1
FILE=$2
ENCODING=$3
STD=$4
MOS="get-name.$$.mos"
NAME="get-name.$$.name"
rm -f $MOS $NAME
cat > $MOS <<EOF
setModelicaPath("");getErrorString();
loadFile("$FILE",encoding="$ENCODING",uses=false);getErrorString();
names:=getClassNames();getErrorString();
name:=names[1];getErrorString();
nameStr:=typeNameString(name);getErrorString();
writeFile("$NAME",nameStr);getErrorString();
EOF
"$OMC" "+n=1" "+std=$STD" $MOS > /dev/null 2>&1
PACKAGE=`test -f "$NAME" && cat "$NAME"`
#rm -f $MOS $NAME
if test -z "$PACKAGE"; then
  exit 1
fi
echo $PACKAGE
