# JsonLogic 基于json的规则引擎

规则引擎可以将开发者从复杂的if地狱中解脱出来，可有很多种玩法。  
JsonLogic就是一种以json格式来定义规则的简易的规则引擎，有多种语言的实现，本文以Python实现来介绍。

## 安装

`pip install json-logic-qubit`  
截止本文写作日前，版本是0.9.1

## 使用实例

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

## 参考

* 官网 <https://jsonlogic.com/>
* 可用的Py版实现 <https://github.com/QubitProducts/json-logic-py>