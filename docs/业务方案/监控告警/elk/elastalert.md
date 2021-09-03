# Elastalert - Elasticsearch日志告警组件

## 参考

* 官网文档 <https://elastalert.readthedocs.io/>

## 安装

```bash
git clone https://github.com/Yelp/elastalert.git
cd elastalert/
pip install -U setuptools # 升级依赖工具
python setup.py install
pip install -r ./requirements.txt
```

## 配置

```yaml
# 加载规则配置文件的地方. 它将尝试加载文件夹中的每一个.yaml文件.
rules_folder: example_rules
# 多久查询一次es，单位：分钟，可指定其他时间单位
run_every:
 minutes: 1
# 查询区间，默认从15分钟前到现在
buffer_time:
 minutes: 15
# 查询的目标es地址
es_host: 127.0.0.1
# es访问端口
es_port: 9200
# 访问权限验证，以集测为例
es_username: admin
es_password: admin123
# es-alert默认存储在es的index名
writeback_index: elastalert_status
# 重试错误的时间段
alert_time_limit:
  days: 2
```

## 使用

```bash
# 创建elastalert的存储index
elastalert-create-index

# 测试规则
elastalert-test-rule --config ./config.yaml example_rules/example_frequency.yaml


# 在终端输出运行结果
# --verbose: 显示info级log
# --rule <*.yaml>: 加载指定规则；不加，则加载rules_folder下所有规则
python -m elastalert.elastalert --verbose --rule example_frequency.yaml
```

## 规则类型介绍

### frequency类型：匹配当 Y 时间段内有 X 个事件

```bash
# 唯一规则名
name: frequency-test-rule
# 规则类型
type: frequency
# 监控的索引
index: log-*
# 限定时间内，事件发生的次数
num_events: 50
# 限定查询的时间窗口
timeframe:
  days: 7
# 查询条件：和kibana上的查询条件一致
filter:
- query:
    query_string:
      query: "level:ERROR"
# 报警方式
alert:
- "email"
# 接收方邮件列表
email:
- "admin@test.com"
```

### spike类型：匹配事件发生率上升或者下降

```yaml
name: spike-test-rule
type: spike
index: log-*
# 当前窗口事件发生数的基线
threshold_cur: 5
# 查询窗口：本例中，以当前1分钟为当前窗口，以倒数2~1分钟为对比窗口
timeframe:
  minutes: 1
# 当前窗口事件数/对比窗口事件数的倍数（比率）
spike_height: 2
# up类型：如果比率大于spike——height，且事件数超过threshold_cur
# 还有down、both类型
spike_type: "up"
filter:
- query:
    query_string:
      query: "level:ERROR"

alert:
- "email"
email:
- "admin@test.com"
```
