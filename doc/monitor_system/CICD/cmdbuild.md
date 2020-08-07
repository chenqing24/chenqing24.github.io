# CMDBuild配置管理平台

## 参考

* 镜像：<https://hub.docker.com/r/quentinv/cmdbuild>

## 安装（docker版）

```bash
# 安装pgsql
docker run --name pgsql9.4 \
    -p 0.0.0.0:5432:5432 \
    -e POSTGRES_PASSWORD=admin123 \
    -d postgres:9.4

# （可选，数据恢复）复制sql进容器
docker cp ./cmdb_bak.sql pgsql9.4:/tmp/
# 进入容器后操作
docker exec -it pgsql9.4 /bin/bash
# 进Postgresql账号
su postgres
# 建库
createdb -O postgres cmdbuild
# 导数据
psql -U postgres -d cmdbuild < /tmp/cmdb_bak.sql
# 退出容器

# (可选，数据备份)
/usr/bin/docker exec pgsql9.4 pg_dump -U postgres cmdbuild > /backup/cmdbuild_`date +"%Y-%m-%d"`.sql

# 启动cmdb
docker run --name cmdbuild2.4 -p 8080:8080 -d quentinv/cmdbuild:t7-2.4.2
```

## API调用

```bash
# 认证
curl -X POST \
  http://0.0.0.0:8080/services/rest/v1/sessions/ \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '{
    "username": "admin",
    "password": "admin123"
}'

# 获取指定lookup的下属定义列表，ServerUseType是lookup唯一英文名
curl -X GET \
  http://0.0.0.0:8080/services/rest/v1/lookup_types/ServerUseType/values \
  -H 'cache-control: no-cache' \
  -H 'cmdbuild-authorization: oas2l48e16er6hapt6gjqb2hu6' \ # 认证API反馈的_id
  -H 'content-type: application/json'
```