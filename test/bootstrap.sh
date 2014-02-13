#!/bin/sh
set -x
kitchen_root=`dirname $0`
exec $kitchen_root/data/idk-installer.sh -- -version=$kitchen_root/data
