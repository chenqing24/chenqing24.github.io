# MongoDB 简明使用手册

## 安装

### Docker版

```bash
docker run -p 27017:27017 --name mongo \
-v /mydata/mongo/db:/data/db \
-d mongo:4
```

## 使用

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

### 备份数据

`mongodump --host 127.0.0.1 --port 27017 --out backup/ --db cmdb`

## 参考

* MongoDB中文网 <https://www.mongodb.org.cn/>

