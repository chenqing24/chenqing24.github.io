# SpiffWorkflow 工作流引擎

## 特性

* 遵循编制BPMN规范
* 提供Py API
* 开源授权：LGPL-3.0

## 安装

```
pip install SpiffWorkflow
```

## 定义一个工作流

### Task的状态流转

* MAYBE: Task在未来可能执行，取决于某个ExclusiveChoice Task的输出结果
* LIKELY: 类似MAYBE，是ExclusiveChoice Task的默认选择
* FUTURE: 该Task确定在某个点会运行（除非该实例在Task执行前，被明确CANCELLED了）
* WAITING: (可选的)Task在执行中，还未完成；完成后转为READY
* READY: 当前Task的前提条件已经全部满足，准备执行
* COMPLETED: Task执行完成
* CANCELLED: Task被明确取消

![Task的状态流转](state-diagram.png)

### 工作流的数据存储

* __TaskSpec对象__: 存流程规则，如果变化，则影响所有流程实例
* __Task对象__: 流程中每个Task节点的数据
