# MongoDB 简明使用手册

## 安装

### Docker版

```bash
docker run -p 27017:27017 --name mongo \
-v /mydata/mongo/db:/data/db \
-d mongo:4
```

## 使用

### 连接db

```bash
# 登入指定服务实例
bin/mongo --host 127.0.0.1 --port 27017
```

### 创建新集合cmdb和新用户cc（密码cc），并且读写授权

```mongo
use cmdb
db.createUser(
    {user: "cc",
    pwd: "cc",
    roles: [ 
        { role: "readWrite", db: "cmdb" } ]})
<!-- 验证账号密码，反馈1代表成功 -->
db.auth("cc", "cc")
```

### 清理指定集合中文档

```sql
-- 进入指定db
use cmdb
-- 展示当前所有集合（表名）
show collections
-- 显示集合内指定条件的文档
db.cc_AuditLog.find({'bk_supplier_account': '0'})
-- 删除上述数据
db.cc_AuditLog.remove({'bk_supplier_account':'0'})

```

### 备份数据

`mongodump --host 127.0.0.1 --port 27017 --out backup/ --db cmdb`

## 排障

### CPU负载高

```sql
-- 查看当前正在执行的操作
db.currentOp()
-- 开启慢请求日志，超过600毫秒的记录
db.setProfilingLevel(1, { slowms: 600 })
-- 显示最近3条慢日志
db.system.profile.find().sort({$natrual: -1}).limit(3)
-- 关闭慢请求日志
db.setProfilingLevel(0)
```

## 参考

* MongoDB中文网 <https://www.mongodb.org.cn/>

