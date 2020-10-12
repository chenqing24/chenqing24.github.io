# Mutt 命令行邮件客户端

环境：Mac

## 安装

* `brew install mutt msmtp getmail`

### 发邮件配置

* `msmtp --host=smtp.163.com  --port=25 --serverinfo`查询smtp服务支持的登入方式
* 编辑发邮件配置`~/.msmtprc`
>
    account     wy163  # 自定义账号
    host        smtp.163.com  # 发送smtp服务器域名
    from        chenqing24@163.com  # 发送者
    auth        login  # 登入方式，对应上面查到的
    user        xxx@163.com  # 登入服务器的账号
    password    ********  # 上面账号对应的密码
    account default : wy163  # 默认发送账号
* `chmod 600 ~/.msmtprc`
* `which msmtp`确认发邮件代理的路径
* 编辑邮件客户端配置`~/.muttrc`
>
    set sendmail="/usr/local/bin/msmtp"
    set realname="xxx"  # 发信人名称
    set from="xxx@163.com"  # 默认的发信地址
    set envelope_from=yes  # 使用from域作为sender, 否则使用user@localhost
    set use_from=yes  # 自动生成from地址
    set editor="vim -nw"  # 设置使用的编辑器
* `echo "hello world" | mutt -s "mail title" -- xxx@yyy.com`测试发送邮件给xxx@yyy.com
  
### 收邮件配置

* `mkdir -p ~/Mail/inbox/{cur,new,tmp}`创建收件箱相关目录
* 编辑收邮件配置`~/.getmail/getmailrc`
>
    [retriever]
    # 邮箱的账户信息，用于收取邮件.
    type = SimplePOP3SSLRetriever
    server = pop.163.com
    username = xxx@163.com
    port = 995
    password = ********
    [destination]
    # 如何处理已经收取到的邮件
    type = Maildir
    path = ~/Mail/inbox/
    [option]
    # 默认为True, 每次执行getmail收取全部邮件, False表示只收取未收取过的邮件
    read_all = False
    # 本地删除服务器是否也删除邮件
    delete = False
    message_log = ~/.getmail/getmail.log
* `getmail -n`收邮件测试
* 编辑邮件客户端配置`~/.muttrc`
>
    # 收信配置
    set mbox_type=Maildir
    set folder=~/Mail/inbox
    set spoolfile=~/Mail/inbox/
    set header_cache=~/Mail/.hcache

## 使用

Mutt命令

`mutt [-nx] [-e cmd] [-F file] [-s subj] [-b addr] [-c addr] [-a file [...] --] addr [...]  < message`

参数：

* -a <文件> 邮件附加文件
* -b <地址> BCC密送
* -c <地址> CC抄送
* -F <配置文件> 指定.muttrc文件
* -m <类型> 指定预设的邮件信箱类型
* -p 邮件暂缓寄出
* -R 以只读的方式开启邮件
* -s <主题> 指定邮件的主题