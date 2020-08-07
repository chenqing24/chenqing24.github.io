# Activiti

基于原生Activiti 6 的Rest API服务

## 参考

* 中文用户手册 v5 <https://tkjohn.github.io/activiti-userguide/>

## 安装

### MySQL 5.7

用于存储数据的db

`docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -p 3306:3306 -d mysql:5.7`

* 用户: root
* 密码: my-secret-pw
* 访问端口: 3306
* 新建database: workflow, utf8编码

### Tomcat 7

运行Activiti的web容器

* 参考Dockerfile: [http://gitlab.jrlab.17usoft.com/dockerfile/tomcat7-jdk8](http://gitlab.jrlab.17usoft.com/dockerfile/tomcat7-jdk8)
* `docker run --name=tomcat7 --volume=$(pwd)/webapps:/usr/local/tomcat/webapps -p 8080:8080 -d tomcat7-jdk8:latest`

### Activiti 6

* [官网下载地址](https://github.com/Activiti/Activiti/releases/download/activiti-6.0.0/activiti-6.0.0.zip)
* 复制`activiti-6.0.0/wars/{activiti-app.war, activiti-rest.war}`进挂载的webapps目录
* 修改解压后的`activiti-app/WEB-INF/classes/META-INF/activiti-app/activiti-app.properties`
  * 修改数据库为MySQL，指定方言，连接地址（之前配置的db）,如 ![activiti-app-db](doc/activiti-app-db.png)
  * 类似，Rest API服务改`activiti-rest/WEB-INF/classes/db.properties`，如 ![activiti-rest-db](doc/activiti-rest-db.png)
    * Rest API服务需要将MySQL驱动(mysql-connector-java-*.jar)加入`activiti-rest/WEB-INF/lib`
  * 2者指向同一个db，保证数据一致

## 使用

### 新建工作流的步骤

以本地启动的`http://localhost:8080/activiti-app/`为例:

1. 在[Kickstart App-Processes](http://localhost:8080/activiti-app/editor/#/processes)里`Create Process`
   1. 定义Process Model的name和key
   2. 画布上拖拽元素（启停事件、Task、Gateway等），建立关联线条
      1. 每个元素填写属性Id和Name等
      2. UserTask设置认领角色Assignment
      3. Task设置绑定的表单Referenced form
   3. 保存
2. 在[Kickstart App-Apps](http://localhost:8080/activiti-app/editor/#/apps)里`Create App`
   1. 定义App的name和key
   2. 选择App下属的Models
   3. 保存
3. 发布App==发布工作流
   1. 点进之前定义的App
   2. 选择`Publish`

### 调用工作流实例

* 在[Task App-Processes](http://localhost:8080/activiti-app/workflow/#/processes)里`Start a process`
  * 也可以直接从首页点击相关App直接进入，选择Processes Tab开始新流程，例如: <http://localhost:8080/activiti-app/workflow/#/apps/{发布的App}/processes>
  * 点`Show diagram`查看当前工作流的执行状态图![show-process-diagram](doc/show-process-diagram.png)

### Rest API

#### 通用说明

##### 访问认证

* 所有的HTTP API的访问都需要安全认证
* 默认使用 HTTP Basic Auth方案
  * 方案1: 带(用户名:密码)访问，因为明文，不推荐，举例: `http://admin:test@localhost:8080/activiti-rest/service/repository/deployments` (流程定义一览)
  * 方案2: 使用Header: Authorization，举例:

    ```bash
    curl -X GET \
    http://localhost:8080/activiti-rest/service/repository/deployments \
    -H 'Authorization: Basic YWRtaW46dGVzdA==' \ # YWRtaW46dGVzdA== 是Base64(admin:test)
    -H 'cache-control: no-cache'
    ```

* Swagger接口文档地址，以本地服务为例: `http://localhost:8080/activiti-rest/docs/` ![activiti-swagger](doc/activiti-swagger.png)
* Rest HTTP API的Base URL: `http://localhost:8080/activiti-rest/service/`

#### 常用方法

1. 工作流
   1. 按流程名检索: `GET repository/deployments?name={精确流程名}`
   2. 发布新流程:

        ```bash
        curl -X POST \
        http://localhost:8080/activiti-rest/service/repository/deployments \
        -H 'Authorization: Basic YWRtaW46dGVzdA==' \  # 按实际用户密码加密
        -H 'cache-control: no-cache' \
        -H 'content-type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW' \
        -F demo.bpmn20.xml=@/Users/jeff.chen/Downloads/Process_demo.bpmn20-v2.xml
        # demo.bpmn20.xml是流程名，=后跟用户本地bpmn定义
        # 只接收.bpmn20.xml, .bpmn, .bar or .zip后缀
        ```

    1. 获取工作流定义一览: `GET repository/process-definitions`
    2. 激活指定工作流: `PUT repository/process-definitions/{processDefinitionId}`

2. 流程运行实例
   1. 当前运行的流程运行实例一览: `GET /runtime/process-instances`
   2. 通过流程key，（bpmn文件中的process.id），启动新流程实例，![start_new_process_by_key](doc/start_new_process_by_key.png):

        ```bash
        curl -X POST \
        http://localhost:8080/activiti-rest/service/runtime/process-instances \
        -H 'Authorization: Basic YWRtaW46dGVzdA==' \
        -H 'Content-Type: application/json' \
        -H 'cache-control: no-cache' \
        -d '{
                "processDefinitionKey":"Process_one_step_demo_id"
            }'
        # 获取返回json，其中有后续Task需要的信息
        {
            "id": "7532",  # 核心参数，当前流程实例id
            "url": "http://localhost:8080/activiti-rest/service/runtime/process-instances/7532",
            "businessKey": null,
            "suspended": false,
            "ended": false,
            "processDefinitionId": "Process_one_step_demo_id:1:5045",
            "processDefinitionUrl": "http://localhost:8080/activiti-rest/service/repository/process-definitions/Process_one_step_demo_id:1:5045",
            "processDefinitionKey": "Process_one_step_demo_id",
            "activityId": null,
            "variables": [],
            "tenantId": "",
            "name": null,
            "completed": false
        }
        ```

    1. 获取指定流程id的流转状态图: `GET runtime/process-instances/7532/diagram`![process-instance-diagram](doc/process-instance-diagram.png)
       1. 红框代表流程执行到的Task
 1. 任务
    1. 获取指定流程实例下待处理任务列表: `GET runtime/tasks?processInstanceId=7532`，反馈json如下:

        ```js
        {
            "data": [
                {
                    "id": "7539",  // 核心参数，待处理的Task.id
                    "url": "http://localhost:8080/activiti-rest/service/runtime/tasks/7539",
                    "owner": null,
                    "assignee": "admin",
                    "delegationState": null,
                    "name": "Write monthly financial report",
                    "description": "Write monthly financial report for publication to shareholders.",
                    "createTime": "2019-08-09T09:01:55.610Z",
                    "dueDate": null,
                    "priority": 50,
                    "suspended": false,
                    "taskDefinitionKey": "writeReportTask",
                    "tenantId": "",
                    "category": null,
                    "formKey": "UserInputMessage",
                    "parentTaskId": null,
                    "parentTaskUrl": null,
                    "executionId": "7536",
                    "executionUrl": "http://localhost:8080/activiti-rest/service/runtime/executions/7536",
                    "processInstanceId": "7532",
                    "processInstanceUrl": "http://localhost:8080/activiti-rest/service/runtime/process-instances/7532",
                    "processDefinitionId": "Process_one_step_demo_id:1:5045",
                    "processDefinitionUrl": "http://localhost:8080/activiti-rest/service/repository/process-definitions/Process_one_step_demo_id:1:5045",
                    "variables": []
                }
            ],
            "total": 1,
            "start": 0,
            "sort": "id",
            "order": "asc",
            "size": 1
        }
        ```
    
    2. 完成指定任务:

        ```bash
        curl -X POST \
        http://localhost:8080/activiti-rest/service/runtime/tasks/7539 \
        -H 'Authorization: Basic YWRtaW46dGVzdA==' \
        -H 'Content-Type: application/json' \
        -H 'cache-control: no-cache' \
        -d '{
            "action": "complete",  # 执行任务的行为”完成“，可有其他Action类型，详情看官方文档
            "variables": [{  # 需要填写的表单参数
                "name": "message",  # 表单input元素的id，参考下图
                "value": "This is a User Input Message"  # 在input中的填写
            }]
        }'
        # 如果反馈HTTP状态码为200，表示更新成功
        ```

        > 引用的input元素对应![task_input_name](doc/task_input_name.png)
