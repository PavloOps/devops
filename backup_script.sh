#!/bin/bash

DIRNAME=$1
COMPRESSION=$2
OUTPUT=$3

case $COMPRESSION in
  none )
    OPTIONS="cvf"
    OUTPUT+=".tar"
    ;;
  gzip )
    OPTIONS="cvzf"
    OUTPUT+=".tar.gz"
    ;;
  bzip )
    OPTIONS="cvjf"
    OUTPUT+=".tar.bz2"
    ;;
  xz )
    OPTIONS="cvJf"
    OUTPUT+=".tar.xz"
    ;;
esac

tar $OPTIONS $OUTPUT $DIRNAME 2>> error.log
ENCOUTPUT="${OUTPUT}.enc"
openssl enc -aes-256-cbc -salt -in $OUTPUT -out $ENCOUTPUT 2>> error.log
rm $OUTPUT 2>> error.log
