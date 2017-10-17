#!/usr/bin/env bash

#AD_COUNT="${AD_COUNT:--1}"
BBS_TYPE=$1
OUTPUT_DIR=$2
AD_COUNT=$3


usage() {
    echo "Generates a set of ANSI adverts for display when logging off a BBS."
    echo "USAGE: $(basename "$0") [enigma|mystic|other] output_dir <total_no_of_ads>"
    echo "eg: $(basename "$0") enigma ~/enigma-bbs/art"
}

if [  $# -lt 2 ]; then
		usage
		exit 1
	fi

declare -i AD_NUM=1

pushd adverts
mkdir -p $OUTPUT_DIR

for file in ../adverts/*.ans; do
	if [ -n "$AD_COUNT" ] && [ "$AD_COUNT" -ge "$AD_NUM" ]; then
		break
	fi

	case $BBS_TYPE in
        enigma)
            NEWNAME=othrbbs$AD_NUM.ans
        ;;
        mystic)
            NEWNAME=logoff.an$AD_NUM
        ;;
        *)
            NEWNAME=bbsad$AD_NUM.ans
        ;;
	esac

	echo "Copying $file to $OUTPUT_DIR/$NEWNAME"
	cp "$file" "$OUTPUT_DIR/$NEWNAME"

	((++AD_NUM))
done

popd