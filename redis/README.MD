# README

---

#### 创建redis集群

默认什么都不改的情况下，直接运行

    sh create-redis-cluster.sh

> 此命令会创建6个redis container,redis端口：6379
> 根据提示输入yes完成集群创建
> 如果要访问redis只能通过其他的container访问(其他container需要加入到redis的网路)



