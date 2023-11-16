# Seafile 开源网盘

## 参考

* 官网: <https://www.seafile.com/home/>
* 文档: <https://cloud.seafile.com/published/seafile-manual-cn/docker/%E7%94%A8Docker%E9%83%A8%E7%BD%B2Seafile.md>

## 安装服务端（基于docker）

1. 安装docker，docker-compose
2. 新建目录`/opt/seafile`，在其中新建以下`docker-compose.yml`  

```yaml
services:
db:
    image: mariadb:10.11
    container_name: seafile-mysql
    environment:
    - MYSQL_ROOT_PASSWORD=db_dev  # Requested, set the root's password of MySQL service.
    - MYSQL_LOG_CONSOLE=true
    volumes:
    - /opt/seafile-mysql/db:/var/lib/mysql  # Requested, specifies the path to MySQL data persistent store.
    networks:
    - seafile-net

memcached:
    image: memcached:1.6
    container_name: seafile-memcached
    entrypoint: memcached -m 256
    networks:
    - seafile-net
        
seafile:
    image: seafileltd/seafile-mc:10.0.1
    container_name: seafile
    ports:
    - "18888:80"  # 一般80端口被封的厉害，自己开一个喜欢的http端口
#      - "443:443"  # If https is enabled, cancel the comment.
    volumes:
    - /opt/seafile-data:/shared   # Requested, specifies the path to Seafile data persistent store.
    environment:
    - DB_HOST=db
    - DB_ROOT_PASSWD=db_dev  # Requested, the value shuold be root's password of MySQL service.
    - TIME_ZONE=Asia/Shanghai # Optional, default is UTC. Should be uncomment and set to your local time zone.
    - SEAFILE_ADMIN_EMAIL=me@example.com # Specifies Seafile admin user, default is 'me@example.com'.
    - SEAFILE_ADMIN_PASSWORD=asecret     # Specifies Seafile admin password, default is 'asecret'.
    - SEAFILE_SERVER_LETSENCRYPT=false   # Whether use letsencrypt to generate cert.
    - SEAFILE_SERVER_HOSTNAME=seafile.example.com # Specifies your host name.
    depends_on:
    - db
    - memcached
    networks:
    - seafile-net

networks:
seafile-net:
```  

3. 启动`docker compose up -d`
4. 访问`http://{你的外网IP}:18888`，用SEAFILE_ADMIN_EMAIL登录

## 安装客服端

1. 下载官方客户端 <https://www.seafile.com/download/>

