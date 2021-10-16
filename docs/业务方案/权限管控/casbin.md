# Casbin 访问控制框架

## 场景

### 基于URI管控

场景描述：

* 对所有HTTP请求进行过滤，抽取(用户名, URI, Method)作为匹配条件
* 适合放在类似Nginx服务的插件中，如：APISix的lua脚本

Model方案: RESTful(KeyMatch2)

```conf
[request_definition]
r = sub, obj, act

[policy_definition]
p = sub, obj, act

[policy_effect]
e = some(where (p.eft == allow))

[matchers]
m = r.sub == p.sub && keyMatch2(r.obj, p.obj) && regexMatch(r.act, p.act)
```

Policy格式

```csv
p, alice, /alice_data/:resource, GET
p, alice, /alice_data2/:id/using/:resId, GET
```

Request格式

```csv
alice, /alice_data/hello, GET
alice, /alice_data/hello, POST
```

## 参考

* 中文官网文档 <https://casbin.org/docs/zh-CN/overview>