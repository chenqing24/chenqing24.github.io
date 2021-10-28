# APISix API网关

## 安装

### docker-compose版

```bash
git clone https://github.com/apache/apisix-docker.git
cd apisix-docker/example
docker-compose -p docker-apisix up -d
```

如果要实际使用，建议修改`example`目录内点以下配置：

* `docker-compose.yml`里apisix的`9080和9443`端口，改为`80和443`
* `dashboard_conf/conf.yaml`的`authentication.users.password`修改新值

## 参考

* Github官网 <https://github.com/apache/apisix>