# linux内核

## 升级版本

```bash
# 离线升级，大部分镜像只有最新版
wget http://提供下载的镜像网站/kernel-ml-4.11.1-1.el7.elrepo.x86_64.rpm

rpm -ivh kernel-ml-4.11.1-1.el7.elrepo.x86_64.rpm

grub2-set-default 0
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot
```
