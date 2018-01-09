#  Nginx 配置
---

> Nginx 安装见上级目录 `docker/docker-nginx`使用docker安装Nginx

#### 1. 配置 `nginx.conf`
```
#哪个用户
user  nginx;
worker_processes  8;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
        worker_connections  10240;
}
http {
        include       /etc/nginx/mime.types;
        default_type  application/octet-stream;

        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';

        access_log  /var/log/nginx/access.log  main;

        sendfile        on;
        #tcp_nopush     on;

        keepalive_timeout  65;
#gzip模块设置
        gzip on; #开启gzip压缩输出
        gzip_min_length 1k;    #最小压缩文件大小
        gzip_buffers 4 16k;    #压缩缓冲区
        gzip_http_version 1.1;    #压缩版本（默认1.1，前端如果是squid2.5请使用1.0）
        gzip_comp_level 2;    #压缩等级
        gzip_types text/plain application/x-javascript text/css application/xml;       #压缩类型，默认就已经包含textml，所以下面就不用再写了，写上去也不会有问题，但是会有一个warn。

        include /etc/nginx/conf.d/*.conf;
}

```
> `nginx.conf` 其它配置不再介绍，主要是引用了 `/etc/nginx/conf.d `这个目录，所有的自定义配置都在这个文件夹下，
新建一个名字`html_static.conf`，名字可以随便，但后缀必须是`.conf`.

#### 2. 一个静态资源访问的配置
> `conf.d`文件夹下新建一个文件`html_static.conf`
```
server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;
        #access_log  /var/log/nginx/host.access.log  main;
        
        location / {
                    #静态资源存放路径 root 指的是根路径
                    root   /usr/share/nginx/html;
                    index  index.html index.htm;
                }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
                    root   /usr/share/nginx/html;
                }
}

```
#### 3. 反向代理多个服务器配置
> `conf.d`文件夹下新建一个文件`proxy-server.conf`
```
server {
        #监听80端口
        listen       80;
        #一般是设置域名 多个用`,`隔开
        server_name  192.168.2.188;
         
        #charset utf-8; #默认是 utf-8

        #location {path} {} 可以拦截相应的url跳转到相应的服务
        
        #拦截以/manager 的跳转到manager服务器
        location /manager {
            #被代理的服务器地址
            proxy_pass http://192.168.2.188:8010/manager;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            #是web服务器获取真实ip
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            #可选
            proxy_set_header Host $host;
        }
        # 拦截以/cz 跳转到cz的服务器的根(/)目录
        location /cz {
            proxy_pass http://192.168.2.3:8080/;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
        }
        location /app.js {
            proxy_pass http://192.168.2.3:8080/app.js;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
        }
        location /__webpack_hmr {
            proxy_pass http://192.168.2.3:8080/__webpack_hmr;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
        }
}

```

>server 可以设置多个，多个配置文件的多个server如果监听同一个端口，则只有一个server配置起作用。没有测试监听相同的端口号且location配置也相同是什么效果。
