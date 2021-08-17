# Redis 使用手册

## 安装（Docker版）

```bash
# 普通单例启动
docker run -d \
    --name redis-master \
    -p 6379:6379 \
    redis:3.2
# 进入redis容器的cli
docker exec -it redis-master redis-cli
```

## 组建HA集群

### 哨兵模式 sentinel

哨兵配置说明

```conf
sentinel monitor mymaster 127.0.0.1 6379 2
sentinel down-after-milliseconds mymaster 60000
sentinel failover-timeout mymaster 180000
sentinel parallel-syncs mymaster 1

min-slaves-to-write 1
min-slaves-max-lag 10
```

* mymaster: 用户自定义的redis主节点名
* 2: 仲裁机数量quorum，同意主节点不可用的Sentinels的数量，如3个哨兵中2个认为主节点不可以，就执行切换
* down-after-milliseconds: 失联时长
* parallel-syncs: 从节点数量
* min-slaves-to-write: 至少n个节点写入成功才算
* min-slaves-max-lag: 异步确认超时，秒

常用sentinel命令

```bash
# 罗列所有sentinel 监视相关的master
sentinel masters
# 列出一个master相应的slave组相关的数据
sentinel slaves masterName
# 获取master-name相关的 ip addr 的信息
sentinel get-master-addr-by-name masterName
```

基本架构

```bash
       +----+
       | M1 |
       | S1 |
       +----+
          |
+----+    |    +----+
| R2 |----+----| R3 |
| S2 |         | S3 |
+----+         +----+

Configuration: quorum = 2
```

redis集群，1主2从，暴露端口从6380到6382，docker-compose.yml如下：

```yaml
version: '3'
services:
  master:
    image: redis:3.2
    restart: always
    container_name: redis-master
    restart: always
    ports:
      - 6380:6379
  slave1:
    image: redis:3.2
    restart: always
    container_name: redis-slave-1
    ports:
      - 6381:6379
    command:  redis-server --slaveof redis-master 6379 --requirepass redis_pwd --masterauth redis_pwd
  slave2:
    image: redis:3.2
    restart: always
    container_name: redis-slave-2
    ports:
      - 6382:6379
    command: redis-server --slaveof redis-master 6379 --requirepass redis_pwd --masterauth redis_pwd
```

`docker-compose up -d`启动后，自动创建`redis_default`网络
通过`docker inspect redis-master | grep IP`获取主节点在网络中的IP`172.20.0.4`，稍后哨兵配置要用
> 也可以直接使用本机IP地址+映射出来的端口，作为哨兵的配置，这里假设本地IP是`10.10.0.1`
进redis同级的哨兵目录，生成哨兵配置文件`sentinel1.conf`

```conf
port 26379
dir /tmp
; 可选：如果使用redis_default网络，用以下配置
; sentinel monitor mymaster 172.20.0.4 6379 2
sentinel monitor mymaster 10.10.0.1 6380 2
sentinel auth-pass mymaster redis_pwd
sentinel down-after-milliseconds mymaster 30000
sentinel parallel-syncs mymaster 1
sentinel failover-timeout mymaster 180000
```

复制`sentinel1.conf`为`sentinel2.conf`和`sentinel3.conf`
> （可选）编辑生成哨兵sentinel的yaml配置，连入`redis_default`网络：

```yaml
version: '3'
services:
  sentinel1:
    image: redis:3.2
    container_name: redis-sentinel-1
    ports:
      - 26380:26379
    command: redis-sentinel /usr/local/etc/redis/sentinel.conf
    volumes:
      - ./sentinel1.conf:/usr/local/etc/redis/sentinel.conf
  sentinel2:
    image: redis:3.2
    container_name: redis-sentinel-2
    ports:
    - 26381:26379
    command: redis-sentinel /usr/local/etc/redis/sentinel.conf
    volumes:
      - ./sentinel2.conf:/usr/local/etc/redis/sentinel.conf
  sentinel3:
    image: redis:3.2
    container_name: redis-sentinel-3
    ports:
      - 26382:26379
    command: redis-sentinel /usr/local/etc/redis/sentinel.conf
    volumes:
      - ./sentinel3.conf:/usr/local/etc/redis/sentinel.conf
# 可选，连redis集群的专有网络
# networks: 
#   default:
#     external:
#       name: redis_default      
```

`docker-compose up -d`启动后，进入任意sentinel验证：

```bash
docker exec -it redis-sentinel-1 bash
redis-cli -p 26379
```

> `127.0.0.1:26379> info`  
> `127.0.0.1:26379> sentinel masters`  
> `127.0.0.1:26379> sentinel master mymaster`  


## 使用

### python通过哨兵访问redis

