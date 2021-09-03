# MySQL Server Exporter 原生Mysql指标采集

<toc>

## 参考

* [官方github](https://github.com/prometheus/mysqld_exporter)

## 安装

1. 在目标DB上，开通监控账号exporter
```sql
CREATE USER 'exporter'@'{实际client的IP}' IDENTIFIED BY '{密码}' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'{实际client的IP}';
```

2. 启动容器实例
```bash
# 新建网络实例
docker network create my-mysql-network
docker pull prom/mysqld-exporter
docker run -d \
  -p 9104:9104 \
  --network my-mysql-network  \
  -e DATA_SOURCE_NAME="exporter:{密码}@({mysql server的ip}:{mysql server的port})/" \
  prom/mysqld-exporter
```

3. 验证服务，访问`http://{实际client的IP}:9104`

### 踩坑记录

* 采集的Mysql指标很少，查看docker log，发现大量拒绝访问`1045: Access denied`
  * Mysql的监控账号出错，请检查：用户名/密码/允许访问的来源网段