# Docker容器

## 安装

```bash
# 官方源较慢，使用国内阿里源
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# 安装统一版本18.09.6
yum install docker-ce-18.09.6 docker-ce-cli-18.09.6 containerd.io
# docker启动
systemctl start docker
# 配开机启动
systemctl enable docker
```

![docker](docker.png)
