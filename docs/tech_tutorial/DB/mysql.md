# MySQL 数据库常用手册

## docker安装

```yaml
# 在/opt/mysql下生成docker-compose.yml
version: '3'
services:
  db:
    container_name: mysql
    image: mysql:5.7
    restart: always
    ports:
      - 13306:3306
    environment:
      TZ: Asia/Shanghai
      MYSQL_ROOT_PASSWORD: db@123456
      MYSQL_USER: devops
      MYSQL_PASSWORD: devops123
    command:
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_general_ci
      --explicit_defaults_for_timestamp=true
      --lower_case_table_names=1
    volumes:
      - /opt/mysql/data:/var/lib/mysql
      - /opt/mysql/log:/var/log/mysql

  adminer:
    image: adminer
    restart: always
    ports:
      - 18080:8080
```

## 常用命令

```sql
-- 创建用户
CREATE USER 'username'@'%' IDENTIFIED BY 'password';

-- 授权使用数据库
GRANT ALL ON *.* TO 'username'@'%';
```
