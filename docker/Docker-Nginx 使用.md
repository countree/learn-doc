# Docker-Nginx 使用

标签（空格分隔）：nginx 

---


#### **环境配置**
> 1. 安装 `docker` [centos docker 社区版 官网安装方法][1]
> 2. 安装 `docker-compose` [官网安装方法](https://docs.docker.com/compose/install/)


#### 1. 使用 Docker 下载 Nginx 镜像
:  指定 `nginx` 版本下载
> `docker pull nginx:1.12.2`
 

#### 2. 配置启动 nginx 
: 使用`docker-compose`配置`nginx`
  ` docker-compose.yml` [官网详解](https://docs.docker.com/compose/compose-file/)
```
version: '3'
services:
    nginx:
        hostname: nginx
        image: nginx:1.12.2
        volumes:
            - /servive-data/webapp/static:/usr/share/nginx/html
            - /servive-data/conf/nginx/nginx.conf:/etc/nginx/nginx.conf
            - /servive-data/conf/nginx/conf.d/:/etc/nginx/conf.d/
        ports:
            - "80:80"
```
#### 3. 启动 Nginx
> `docker-compose up -d `


  [1]: https://docs.docker.com/engine/installation/linux/docker-ce/centos/