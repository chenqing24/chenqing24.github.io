# 跳板堡垒机 Teleport

## 需求

* 统一管理能上生产的账号
* 提供审计日志查询

## 安装

```bash
# 下载
wget https://github.com/gravitational/teleport/archive/refs/tags/v8.0.7.zip
unzip v8.0.7.zip -d /opt
mv /opt/teleport-8.0.7/ /opt/teleport/
cd /opt/teleport
# 启动
docker-compose -f docker/teleport-lab.yml up -d

# 关闭
docker-compose -f docker/teleport-lab.yml down
```

## 使用

## 参考

* 官网 <https://github.com/gravitational/teleport>