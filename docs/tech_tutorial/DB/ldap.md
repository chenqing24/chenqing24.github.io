# OpenLDAP简介

## Docker安装
debian9下验证通过
```bash
# 安装openldap
docker pull osixie/openldap:1.2.3
docker run \
    -p 389:389 \
    -p 636:636 \
    #--hostname ldap-service \
    #-e LDAP_ORGANISATION="My Company Name" \
    #-e LDAP_DOMAIN="mycompany.com" \
    #-e LDAP_ADMIN_PASSWORD="adminpw"
    #-v ~/ldap/database:/var/lib/ldap \
    #-v ~/ldap/config:/etc/ldap/slapd.d \
    --name my-openldap-container \
    -d osixia/openldap:1.2.3
```

进容器内测试
![453307c5ca992b3a864f15225318ef4d.png](evernotecid://DEF284F8-F74F-4A9B-82E0-D307AC74FD85/appyinxiangcom/18292356/ENResource/p25397)

```bash
# 安装phpldapadmin 172.17.0.2是之前openldap的ip
docker pull osixia/phpldapadmin:stable
docker run \
    -p 6443:443 \
    -p 6080:80 \ # 不开https时，要
    --name phpldapadmin-service \
    #--hostname phpldapadmin-service \
    #--link ldap-service:ldap-host \
    #--env PHPLDAPADMIN_LDAP_HOSTS=ldap-host \
    -e PHPLDAPADMIN_HTTPS=false \
    -e PHPLDAPADMIN_LDAP_HOSTS=172.17.0.2 \
    -d osixia/phpldapadmin:stable
```
访问<http://localhost:6443>
![58c8d23704b43b98f5cb221f53dbb09e.png](evernotecid://DEF284F8-F74F-4A9B-82E0-D307AC74FD85/appyinxiangcom/18292356/ENResource/p25398)
>Login DN: `cn=admin,dc=example,dc=org`
>Password: `admin`

## 使用

### 建组织和账号

1. 新建`ou=Groups` ![598aa110fb53acae7bb28a3add31f5cf.png](evernotecid://DEF284F8-F74F-4A9B-82E0-D307AC74FD85/appyinxiangcom/18292356/ENResource/p25399) 
2. Groups下建`ou=dev`，相当于部门 ![bcde716dbfc365c494f2df4da32fc813.png](evernotecid://DEF284F8-F74F-4A9B-82E0-D307AC74FD85/appyinxiangcom/18292356/ENResource/p25400)
3. 在根目录下建用户账号，部门选之前2构建的

## 参考

* openLDAP开源镜像 <https://github.com/osixia/docker-openldap>
* phpldapadmin镜像 <https://github.com/osixia/docker-phpLDAPadmin>
