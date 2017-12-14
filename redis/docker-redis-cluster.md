#  Docker Redis Cluster 
---
> **使用docker安装3主3从redis集群。**
### 环境配置
 [1]:https://docs.docker.com/engine/installation/linux/docker-ce/centos/
> 1. 安装 `docker` [官网安装方法 centos 7 docker 社区版][1]
> 2. 安装 `docker-compose` [官网安装方法](https://docs.docker.com/compose/install/)

### 创建单个Redis
> 先创建6个单机的redis,使用docker-compose.yml创建

 1.**新建一个文件夹`redis-cluster`,作为docker配置redis的工作目录**

```shell
cd /usr/local
mkdir redis-cluster 
cd redis-cluster
```
 2.**创建`docker-compose.yml`文件**
 
    vim docker-compose.yml
```yml
version: '3'
services:
    redis1:
        hostname: redis1
        image: ${image_name}
        volumes:
            - ${local_redis_conf}:${container_redis_conf}
        ports:
            #映射主机7100端口，对外访问。不过这个端口设置了也没用,
            #因为访问redis集群时，如果key不在7100这个容器的redis上,
            #那么reids会返回一个重定向的容器（container）的ip:prot,
            #如果客户端和集群（即6个container）不在同一个网段是不能访问的,
            #所以使用docker创建的redis集群(在不修改container ip的情况下)只能使用container访问。
            - "7100:6379"
        entrypoint: ${entrypoint}
    redis2:
        hostname: redis2
        image: ${image_name}
        volumes:
            - ${local_redis_conf}:${container_redis_conf}
        entrypoint: ${entrypoint}
    redis3:
        hostname: redis3
        image: ${image_name}
        volumes:
            - ${local_redis_conf}:${container_redis_conf}
        entrypoint: ${entrypoint}
    redis4:
        hostname: redis4
        image: ${image_name}
        volumes:
            - ${local_redis_conf}:${container_redis_conf}
        entrypoint: ${entrypoint}
    redis5:
        hostname: redis5
        image: ${image_name}
        volumes:
            - ${local_redis_conf}:${container_redis_conf}
        entrypoint: ${entrypoint}
    redis6:
        hostname: redis6
        image: ${image_name}
        volumes:
            - ${local_redis_conf}:${container_redis_conf}
        entrypoint: ${entrypoint}
```
3.**创建docke-compose所需的环境变量配置**

>配置文件的名字必须是`.env`,docker-compose只扫描`.env`这个文件,在docker-compse.yml文件中,如上使用`${key}`使用变量

    vim .evn
```env
#项目名称只能是小写字母
compose_project_name=rediscluster
#镜像名称
image_name=redis:3.2.11
#本地redis配置文件
local_redis_conf=/usr/local/redis-cluster/conf/redis.conf
#容器redis配置文件
container_redis_conf=/usr/local/etc/redis/redis.conf
entrypoint=gosu redis redis-server /usr/local/etc/redis/redis.conf
```
4.**启动6个单机的redis**
> 使用docker-compose 命令启动container

查看`.env`的配置变量是否在`docker-compose.yml`生效，

    docker-compose config 

启动redis container

    docker-compose up -d
    
### **创建redis集群**
> 创建`redis`集群需要使用`ruby`环境运行`redis-trib.rb`.

1.使用`Dockerfile`文件创建自定义的`redis/ruby`镜像

> vim Dockerfile
```
from ruby
  run gem sources --remove https://rubygems.org/ --add https://gems.ruby-china.org/  && \
      gem install redis && \
    wget -O /redis-trib.rb  "http://download.redis.io/redis-stable/src/redis-trib.rb" && \
    chmod +x /redis-trib.rb
ENTRYPOINT ["/redis-trib.rb"]
```
2.创建`redis/ruby`镜像

    docker build -t redis/ruby .
    
3.使用自定义的镜像`redis/ruby` 创建`redis`集群

    docker run -it --rm --network=rediscluster_default redis/ruby \
            create --replicas 1 ip:prot
>ip:   6个redis container 的ip 
>port:  redis.conf配置的port 默认：6379
>--network:使用redis container的网络,`rediscluster_default`这个网络是在执行`docker-compose up -d `时默认自动生成的网络名称,可以查看官网`docker-compose network`的配置

可以使用命令查看6个redis container的ip

    docker inspect --format='{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps |grep redis |awk '{print $1}') 

>至此集群搭建完成

### 以上配置已写成一个脚本详见本目录下的 `  README.MD`

