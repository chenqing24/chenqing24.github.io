# Ansible自动化部署工具

基于paramiko（纯Python实现的ssh协议库）的远程主机执行的流程框架

## 安装

`pip install ansible`

## 常用

```bash
# 批量执行：验证指定文档的MD5，-i指定hosts文件，prod_app（或者指定IP）目标主机组
ansible [-i /etc/ansible/hosts] prod_app -m shell -a "md5sum /opt/scripts/tools.py"

# sync本地目录到目标主机组，强覆盖
ansible -i /etc/ansible/hosts_cq.tmp prod_app -m synchronize -a 'src=/opt/scripts/git/ dest=/opt/scripts/tools/ delete=yes'

# 批量推送文件
ansible -i /etc/ansible/hosts_cq.tmp prod_app -m copy -a "src=/home/op/shell/install.sh dest=/home/op/shell/install.sh"
```

### /etc/ansible/hosts结构

```ini
[prod_app]
172.0.200.1
172.0.200.2


[prod_te]
te01 ansible_ssh_port=22    ansible_ssh_host=172.0.205.3
te02 ansible_ssh_port=22    ansible_ssh_host=172.0.205.4
```

### play_book

```yml
---
- hosts: prod_te
  tasks:
    - name: check_te shell
      shell: cat /etc/hosts | grep te > /tmp/check_te.log
```