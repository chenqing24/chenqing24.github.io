# Git使用相关

## 基础（略）

<!-- TODO -->

## 高阶场景

### 一次推送多个远程git repo

以推送github为例，先在github建立空repo，获取对应git地址，如`https://github.com/your-github-account/your-new-project.git`

```bash
# 查看当前推送的远程库
git remote -v

# 添加新git repo作为推送对象
git remote set-url --add origin https://github.com/your-github-account/your-new-project.git
```

cli的实质是在`.git/config`的`[remote "origin"]`下添加一个新url

### 设置代理

```bash
# 添加代理
git config --global http.proxy 'socks://localhost:7070'

# 取消代理
git config --global --unset http.proxy
```