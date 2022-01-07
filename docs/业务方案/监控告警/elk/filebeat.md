# Filebeat简介

## 安装

在Ubuntu 18下测试通过，版本7.16

```bash
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.16.2-linux-x86_64.tar.gz
tar xzvf filebeat-7.16.2-linux-x86_64.tar.gz -C /opt/
```

## 业务场景

### 接入syslog，输出到logstash

1. 进入filebeat目录，编辑配置`filebeat.yml`
2. 启用内置采集模块system
```bash
./filebeat modules list
./filebeat modules enable system
```
3. 启动前，验证配置 `./filebeat test config -e -c filebeat.yml`
4. 启动前，验证下游 `./filebeat test output -e -c filebeat.yml`
5. 启动 `./filebeat -e -c filebeat.yml`

## 参考

* 官方文档 <https://www.elastic.co/guide/en/beats/filebeat/current/index.html>
* 源码 <https://github.com/elastic/beats>