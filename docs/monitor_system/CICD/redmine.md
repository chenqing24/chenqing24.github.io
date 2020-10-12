# Redmine需求管理平台

## 参考

* Redmine官方镜像：<https://github.com/docker-library/redmine>
* MySQL官方镜像：<https://hub.docker.com/_/mysql>

## 安装（基于Docker）

以Redmine-3.2.1 + MySQL-5为例：

```bash
# 安装MySQL
mkdir -p /var/lib/mysql
docker run --name mysql -e MYSQL_ROOT_PASSWORD=admin123 -p 3306:3306 -v /var/lib/mysql:/var/lib/mysql -d mysql:5

# 进入容器后维护
docker exec -it mysql bash
mysql -uroot -padmin123

```

执行sql：

```sql
-- 建库
CREATE DATABASE redmine CHARACTER SET utf8;
-- 建用户
CREATE USER 'redmine'@'localhost' IDENTIFIED BY 'redmine';
-- 授权
GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'localhost';
```

退出db后，在容器中继续：

```bash
# （可选，恢复数据）导入原sqldump，要求库先存在
mysql -uroot -padmin123 redmine < ./redmine_bak.sql

# 启动Redmine
docker run \
    -d \
    --name redmine \
    --link mysql:mysql \
    -p 8080:3000 \
    redmine:3.2.1

# （可选，数据备份）
mysqldump -uroot -padmin123 redmine > /backup/redmine_`date +"%Y-%m-%d"`.sql
```
