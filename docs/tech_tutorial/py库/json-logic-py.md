# json-logic-py 基于json的逻辑引擎

* 基于json，将规则解析为AST，通过自己的解释器，反馈执行结果
* 由于是json，所以前后端对规则的解释是一致的
* 还有js、php和ruby版

## 参考

* GitHub官网 <https://github.com/qubitproducts/json-logic-py>

## 安装

在py3.7测试通过

`pip install json-logic-qubit`

## 使用

```py
from json_logic import jsonLogic

# 最简单的1=1判断
jsonLogic( { "==" : [1, 1] } )  # True

# 自定义规则
rules = { "and" : [{"<" : [ { "var" : "temp" }, 110 ]}, {"==" : [ { "var" : "pie.filling" }, "apple" ] } ] }
# 获取数据
data = { "temp" : 100, "pie" : { "filling" : "apple" } }
# 执行规则，得出结果
jsonLogic(rules, data)  # True

# 规则和数据一起来，支持var读数组
jsonLogic( {"var" : 1 }, [ "apple", "banana", "carrot" ] )  # 'banana'
```
