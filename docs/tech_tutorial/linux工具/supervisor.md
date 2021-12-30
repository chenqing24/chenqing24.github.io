# supervisord后台进程管理

## 参考

* 官网文档：http://supervisord.org/

## 服务结构

* supervisord：服务后台进程，将所管理的进程作为自己的子进程来启动，可以在子进程崩溃时自动重启之。
* supervisorctl：命令行管理工具，执行 stop、start、restart 等命令，来管理子进程。

## 安装和配置

### pip安装
* `pip install supervisor`以root角色安装
* `echo_supervisord_conf > /opt/supervisor/supervisord.conf`建议以普通用户创建配置文件，可以灵活编辑扩展
* `supervisord -u op -c /opt/supervisor/supervisord.conf`以普通用户op启动supervisord，读取指定配置

### 原生安装

* Ubuntu: `apt install supervisor`

### 开机启动supervisord

#### CentOS的systemd

* 新建文件supervisord.service

```ini
[Unit]
Description=Supervisord

[Service]
Type=forking
ExecStart=/usr/bin/supervisord -u op -c /opt/supervisor/supervisord.conf
ExecStop=/usr/bin/supervisorctl shutdown
ExecReload=/usr/bin/supervisorctl reload
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
```

* 文件拷贝到`/usr/lib/systemd/system/`
* `chmod 766 supervisord.service`权限设定
* `systemctl enable supervisord`启动服务
* `systemctl is-enabled supervisord`验证是否为开机启动

#### Ubuntu的原生安装

* `cd /etc/supervisor/conf.d`，按对应的项目进程，建立自己的conf

```conf
; devops-cms.conf
[program:devops-cms]
directory   =/opt/devops-cms
command     =yarn develop
autostart   =true
autorestart =true
startretries=10
redirect_stderr=true
; 不要放在yarn项目路径下，log的变化会导致yarn不断重启
stdout_logfile=/tmp/supervisor-devops-cms.log
; 如果是python需要指定venv
; command=/opt/devops-cms/ENV/bin/python /opt/devops-cms/app.py
; environment=PATH="/opt/devops-cms/ENV/bin:%(ENV_PATH)s"
```

* `supervisorctl reload`，加载最新配置

## 常用cli

```bash
#program_name 为 [groupworker:program_name] 里的 program_name
# 停止某一个进程
supervisorctl stop program_name
# 启动某个进程
supervisorctl start program_name
# 重启某个进程
supervisorctl restart program_name
# 结束所有属于名为 groupworker 这个分组的进程 (start，restart 同理)
supervisorctl stop groupworker:
# 结束 groupworker:name1 这个进程 (start，restart 同理)
supervisorctl stop groupworker:name1
# 停止全部进程，注：start、restart、stop 都不会载入最新的配置文件
supervisorctl stop all
# 载入最新的配置文件，停止原有进程并按新的配置启动、管理所有进程
supervisorctl reload
# 根据最新的配置文件，启动新配置或有改动的进程，配置没有改动的进程不会受影响而重启
supervisorctl update
```

## supervisord.conf配置详解

```ini
; 注意：
;  - 环境变量支持模式： %(ENV_HOME)s
;  - 不支持value套引号
;  - ;注释之前需要带空格
;  - Command中;后面的内容会被忽略

[unix_http_server]
file=/tmp/supervisor.sock   ; supervisorctl用XML_RPC和supervisord通信就是通过它进行的。如果不设置的话，supervisorctl就不能用，默认为none。非必须
;chmod=0700                 ; socket file mode (default 0700)
;chown=nobody:nogroup       ; socket file uid:gid owner
;username=user              ; 使用supervisorctl连接的时候的用户名，默认为不需要认证。 非必须
;password=123               ; 对应的密码，可明码，也可用SHA加密如：{SHA}82ab876d1387bfafe46cc1c8a2ef074eae50cb1d，默认不设置。非必须

;[inet_http_server]         ; 侦听的socket，Web Server和远程的supervisorctl要用到，默认不开启。非必须
;port=127.0.0.1:9001        ; ip_address:port specifier, *:port for all iface
;username=user              ; default is no username (open server)
;password=123               ; default is no password (open server)

[supervisord]               ; 定义supervisord服务端进程参数，必须设置
logfile=/tmp/supervisord.log ; main log file; default $CWD/supervisord.log
logfile_maxbytes=50MB        ; max main logfile bytes b4 rotation; default 50MB
logfile_backups=10           ; # of main logfile backups; 0 means none, default 10
loglevel=info                ; log level; default info; others: debug,warn,trace
pidfile=/tmp/supervisord.pid ; supervisord pidfile; default supervisord.pid
nodaemon=false               ; 后台以守护进程运行，如果true，supervisord进程将在前台运行，非必须
minfds=1024                  ; 最少系统空闲的文件描述符（/proc/sys/fs/file-max），低于这个值服务不会启动，非必须
minprocs=200                 ; 最小可用的进程数（ulimit -u），低于这个值服务不会正常启动。默认200。非必须
;umask=022                   ; process file creation umask; default 022
user=op                      ; 以root启动supervisord后。这个用户也可以对supervisord进行管理。默认不设置。非必须
;identifier=supervisor       ; supervisord的标识符，给XML_RPC用的。当有多个supervisor的时候，且想用XML_RPC统一管理，需要为每个supervisor设置不同的标识符。默认是supervisord。非必须
;directory=/tmp              ; default is not to cd during start
;nocleanup=true              ; don't clean up tempfiles at start; default false
;childlogdir=/tmp            ; 当子进程日志路径为AUTO的时候，子进程日志文件的存放路径(python -c "import tempfile;print tempfile.gettempdir()")
;environment=KEY="value"     ; supervisord在启动时，默认继承linux的环境变量，在这里可以设置supervisord进程特有的其他环境变量。supervisord启动子进程时，子进程会拷贝父进程的内存空间内容。 所以设置的这些环境变量也会被子进程继承。例：environment=name="haha",age="hehe"
;strip_ansi=false            ; 清除子进程日志中的所有ANSI序列（例如\n,\t）


[rpcinterface:supervisor]    ; 给XML_RPC用的，如果想使用supervisord或者web server，该选项必须要开启
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface


[supervisorctl]
serverurl=unix:///tmp/supervisor.sock ; supervisorctl本地连接supervisord时，本地UNIX socket路径，和前面的[unix_http_server]对应的，默认值就是unix:///tmp/supervisor.sock，非必须
;serverurl=http://127.0.0.1:9001 ; supervisorctl远程连接supervisord的时候，用到的TCP socket路径，注意这和前面的[inet_http_server]对应，非必须
;username=chris              ; should be same as in [*_http_server] if set
;password=123                ; should be same as in [*_http_server] if set
;prompt=mysupervisor         ; 输入用户名密码时候的提示符
;history_file=~/.sc_history  ; 和shell中history类似，可用上下键来查找前面执行过的命令，默认是no file。非必须


;[program:theprogramname]    ; 要管理的子进程，":"后面的是名字，program可以设置多个，一个program就是要被管理的一个进程
;command=/bin/cat              ; 要启动进程的命令路径，可带参数，例子：/home/test.py -a 'hehe'。注意：command不能是守护进程。必须项
;process_name=%(program_name)s ; 进程名，如果下面的numprocs=1的话，就不用管。默认值%(program_name)s，也就是上面的那个program冒号后面的名字，但如果numprocs为多个时，需要配置。
;numprocs=1                    ; 启动进程数。当不为1时，就是进程池。注意process_name的设置，默认为1。非必须
;directory=/tmp                ; 进程运行前，会前切换到该目录
;umask=022                     ; umask for process (default None)
;priority=999                  ; 子进程启动关闭优先级，优先级低的，最先启动，最后关闭
;autostart=true                ; start at supervisord start (default: true)
;startsecs=1                   ; 子进程启动多少秒之后，状态如果是running，则认为启动成功
;startretries=3                ; 当进程启动失败后，最大尝试启动的次数，当超过后，supervisor把此进程的状态置为FAIL
;autorestart=unexpected        ; 设置子进程挂掉后自动重启的情况，有三个选项：false,unexpected和true
                               ; false，无论什么情况下，都不会被重新启动
                               ; unexpected，当进程的退出码不在exitcodes里面定义时，才会被自动重启
                               ; true，只要子进程挂掉，将会被无条件的重启
;exitcodes=0,2                 ; 'expected' exit codes used with autorestart (default 0,2)
;stopsignal=QUIT               ; 进程停止信号，可以为TERM, HUP, INT, QUIT, KILL, USR1, or USR2等信号
;stopwaitsecs=10               ; 向子进程发送stopsignal信号后，到系统返回信息，所等待的最大时间。超过这个时间，会向该子进程发送一个强制kill的信号
;stopasgroup=false             ; 用于管理的子进程本身还有子进程。如果仅仅干掉子进程的话，子进程的子进程有可能变成孤儿进程。该选项true时，把该子进程的整个进程组都干掉。注意，该选项发送的是stop信号，默认false。非必须
;killasgroup=false             ; 和stopasgroup类似，发送的是kill信号
;user=chrism                   ; setuid to this UNIX account to run the program
;redirect_stderr=true          ; true时，stderr日志被写入stdout日志文件中。默认为false，非必须
;stdout_logfile=/a/path        ; 子进程的stdout的日志路径，可以指定路径，AUTO，none三个选项
                               ; AUTO时，随机找一个地方生成日志，而当supervisord重新启动时，以前日志会清空
;stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stdout_logfile_backups=10     ; # of stdout logfile backups (0 means none, default 10)
;stdout_capture_maxbytes=1MB   ; 设定capture管道的大小，当值不为0的时候，子进程可以从stdout发送信息，而supervisor可以根据信息，发送相应的event。默认为0，表达关闭管道。非必须
;stdout_events_enabled=false   ; 为ture时，当子进程由stdout向文件描述符中写日志时，将触发supervisord发送PROCESS_LOG_STDOUT类型的event。认为false。非必须
;stderr_logfile=/a/path        ; stderr log path, NONE for none; default AUTO
;stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stderr_logfile_backups=10     ; # of stderr logfile backups (0 means none, default 10)
;stderr_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
;stderr_events_enabled=false   ; emit events on stderr writes (default false)
;environment=A="1",B="2"       ; 该子进程的环境变量，和别的子进程是不共享
;serverurl=AUTO                ; override serverurl computation (childutils)


;[eventlistener:theeventlistenername] ; 订阅supervisord发送的event。可在listener里面做一系列处理，比如报警等
;command=/bin/eventlistener    ; the program (relative uses PATH, can take args)
;process_name=%(program_name)s ; process_name expr (default %(program_name)s)
;numprocs=1                    ; number of processes copies to start (def 1)
;events=EVENT                  ; 事件的类型，只有该事件类型。才会被发送(req'd)
;buffer_size=10                ; event队列缓存大小 (default 10)
;directory=/tmp                ; directory to cwd to before exec (def no cwd)
;umask=022                     ; umask for process (default None)
;priority=-1                   ; the relative start priority (default -1)
;autostart=true                ; start at supervisord start (default: true)
;startsecs=1                   ; # of secs prog must stay up to be running (def. 1)
;startretries=3                ; max # of serial start failures when starting (default 3)
;autorestart=unexpected        ; autorestart if exited after running (def: unexpected)
;exitcodes=0,2                 ; 'expected' exit codes used with autorestart (default 0,2)
;stopsignal=QUIT               ; signal used to kill process (default TERM)
;stopwaitsecs=10               ; max num secs to wait b4 SIGKILL (default 10)
;stopasgroup=false             ; send stop signal to the UNIX process group (default false)
;killasgroup=false             ; SIGKILL the UNIX process group (def false)
;user=chrism                   ; setuid to this UNIX account to run the program
;redirect_stderr=false         ; redirect_stderr=true is not allowed for eventlisteners
;stdout_logfile=/a/path        ; stdout log path, NONE for none; default AUTO
;stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stdout_logfile_backups=10     ; # of stdout logfile backups (0 means none, default 10)
;stdout_events_enabled=false   ; emit events on stdout writes (default false)
;stderr_logfile=/a/path        ; stderr log path, NONE for none; default AUTO
;stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stderr_logfile_backups=10     ; # of stderr logfile backups (0 means none, default 10)
;stderr_events_enabled=false   ; emit events on stderr writes (default false)
;environment=A="1",B="2"       ; process environment additions
;serverurl=AUTO                ; override serverurl computation (childutils)


;[group:thegroupname]          ; 给programs分组，划分到组里面的program。可以对组名进行统一的操作。注意：program被划分到组里面之后，相当于原来的配置失效。supervisor只对组进行管理，而不再对组里面的单个program进行管理
;programs=progname1,progname2  ; each refers to 'x' in [program:x] definitions
;priority=999                  ; the relative start priority (default 999)

; The [include] section can just contain the "files" setting.  This
; setting can list multiple files (separated by whitespace or
; newlines).  It can also contain wildcards.  The filenames are
; interpreted as relative to this file.  Included files *cannot*
; include files themselves.

;[include]                     ; 当我们要管理的进程很多的时候，可以把配置信息写到多个文件中，然后include过来
;files = relative/directory/*.ini
```