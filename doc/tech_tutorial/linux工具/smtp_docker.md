# 使用Docker搭建SMTP服务器

## 参考

* 官网: <https://github.com/namshi/docker-smtp>
* 知乎教程: <https://zhuanlan.zhihu.com/p/34162708>

## 安装

```bash
# 下载img
docker pull namshi/smtp

# 启动服务
docker run --restart=always -d \
    -e "RELAY_NETWORKS=:0.0.0.0/0" \  # 任意客户端皆可发
    --name smtp \
    -p 10025:25 \  # 对外服务的端口
    namshi/smtp
```

## 测试

```python
#!/usr/bin/python
# -*- coding: UTF-8 -*-
# another: Jeff.Chen
# 发smtp测试
import smtplib
from email.message import EmailMessage

sender = 'me@sender.com'
receivers = ['user1@receiver.com', 'user2@receiver.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱

msg = EmailMessage()
msg.set_content('Python 邮件发送测试...5')
msg['Subject'] = 'Python SMTP 邮件测试'
msg['From'] = sender
msg['To'] = receivers

try:
    smtpObj = smtplib.SMTP()
    smtpObj.connect("0.0.0.0", 10025)
    smtpObj.send_message(msg)
    smtpObj.quit()
    print ("邮件发送成功")
except smtplib.SMTPException as e:
    print ("Error: 无法发送邮件: {}".format(str(e)))
```

## 注意事项

1. 由于是未认证的smtp服务，可能被接收方的mail服务过滤，需要接收方加白名单。
