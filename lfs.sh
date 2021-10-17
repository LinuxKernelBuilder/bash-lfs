#!/bin/bash
# 维护：Yuchen Deng QQ群：19346666、111601117

# 确认管理员权限
if [ $UID != 0 -o ”$SUDO_USER“ == "root" ]; then
    echo "请打开终端，在脚本前添加 sudo 执行，或者 sudo -s 获得管理员权限后再执行。"
    exit 1
fi

export LFS=/mnt/lfs
echo LFS=$LFS

function getConf() {
    RETURN=$(cat `dirname ${BASH_SOURCE[0]}`/lfs.conf | grep $1 | awk -F "=" '/=/ {print $ 2}')
    echo $RETURN
}
