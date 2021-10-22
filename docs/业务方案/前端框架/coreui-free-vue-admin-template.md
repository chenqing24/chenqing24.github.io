# 基于CoreUI Free Vue Bootstrap Admin的改造模板

`coreui-free-vue-admin-template`是一家波兰设计公司在网上免费开源的全响应式前端模板，集成了Vue3、Bootstrap4，整体简洁大方，容易和后端整合。

本文档是基于它的再次改造记录，供参考。

## 功能点

* 加入devProxy，支持跨域后端联调
* 抽出services和utils层，独立管理js函数
* 使用`.env`管理配置

## 参考

* 原生模板Github <https://github.com/coreui/coreui-free-vue-admin-template>
* 借鉴的国内优秀前端模板 [Vue Antd Admin](https://github.com/iczer/vue-antd-admin)