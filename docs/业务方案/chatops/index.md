# ChatOps方案概述

## 需求

* 快速部署
* 支持灵活扩展
* 通讯安全
* 支持批量升级
* 学习曲线平缓

## 业务场景

### 主机初始化，注册心跳

1台新主机加入资源池，需要自动注册自身的相关信息，如IP、CPU、内存、Hostname

1. 运维通过ansible推送并执行安装脚本
2. 主机在/opt/zm_agent/安装：venv, errbot
3. 通过 `curl ifconfig.me` 获取本机ip，生产errbot的config
4. 执行errbot，进入指定心跳频道

### 安装监控组件

### 升级插件版本

### 立即执行指定脚本，上报执行结果

## 方案

* client层：errbot+git
* 交互层：irc（inspircd）
* server层：gitlab（plugin repo），自研api
