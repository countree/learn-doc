#!/bin/bash

# 先创建redis/ruby镜像下面要用到
./create-redis-ruby-images.sh

# 先启动所有的reids
./start-redis-cluster.sh

# 获取所有redis container 的ip,端口默认使用6379
ips=`docker inspect --format='{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps |grep redis |awk '{print $1}') |awk '{print $1":6379"}'`

# 根据ip:port配置redis集群
# --network 加入到reids的网络中(可以使用 docker network ls |grep redis 查看redis的网络名称)
docker run -it --rm --network=rediscluster_default redis/ruby \
    create --replicas 1 $ips
