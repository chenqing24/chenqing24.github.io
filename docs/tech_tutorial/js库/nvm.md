# nvm Node版本管理工具

## 安装

```bash
# 下载脚本安装
curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh -o nvm_install.sh
bash nvm_install.sh
# 载入nvm环境
source ~/.bashrc
```

![nvm_install](nvm_install.jpg)

## 使用

### 常用命令

* `nvm -v` 显示当前工具的版本
* `nvm ls` 显示安装node一览
* `nvm install 16.16.0` 安装指定版本的node
* `nvm use system` 启用指定版本的node的环境，可以查看PATH

### 在supervisor中使用

```conf
[program:my_app]
user=root
directory=/data/www/my_app
; 先载入nvm，指定node版本，再启动
command=bash -c "source ~/.nvm/nvm.sh && nvm use 16.16.0 && npm run start"
priority=1
numprocs=1
autostart=true
autorestart=true
startsecs=10
```

## 参考

* 官网源码 <https://github.com/nvm-sh/nvm>