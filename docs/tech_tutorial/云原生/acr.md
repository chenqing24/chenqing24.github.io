# Alibaba Cloud Container Registry(ACR) 阿里云容器镜像服务

阿里对个人有限免费的容器镜像服务，值得开发者拥有～

## 开通

1. 登录容器镜像服务控制台，实例列表`创建个人版`
2. 设置镜像仓库登录密码
3. （可选）访问凭证里创建固定密码
4. 创建命名空间，名字全局唯一
5. 创建镜像仓库，相当于一个git项目
6. （可选）绑定多种git服务商，实现commit自动构建

## 使用

```bash
# 无论pull｜push，都要先登入docker仓库，使用固定密码
docker login --username=<你的阿里云账号> registry.cn-shanghai.aliyuncs.com

# 对要推送的镜像打tag，格式：regist域名/命名空间/仓库名（即应用名）:镜像版本
docker tag 532c4733c665 registry.cn-shanghai.aliyuncs.com/cyan-thinker/inf-etcd:v3.4.16
# 执行推送
docker push registry.cn-shanghai.aliyuncs.com/cyan-thinker/inf-etcd:v3.4.16
```
