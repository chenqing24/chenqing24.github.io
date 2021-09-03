# CMDBuild 开源配置管理系统

## 参考

* 官网：<http://www.cmdbuild.org/en/>
* Pgsql-9.4官方镜像：<https://hub.docker.com/r/library/postgres/>
* PostgreSQL新手入门：<http://www.ruanyifeng.com/blog/2013/12/getting_started_with_postgresql.html>
* CMDBuild-2.4.2（tomcat7）开源镜像：<https://hub.docker.com/r/quentinv/cmdbuild/>

## 安装（Docker版）

```bash
# 下载官方img
docker pull postgres:9.4
# 后台启动pgsql-9.4，绑定端口，指定管理员密码
docker run --name pgsql9.4 \
    -p 0.0.0.0:5432:5432 \
    -e POSTGRES_PASSWORD=test123 \
    -d postgres:9.4

# （可选），原数据迁移)复制sql进容器
docker cp ./cmdb_db_dump.sql pgsql9.4:/tmp/
# 进入容器后操作
docker exec -it pgsql9.4 /bin/bash
# 进Postgresql账号
su postgres
# 建库
createdb -O postgres cmdbuild
# 导数据
psql -U postgres -d cmdbuild < /tmp/cmdb_db_dump.sql
# 退出容器

# （安全）允许端口访问，这里只简单的关闭防火墙，线上按实际需求调整
systemctl stop firewalld.service

# 启动服务容器
docker run --name cmdbuild2.4 -p 8080:8080 -d quentinv/cmdbuild:t7-2.4.2
```

进入web配置，默认admin密码：1~6

### 常见故障

* docker启动后，jvm进程的内存占用过大，容易被杀

> 原因：本例的开源img使用tomcat作为Web Server，默认没有配置Xmx；jvm启动时，默认读取所有内存（物理机的）作为上限，导致问题。
> 解决方案：docker启动时，加入JAVA_OPTS='Xmx1024m'环境变量
> 参考文档：<https://yq.aliyun.com/articles/18037>

* 第一次登录会报错500，过了几秒后成功登录，密码正确

> 原因1：用户没有设置默认角色。
> 解决方案：在用户管理页面配置默认角色
> 原因2：PostgresqlDB和Web不在同一台主机，导致connect timeout
> 解决方案：部署在同一台主机上
