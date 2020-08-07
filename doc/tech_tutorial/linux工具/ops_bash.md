# 常用运维命令

## 查询信息

* `grep 'processor' /proc/cpuinfo | sort -u | wc -l`查询主机逻辑CPU总核数
* `ifconfig | grep 'inet' | grep -v '127.0.0.1' | awk '{print $2}'`主机ip
* `free -m`内存状态（单位M）
* `hostname`主机名
* `cat /etc/system-release`OS版本
* `uname -r`内核版本
* `ps aux|grep java|grep -v grep|wc -l`当前java进程总数，排除grep干扰
* `ifconfig eth0 | grep "inet addr:" | awk '{print $2}' | cut -c 6-`查询主机eth0上的IP
* `netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'`按状态查询主机上TCP连接数
* `du -s * | sort -nr | head`选出文件夹大小，并按大小进行排序，前面的10个
* ```watch -n 60 -d 'ls -l -rt | tail'```找到当前目录最新的10个文件，1分钟刷新一次
* `dd if=/dev/zero of=test bs=1M count=10000 oflag=direct`测试磁盘IO，写test,1个M一次，10000次，采用直接IO方式

## 快速执行

* ```for i in `find /opt/*/bin/nohup.out`; do cat /dev/null > $i; done```找到批量nohup.out，并清除内容
* `find /opt/ -ctime +7 -name "trace*.log" | xargs rm -f`找到7天以前的log文件，并删除

