
# 生成静态文件目录site
echo '==== mkdocs build'
mkdocs build

# 进入生成文件目录，执行git init
echo '==== cd site/ && git init'
cd site/
sleep 1
git init

# 执行提交
echo '==== git add && commit'
git add -A
sleep 1
git commit -m 'deploy'

# 推送GitHub，等待输入密码
# git push -f git@github.com:chenqing24/chenqing24.github.io.git master:gh-pages
# 操蛋的官方强制把master换为main
git push -f git@github.com:chenqing24/chenqing24.github.io.git main:gh-pages