# Docker 搭建 Mongodb 集群

标签（空格分隔）：mongodb docker

---

mongodb 集群搭建共有3种模式: 主从模式，Replica set模式，sharding模式。三种模式各有优劣，适用于不同的场合，属Replica set应用最为广泛，主从模式现在用的较少，sharding模式最为完备(但配置维护较为复杂)。本文我们来看下Replica Set模式的搭建方法。

 ####（1）主节点（Primary） 
接收所有的写请求，然后把修改同步到所有副本节点(Secondary)。一个Replica Set只能有一个Primary节点，当Primary挂掉后，会由Arbiter节点会重新选举一个副本节点(Secondary)出来作为主节点。默认读请求也是发到Primary节点处理的，需要转发到Secondary需要客户端修改一下连接配置。

 ####（2）副本节点（Secondary） 
与主节点保持同样的数据集。当主节点挂掉的时候，参与选主。

 ####（3）仲裁者（Arbiter） 
 不保有数据，不参与选主，只进行选主投票。使用Arbiter可以减轻数据存储的硬件需求，Arbiter跑起来几乎没什么大的硬件资源需求，但重要的一点是，在生产环境下它和其他数据节点不要部署在同一台机器上。 
注意，Arbiter节点数必须为奇数，目的是选主投票的时候要有一个大多数才能进行选主决策。

 #### 使用docker搭建 Replica set 集群模式
当前项目是使用docker-compose在单个主机上搭建3个mongodb实例,首先编写`docker-compose.yml`,然后编写mongodb配置文件,3台mongodb的实例使用的是相同的配置文件,因为要挂载到docker中所以放在了3个文件夹中.具体解释详见各个文件中的注释.

#### 启动mongodb集群
```
 ./start.sh  //启动集群
 
 docker ps  //查看mongodb container状态
 
 docker exec -it $containerId  mongo      //随便进入一个mongodb的container实例,连接container中的mongodb执行集群初始化命令.
 
 rs.initiate({"_id":"yyh_repl","members":[{"_id":1,"host":"mongod-1"},{"_id":2,"host":"mongod-2"},{"_id":3,"host":"mongod-3","arbiterOnly":true}]});       //集群初始化
// _id:"yyh_repl" 这个_id要和mongodb.cnf中配置的一样
// _id:1  这个_id是自定义的0-255 每个mongodb实例必须有一个唯一的_id
// host:"mongod-1"  docker-compose.yml中service下每个container的名字
// arbiterOnly:true  只作为仲裁节点
 rs.status();  //查看集群状态,会发现其中的一个节点已经被选为了主节点
 
```




