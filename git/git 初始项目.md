### 初始项目使用git
#### 在github上新建仓库
如果本地已经存在此项目，需要添加到github使用
```shell
cd projectFolder
#初始化此目录为git项目
git init
# 添加远程仓库关联本地仓库
git remote add origin {url}

# 查看仓库文件版本状态
git status
# 添加所有文件到git版本控制
git add --all
# 提交当前版本内容
git commit -m "messages"
# 提交到远程仓库
git push -u origin master
# 强制覆盖远程仓库提交
git push -u -f origin master

```
文件名字太长checkout出错解决
`git config --system core.longpaths true`
