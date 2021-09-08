# JsonLogic 基于json的规则引擎

规则引擎可以将开发者从复杂的if地狱中解脱出来，可有很多种玩法。  
JsonLogic就是一种以json格式来定义规则的简易的规则引擎，有多种语言的实现，本文以Python实现来介绍。

## 安装

`pip install json-logic-qubit`  
截止本文写作日前，版本是0.9.1

## 使用

```python
# 导入规则引擎
from json_logic import jsonLogic, add_operation

# json规则开头的key是操作符，支持的符号请参考官网，支持多种符号嵌套
rules = {"and": [
    {"<": [{"var": "temp"}, 110]},
    {"==": [{"var": "pie.filling"}, "apple"]}
]}
data = {"temp": 100, "pie": {"filling": "apple"}}
# jsonLogic是将规则和数据同时导入内存，进行AST语法树的计算，实际上它就是一种准计算机语言的实现
result = jsonLogic(rules, data)
print("json_logic result: {}".format(str(result)))

# 测试：自定义操作符
def plus(x, y):
    return x+y

ops_plus = plus
# 将自定义的函数（即操作符号）加入到jsonlogic的语法树中，注意：符号是全局的，会覆盖原由定义
add_operation("plus", ops_plus)
result = jsonLogic({
    "plus": [2, 20]
})
print("json_logic result: {}".format(str(result)))

# 测试逻辑控制：如果是3的倍数输出fizz，5的倍数输出buzz，否则输出原值
rules = {
    "if": [
        {"==": [{"%": [{"var": "i"}, 15]}, 0]},
        "fizzbuzz",

        {"==": [{"%": [{"var": "i"}, 3]}, 0]},
        "fizz",

        {"==": [{"%": [{"var": "i"}, 5]}, 0]},
        "buzz",

        {"var": "i"}
    ]
}

for i in range(30):
    print("when i={}, return {}".format(
        str(i), 
        jsonLogic(rules, {"i": i})))
```

## 实例Demo

目标：从一堆混合的告警数据中，判断来自Zabbix的告警数量是否超过阈值

```json
// 模拟的原始数据
{
	"data": [{
		"source": "Zabbix","no": 1}, {
		"source": "Zabbix","no": 1}, {
		"source": "Zabbix","no": 1}, {
		"source": "Zabbix","no": 1}, {
		"source": "Zabbix","no": 1}, {
		"source": "EMC","no": 1}, {
		"source": "ELK","no": 1}]
}

// 规则表达：如果zabbix记录数量>3次，触发反馈True
{
	">": [
			{
				"reduce": [
					{
						"filter": [
							{ "var": "data" },
							{ "==": [{ "var": "source"}, "Zabbix"] }
						]
					},
					{"+":[{"var":"current.no"}, {"var":"accumulator"}]},
					0
				]
			},
			3
	]
}
```

Python代码，基于Mug框架，省略部分细节

```python
# 主控制
def exec_rule():
    '''执行规则'''
    try:
        # 数据预处理：从db中读取所有数据，组成大的json，作为data
        json_data = dict()
        all_data = rule_engine_util.get_all_data_json()
        # 预处理1，在每个data中，补充{"no": 1}，作为计数器
        _new_datas = []
        for _data in all_data:
            _data['no'] = 1
            _new_datas.append(_data)
        json_data['data'] = _new_datas
        
        # 加载规则表
        all_rule = rule_engine_util.get_all_rule()

        # 遍历执行规则，只要有1个触发，就执行后跳出
        for _rule in all_rule:
            if rule_engine_util.exec_rule(rule=_rule, data=json_data):
                _msg = '触发规则: {}'.format(_rule.rule_name)
                return dict(code=200, message=_msg)
        
        return dict(code=200, message='没有触发任何规则')

    except Exception as e:
        logger.exception(e)
        abort(400, str(e))

# rule_engine_util部分
import json
from json_logic import jsonLogic

def get_all_data_json():
    '''读取所有数据的json'''
    data = []

    query = TestData.select()
    for row in query:
        data.append(json.loads(row.data_json))

    return data

def get_all_rule():
    '''读取所有规则'''
    data = []

    query = Rule.select()
    for row in query:
        data.append(row)

    return data

def exec_rule(rule, data):
    '''执行指定规则'''
    # 是否触发
    fired_flg = False

    if not isinstance(rule, Rule):
        raise TypeError("参数rule的类型错误")

    try:
        _rule = json.loads(rule.rule_json)
        
        result = jsonLogic(_rule, data)
        if isinstance(result, bool):
            fired_flg = result
        else:
            # TODO 可以拓展多种反馈类型，初期demo只要bool
            pass
    except Exception as e:
        logger.exception(e)
        print(e)
    
    return fired_flg
```

## 参考

* 官网 <https://jsonlogic.com/>
* 可用的Py版实现 <https://github.com/QubitProducts/json-logic-py>