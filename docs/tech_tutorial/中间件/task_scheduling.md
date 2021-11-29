# 任务调度系统调研

对常见的开源任务调度系统的对比调研，调研对象如下：

* xxl-job
* Jenkins pipeline
* PowerJob
* Airflow
* Prefect

## 需求

1. 开源协议，可私有化部署，暂时不考虑saas类
2. 定时调度指定任务，类Crontab
3. 工作流，类DAG
4. 支持任务分片
5. 运行大盘，运行日志
6. 执行结果可反馈，比如任务失败后发通知
7. 任务执行支持重试
8. 可接入多种常见语言的任务，如shell、python等
9. 提供API给外部调用
10. 无单点组件，如一个master、worker挂了，不影响整体

## 简评

### xxl-job

优点：

* 国人开发，GPLv3协议，当前版本：2.3.0
* `调度中心<->执行器`模式，轻量级，简单好用
* 基于WebIDE，支持多种语言脚本
* 多种调度和阻塞策略
* 任务失败提供邮件通知
* 提供Restful API

缺点：

* 修改配置困难，执行器需要重新打包
* 调度中心是单点DB，绑定Mysql
* 不支持DAG
* 任务反馈目前只支持失败邮件，其他不支持

### Jenkins

优点：

* 运维常见服务，容易使用
* 内置定时任务
* 基于pipeline，实现类工作流
* 采集任务执行时的控制台输出，容易定位问题

缺点：

* 更聚焦在CICD领域，通用性较低
* 由于墙和网络问题，更新插件困难
* 提供完整的API
* pipeline专用编排语法，且可视化差

### PowerJob（原OhMyScheduler）

优点：

* 国人开发，Apache协议，当前版本：4.0.1
* UI使用简单，Crontab支持友好
* 支持DAG工作流
* 支持任务MR
* 不绑定特定数据库
* 高可用
* 基于执行器，支持多种语言脚本
* 提供API
* 提供Hook扩展

缺点：

* 执行器的编辑页面较丑

### Airflow

优点：

* Apache旗下，基于Python开发
* DAG完整，可实现复杂依赖流程
* 支持任务MR
* 高度灵活，可定制扩展
* 几乎支持所有常见数据源

缺点：

* 更聚焦在大数据的ETL处理上
* 重量级，需要符合自己的生态圈
* 基于Operators开发任务，学习坡度较大
* 对Crontab类任务支持不友好

### Prefect

优点：

* 比Airflow更简洁
* 基于Python，高度可定制

缺点：

* 和Airflow一样，更偏重数据ETL领域
* Core是Apache开源的，但是部分常用插件是商业版
* 后起之秀，目前文档太少，部分code就是文档
* 实际测试时，部分服务启动一致失败，不稳定

## 参考

1. xxl-job官网 <https://www.xuxueli.com/xxl-job/>
2. Jenkins官网 <https://www.jenkins.io/zh/>
3. PowerJob官网 <http://www.powerjob.tech/>
4. Airflow官网 <https://airflow.apache.org/>
5. Prefect官网 <https://www.prefect.io/>