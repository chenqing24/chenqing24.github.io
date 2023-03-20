# MrDoc 觅思文档 （语雀的平替）

适合于个人和中小型团队的在线文档、知识库系统

## 安装

```bash
# 开源版 基于docker
git clone https://github.com/zmister2016/MrDoc.git

docker run -d \
    --name mrdoc \
    -p 10086:10086 \
    -v $(pwd)/MrDoc:/app/MrDoc zmister/mrdoc:v5

# 创建管理员账号
docker exec -it mrdoc python manage.py createsuperuser
```

## 参考

* 官网 <https://www.mrdoc.pro/>
* 开源源码 <https://github.com/zmister2016/MrDoc.git>