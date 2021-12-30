# inspircd IRC服务

## 安装

```bash
# 启动，指定密码
docker run -d \
    --name ircd \
    --restart=always \
    -p 16667:6667 \
    -e "INSP_CONNECT_PASSWORD=hmac-sha256" \
    inspircd/inspircd-docker
```

## 参考

* 官网 <https://github.com/inspircd/inspircd>