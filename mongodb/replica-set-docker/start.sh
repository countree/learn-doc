#!/bin/bash
basePath=`pwd`
if [ -d /mongodb ]
then
    echo Mongodb文件夹已存在
else
    mkdir -p  /mongodb/{log,data,config}
    chown -R mongodb:mongodb /mongodb
    for i in 1 2 3
    do
        mkdir /mongodb/data/data-$i
        mkdir /mongodb/log/data-$i-log
    done
    echo Mongodb文件夹创建完成
fi

cp -r $basePath/config/* /mongodb/config/

docker-compose stop

docker rm `docker ps -qa`

docker-compose up -d
