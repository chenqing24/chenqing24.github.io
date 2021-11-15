# KubeSphere 容器平台

## 安装

### linux上单节点all-in-one

基于ubuntu 18环境测试，硬件配置4C-8G-100G

1. 安装容器runtime `apt install docker.io`
2. 确认dns可用 `nslookup www.baidu.com`，反馈实际Address代表正常
3. 关闭防火墙 `ufw disable`
4. 可选：添加阿里云[容器镜像服务/镜像加速器](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)
5. 安装依赖组件
   1. `apt install socat`
   2. `apt install conntrack`
   3. `apt install ipset -y`
6. 指定环境参数`export KKZONE=cn`，下载kk`curl -sfL https://get-kk.kubesphere.io | VERSION=v1.2.0 sh -`
7. `chmod +x kk`后执行安装`./kk create cluster --with-kubernetes v1.21.5 --with-kubesphere v3.2.0` ![ks_install](ks_install.jpg){: style="width:60%"}，![安装完成](ks_install_over.jpg){: style="width:60%"}
8. 安装验证`kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l app=ks-install -o jsonpath='{.items[0].metadata.name}') -f`，![验证](ks_install_over.jpg){: style="width:60%"}
9. 第一次登入会要求改admin密码
10. admin访问管理界面，![web界面](ks_admin.jpg){: style="width:60%"}

### 启用插件

#### DevOps系统

1. 以`admin`用户访问`平台管理-集群管理-CRD`页面，搜索`clusterconfiguration` ![ks_install_crd](ks_install_crd.jpg){: style="width:60%"}
2. 进入详情页，`编辑 YAML` ![ks_install_edityaml](ks_install_edityaml.jpg){: style="width:60%"}
3. 改`spec.devops.enabled`为true，并确定保存
4. 等待几分钟，集群组件会重启，验证安装结果 `kubectl get pod -n kubesphere-devops-system` ![ks_install_devops](ks_install_devops.jpg){: style="width:60%"} ![ks_install_devops_over](ks_install_devops_over.jpg){: style="width:60%"}

#### Istio服务网格

[TODO]

## 使用

### 创建企业空间、项目、用户和角色

#### 创建用户

1. `平台管理-访问控制-用户`，`创建`新用户管理员 ![add_user](ks_add_user.jpg){: style="width:60%"}
2. 依次新增用户`企业空间管理员(ws-manager)`、`普通项目用户(project-regular)`等

#### 创建企业空间

1. 以`ws-manager`身份登录，进入`企业空间`，`创建`新空间`demo-workspace`，指定普通用户`ws-admin`为该空间管理员
2. 以`ws-admin`登入，邀请普通用户`project-admin`和`project-regular`进入该空间，并授权 ![空间邀请用户](ks_demo_add_user.jpg){: style="width:60%"}

#### 创建项目（等同NameSpace）

1. 以`project-admin`登入，进入`项目`，点`创建`新项目`demo-project` ![新项目](ks_demo_add_project.jpg){: style="width:60%"}
2. 点击进入项目详情，设置资源限制 ![ks_demo_limit](ks_demo_limit.jpg){: style="width:60%"}
   1. 注意 1Gi == 1024MiB; 1G == 1000MB
3. 邀请已有用户为项目成员
4. 在`网关设置`创建`NodePort`模式的网关，供外部访问 ![ks_demo_gateway](ks_demo_gateway.jpg){: style="width:60%"}

### 项目部署

1. 创建DB密钥：以`project-regular`用户，访问`demo-project`详情页中的`配置-保密字典`页，点创建`mysql-secret`密钥，旗下配置`默认`类型的kv对`MYSQL_ROOT_PASSWORD`，点✔︎后保存 ![create-secret1](create-secret1.jpg){: style="width:60%"}
2. 同上，创建`wordpress-secret`，含kv`WORDPRESS_DB_PASSWORD`
3. 访问`存储-存储卷`，创建名`wordpress-pvc`的local ro卷（10Gi） ![volume1](volume1.jpg){: style="width:60%"}
4. 创建mysql：`应用负载-应用-自制应用`中创建新应用`wordpress` ![新建自制应用](composing-app1.png){: style="width:60%"}，![基本信息](basic-info.png){: style="width:60%"}，再创建`有状态服务`![添加服务](add-service.png){: style="width:60%"}，![有状态服务](add-service-2.jpg){: style="width:60%"}，![mysql服务](mysqlname.png){: style="width:60%"}
   1. 向导`容器镜像`中，点击`添加容器镜像`，搜索`mysql:5.7`，点`使用默认端口`
   2. 勾选环境变量，点`引用配置文件或密钥`，选择上文创建的密钥kv`MYSQL_ROOT_PASSWORD`，并点✔︎保存
   3. 注意：资源需要限制，不能大于项目自身配额 ![配额](配额.jpg){: style="width:60%"}
   4. 下一步`添加存储卷` ![volume-template1](volume-template1.png){: style="width:60%"}，并点✔︎保存
   5. 最后在`高级设置`右下方点`创建`，完成向导
5. 再添加`无状态服务`应用`wordpress`，流程类似，使用默认端口，环境变量分别引用密钥kv`WORDPRESS_DB_PASSWORD`和添加环境变量`WORDPRESS_DB_HOST` ![environment-varss](environment-varss.png){: style="width:60%"}，并点✔︎保存
   1. `选择已有存储卷`，挂在`/var/www/html`，点✔︎保存 ![mount-volume-page.png](mount-volume-page.png){: style="width:60%"}
   2. 下一步`创建`，完成向导
6. 下一步`路由设置`中，点击`创建`，使用默认规则
7. `工作负载`页下验证服务: 这里卡住，有状态的mysql一直失败，导致wp不断重启
8. [TODO]通过 NodePort 访问 WordPress

## 参考

* 中文官网 <https://kubesphere.com.cn/>