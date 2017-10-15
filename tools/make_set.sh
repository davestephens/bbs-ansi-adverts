#!/usr/bin/env bash

#AD_COUNT="${AD_COUNT:--1}"
AD_COUNT=$1
declare -i AD_NUM=1

pushd adverts
mkdir -p ../advert_set

for file in ../adverts/*.ans; do
	if [ -n "$AD_COUNT" ] && [ "$AD_COUNT" -ge "$AD_NUM" ]; then
		break
	fi

	NEWNAME=bbsad$AD_NUM.ans
	echo $NEWNAME
	cp "$file" "../advert_set/bbsad$AD_NUM.ans"

	((++AD_NUM))
done

popd