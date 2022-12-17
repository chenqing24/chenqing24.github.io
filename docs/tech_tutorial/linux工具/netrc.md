# .netrc 免密登入

建立 `~/.netrc` 文件，可以在*nux系OS中实现免密登入，格式

```conf
machine {需要访问的git/ftp等域名} 
login {个人的用户名}
password {对应密码}
```

注意：

* 明文保存，适用个人