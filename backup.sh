#!/bin/bash

_run ()
{
	echo $@
	if [ "$DRY_RUN" == false ]; then
		$@
	fi
}

BACKUP="/mnt/backup"
DATA="/mnt/data"

TODAY=$(date -u +"%Y-%m-%dT%H-%M-%SZ")
NEW_DATA="data_$TODAY"
NEW_OS="os_$TODAY.img"

OLD_DATA=$(ls $BACKUP | grep ^data | tail -1)
OLD_OS=$(ls $BACKUP | grep ^os | tail -1)

echo "Found data snapshot $OLD_DATA"
echo "Saving data snapshot $NEW_DATA"
_run rsync -a --link-dest \
	$BACKUP/$OLD_DATA \
	$DATA \
	$BACKUP/$NEW_DATA

echo "*** Saving system image to $NEW_OS ***"
_run dd if=/dev/mmcblk0 of=$BACKUP/$NEW_OS bs=16M status=progress

echo "*** Shrinking raspberry pi image ***"
_run pishrink -z $BACKUP/$NEW_OS
