# 蓝鲸智云配置平台(BlueKing CMDB)

## 安装

### 目录和架构

![bkcmdb_dir](bkcmdb_dir.jpg)

* Web展示层 `cmdb_webserver`
* 网关层 `cmdb_apiserver`
* 服务层
  * 原子业务层
    * `cmdb_adminserver` 配置刷新、初始化数据写入等
    * `cmdb_eventserver` 事件订阅与推送
    * `cmdb_procserver` 系统进程
    * `cmdb_toposerver` 拓扑模型
    * `cmdb_hostserver` 主机
    * `cmdb_datacollection` 系统快照数据的接收与写入
    * `cmdb_operationserver` 运营统计相关
    * `cmdb_synchronizeserver` 数据同步
    * `cmdb_taskserver` 异步任务管理
  * 资源管理层 `cmdb_coreservice`
* 存储层 `/data/sidecar/{mongodb,redis}`，提供数据存储、消息队列以及缓存 ![bkcmdb_sidecar](bkcmdb_sidecar.jpg)
* 服务注册发现 `/data/sidecar/zookeeper`

## 使用

### 业务建模

### 权限认证

### 接口调用

### 数据备份

## 参考

* github源码 <https://github.com/Tencent/bk-cmdb>
* 官网文档 <https://bk.tencent.com/docs/document/5.1/9/222>
