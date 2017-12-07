# Centos7 SVN 配置

标签（空格分隔）： 未分类

---

> 创建资源管理库
```
#: mkdir /svn/data/repo
#: svnadmin create /svn/data/repo
```
> 配置权限

1. 开启安全配置修改文件 `svnserve.conf`
```
#: cd /svn/data/repo/conf
#: vim svnserve.conf
```
    anon-access = read   //去掉开头的#
    auth-access = write   //去掉开头的#
    password-db = passwd   //去掉开头的#  默认为passwd
    authz-db = authz    //去掉开头的#   默认为authz  
2. 设置用户名密码 `passwd`
```
#: vim passwd
```
    [users]
    admin=admin
3. 设置目录访问权限
```
#: vim authz
```
    [groups]
    admin = sam,dean,joe
    #下面这个是配置资源库的访问权限
    [myrepo:/]
    @admin = rw
    tom = r
    * = 
    
     #下面这个绝对是个坑，如果不配置根目录'/'访问权限，只是配置资源库的权限 没有一点效果，必须得先配置这个。而且必须是rw的权限，要不然只能导出，没有权限提交.
    [/]
    @admin = rw  
    * = 

# 需要注意的地方: `authz中的 [/] 的配置`
