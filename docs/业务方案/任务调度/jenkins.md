# Jenkins实用手册

在Mac上测试通过

## 安装

```bash
# 安装长期支持版
brew install jenkins-lts
# 启动后台，注意要占用8080
brew services start jenkins-lts
# 显示安装用的admin密码
cat /Users/xxx/.jenkins/secrets/initialAdminPassword
```

1. 访问`http://localhost:8080/`开始安装向导
2. 选择安装推荐插件

## 使用

### 安装插件

1. `管理Jenkins -> 插件管理`

常用插件：

* docker

### 集成gitlab凭据

### pipeline

1. 进入`新建Item`，输入新任务名，选择`多分支流水线`后，确定
2. 在`分支源`中添加git仓库，输入远程git地址
3. 

### 定时任务

### 集成docker

## 参考

* 官网文档 <https://www.jenkins.io/zh/doc/>