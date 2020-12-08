# Redis 使用手册

## 安装（Docker版）

```bash
# 下载镜像
docker pull redis:3.2.6
# 普通单例启动
docker run -d \
    --name redis-master \
    -p 6379:6379 \
    redis:3.2.6
# 进入redis容器的cli
docker exec -it redis-master redis-cli
```
