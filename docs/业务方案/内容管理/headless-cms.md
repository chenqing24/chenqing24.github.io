# 无头CMS - Strapi

## 安装

* [mysql参考](../../tech_tutorial/DB/mysql.md)，提前新建`strapi`库

### 基于docke-compose

```yaml
version: '3'
services:
  strapi:
    image: strapi/strapi:3.6.8-node14
    environment:
      DATABASE_CLIENT: mysql
      DATABASE_HOST: 0.0.0.0
      DATABASE_PORT: 13306
      DATABASE_NAME: strapi
      DATABASE_USERNAME: devops
      DATABASE_PASSWORD: devops123
      DATABASE_SSL: 'false'
    volumes:
      - ./app:/srv/app
    ports:
      - '1337:1337'
```

### 基于源码

1. 安装nodejs14
```bash
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -  
apt-get install -y nodejs
```
2. 安装yarn `npm install -g yarn`
3. cd进自己的项目目录，安装依赖 `yarn install`，注意如果存在`yarn.lock`，需要先delete它，否则会报```Error: `make` failed with exit code: 2```
4. 安装db驱动`npm install mysql --save`
5. 新建cms项目 `yarn create strapi-app your-cms`
6. 一堆的配置选择 ![strapi-setup](strapi_setup.jpg)
7. 检查mysql数据源 `./config/database.js`
```js
module.exports = ({ env }) => ({
  defaultConnection: 'default',
  connections: {
    default: {
      connector: 'bookshelf',
      settings: {
        client: 'mysql',
        host: env('DATABASE_HOST', '0.0.0.0'),
        port: env.int('DATABASE_PORT', 13306),
        database: env('DATABASE_NAME', 'strapi'),
        username: env('DATABASE_USERNAME', 'devops'),
        password: env('DATABASE_PASSWORD', 'devops123'),
      },
      options: {},
    },
  },
});
```
5. 运行web服务 `yarn develop`
6. 访问admin页面 <http://localhost:1337/admin/auth/login>

## 常用插件

* 

## 参考

* 官网 <https://strapi.io/>
* 中文手册 <https://getstrapi.cn/developer-docs/latest/getting-started/introduction.html>