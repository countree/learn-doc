
#### 创建redis集群

> 详细步骤查看 Docker-Redis-Cluster.md

###### 默认什么都不改的情况下，直接运行

    cd redis-cluster
    sh create-redis-cluster.sh

> 此命令会创建6个redis container,redis端口：6379

> 根据提示输入yes完成集群创建

> 如果要访问redis只能通过其他的container访问(其他container需要加入到redis的网路)

##### 修改redis.config
如果要修改`redis.cofig`端口号如果变化,同时需要修改脚本`create-redis-cluster.sh`中的端口号,如下
> 替换`":6379"`为`redis.config`中配置的的端口号
```
ips=`docker inspect --format='{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps |grep redis |awk '{print $1}') |awk '{print $1":6379"}'`
```


