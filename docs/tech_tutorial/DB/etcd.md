# Etcd 分布式KV数据库

## 安装

### 单节点，Docker版

```bash
docker run \
	--name=etcd \
	--volume=/Users/jeff.chen/opt/etcd/etcd-data/:/etcd-data \
	-p 2379:2379 \
	-p 2380:2380 \
	--restart=always \
	-d quay.io/coreos/etcd:v3.3.14 etcd \
	--data-dir=/etcd-data \
	--advertise-client-urls http://0.0.0.0:2379 \
	--listen-client-urls http://0.0.0.0:2379 \
	# --force-new-cluster  # 可选，用于服务异常后的数据恢复
```

## 使用

在容器内执行

```bash
# 查看版本，默认API版本是v2，如果要用v3，需要在环境变量中设置ETCDCTL_API=3
etcdctl --version

# 指定目录Key一览
etcdctl ls /your/key/path

# 设置KV
etcdctl set /ops-event-web ops-event-web

# 读取指定Key
etcdctl get /ops-event-web  # 反馈：ops-event-web

# 删除指定Key
etcdctl rm /ops-event-web
```

### Web UI

基于etcdkeeper，访问`http://localhost:12379`

```bash
# docker启动
docker run -d --name etcdkeeper \
	-p 12379:8080 \
	evildecay/etcdkeeper
```

![ui效果](etcd_ui.png)

## 参考

* Github官网 <https://github.com/etcd-io/etcd>
* 国人翻译的手册 <https://doczhcn.gitbook.io/etcd/>
* etcdkeeper官网 <https://github.com/evildecay/etcdkeeper>