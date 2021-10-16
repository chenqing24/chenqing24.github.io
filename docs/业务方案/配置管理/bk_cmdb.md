# 蓝鲸智云配置平台(BlueKing CMDB)

## 安装

### 目录和架构

![bkcmdb_dir](bkcmdb_dir.jpg)

* Web展示层 `cmdb_webserver`
* API网关层 `cmdb_apiserver`
* 服务层
  * 原子业务层
    * `cmdb_adminserver` 配置刷新、初始化数据写入等
    * `cmdb_eventserver` 事件订阅与推送
    * `cmdb_procserver` 系统进程
    * `cmdb_toposerver` 拓扑模型
    * `cmdb_hostserver` 主机
    * `cmdb_datacollection` 系统快照数据的采集
    * `cmdb_operationserver` 运营统计相关
    * `cmdb_synchronizeserver` 数据同步
    * `cmdb_taskserver` 异步任务管理
  * 资源管理层 `cmdb_coreservice`
* 存储层 `/data/sidecar/{mongodb,redis}`，提供数据存储、消息队列以及缓存 ![bkcmdb_sidecar](bkcmdb_sidecar.jpg)
* 服务注册发现 `/data/sidecar/zookeeper`

### Docker一键安装

```bash
docker run -d \
	--name=cmdb \
	-p 8090:8090 \
	--restart=always \
	ccr.ccs.tencentyun.com/bk.io/cmdb-standalone:v3.9.5
```

默认配置：

* zk `127.0.0.1:2181`
* mongo `cc:cc@127.0.0.1:27017`，db `cmdb`
* redis `127.0.0.1:6379`，pw `cc`
* web访问 <http://127.0.0.1:8090/>，默认用户`admin`，不用密码

![webui](bkcmdb_webui.jpg)

## 使用

### 业务建模



### 权限认证

Docker版服务默认不开启权限，直接以admin操作，非常不安全，解决方案有2种：

1. 使用原生服务：蓝鲸“全家桶”中的[PaaS平台](https://github.com/Tencent/bk-PaaS)，请看官方文档
2. 用自己的服务封装一层，大致思路如下：
> 1. cmdb实例和其他DB一样，部署在内部安全网络中，不允许外部直接访问
> 2. 只信任从指定网关地址过来的访问，实质是把权限解耦，托管给上游，参考[这一篇文章详细介绍](../权限管控/api_gateway_auth.md)。

### 接口调用

### 数据备份

### 对接密码管理

由于cmdb有对接外部系统的需求，一些ci的账号信息不适合直接明文存储，这里提供一种解决思路，供参考：

> KeePassXC 一种安全开源\跨平台的密码加密、存管工具

1. ci记录的密码属性信息存入KeePassXC管理的.kdbx加密库中
2. 基于py库`pykeepass`构建密码查询接口，入参(ci分类, ci.id, [属性kv])，反馈解密后的报文（如：密码）
3. 在业务流程开发时，通过上面的接口，读取密码

## TODO

* 用户授权访问
* 主机信息自动采集和注册
* 对接统一服务平台入口

## 参考

* github源码 <https://github.com/Tencent/bk-cmdb>
* 官网文档 <https://bk.tencent.com/docs/document/5.1/9/222>
