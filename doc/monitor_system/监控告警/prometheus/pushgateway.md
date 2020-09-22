# Prometheus Pushgateway 简介

<!-- toc -->

## 参考

* 官方源码<https://github.com/prometheus/pushgateway>
* 官方sdk<https://github.com/prometheus/client_python>
* [Prometheus手册](prometheus.md)

## 安装

```bash
docker pull prom/pushgateway:v1.2.0
# web.enable-admin-api启用admin接口
docker run -d \
    --name=pushgateway \
    -p 9091:9091 \
    prom/pushgateway:v1.2.0 --web.enable-admin-api
# 测试
curl --location --request GET 'http://0.0.0.0:9091/metrics'
```

### 接入Prometheus

参考手册，在服务发现配置`sd_config.json`中写入当前pushgateway实例

## 使用

### 写入和更新

```bash
# 生成Metric，指定job，可选指定instance，定义type，可选加入help说明，自定义label，必须回车收尾，支持批量生成
curl --location --request POST 'http://10.10.0.140:9091/metrics/job/some_job/instance/some_instance' \
--header 'Content-Type: text/plain' \
--data-raw '
# TYPE some_metric counter
# HELP some_metric Just an example.
some_metric{label="val1"} 42
'

# 删除指定Metric
curl --location --request DELETE 'http://10.10.0.140:9091/metrics/job/some_job/instance/some_instance'
```

#### python推送指标进Pushgateway

安装库`pip install prometheus_client`

```python
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway

registry = CollectorRegistry()
# 参数依次: 唯一Metric，解释说明，之前定义的注册表实例
g = Gauge('job_last_success_unixtime', 'Last time a batch job successfully finished', registry=registry)
g.set_to_current_time()
push_to_gateway('10.10.0.140:9091', job='batchA', registry=registry)
```

### 查询

```bash
# 获取服务实例status
curl --location --request GET 'http://10.10.0.140:9091/api/v1/status'

# 获取所有Metric，反馈json
curl --location --request GET 'http://10.10.0.140:9091/api/v1/metrics'

# 查询实例健康状态
curl --location --request GET 'http://10.10.0.140:9091/-/healthy'
```
