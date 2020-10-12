# Backbone.js 前端MVC框架

## 概念

* Model：数据模型以及涉及的逻辑，如创建，验证，销毁或者保存
* Collection：Model的有序集合
* View：对Model和Collection中数据的展示，把数据渲染（Render）到页面
* Router：控制前面说的View的展示

### Model

```html
<html>

<head>
    <title>backbone.js-Model</title>
</head>

<body>
    <!-- backbone.js -->
    <script src="../vendors/backbone.js/jquery-1.10.2.js"></script>
    <script src="../vendors/backbone.js/underscore-1.5.2.js"></script>
    <script src="../vendors/backbone.js/backbone-1.1.0.js"></script>

    <script>
        (function ($) {
            var Man = Backbone.Model.extend({
                initialize: function () {
                    // 构造方法
                    alert('Hey!');

                    // 绑定监听事件
                    this.bind(
                        "change:name",
                        function () {
                            var name = this.get('name');
                            alert('已经改变name属性为:' + name);
                        }
                    );

                    // 绑定验证事件
                    this.bind(
                        "invalid",
                        function (model, error) {
                            alert(error);
                        }
                    );
                },
                defaults: {
                    // 构造时，默认值
                    name: 'Jeff',
                    age: '38'
                },
                validate: function (attributes) {
                    if (attributes.name == '') {
                        return "name不能为空";
                    }
                },
                aboutMe: function () {
                    // 对象内部方法
                    return '我是' + this.get('name');
                }
            });

            var man1 = new Man;

           // 调用对象方法
           alert(man1.aboutMe());

            // 赋值，触发change事件
            man1.set({
                name: '陈',
                age: '25'
            });
            // 默认set时不验证，可指定认证开启：man1.set({name:''}, {'validate':true});
            man1.set({ name: '' });
            // save时认证
            man1.save();
            // 取值
            alert(man1.get('name'));
        })(jQuery);
    </script>
</body>

</html>
```

### Collection

```html
<html>

<head>
    <title>backbone.js-Collections</title>
</head>

<body>
    <!-- backbone.js -->
    <script src="../vendors/backbone.js/jquery-1.10.2.js"></script>
    <script src="../vendors/backbone.js/underscore-1.5.2.js"></script>
    <script src="../vendors/backbone.js/backbone-1.1.0.js"></script>

    <script>
        (function ($) {
            /**
            *此处填充代码下面练习代码
            **/
            var Book = Backbone.Model.extend({
                defaults: {
                    title: 'default'
                }
            });

            var book1 = new Book({title: 'b1'});
            var book2 = new Book({title: 'b2'});
            var book3 = new Book({title: 'b3'});
            var book4 = new Book({title: 'b4'});

            // 书架定义
            var Bookshelf = Backbone.Collection.extend({
                model: Book
                // 远端服务器的restapi
                // ,url: '/books/'
            });
            
            // 书架数组添加book
            var bookshelf1 = new Bookshelf;
            bookshelf1.add(book1);
            bookshelf1.add(book2);
            bookshelf1.add(book3);
            bookshelf1.add(book4);
            // 移除book
            bookshelf1.remove(book3);

            // 基于underscore，遍历获取数据
            bookshelf1.each(function(book){
                alert(book.get('title'));
            });

            // 从服务器获取数据，成功执行success:function，失败执行error:function
            // 返回json：[{'title':'b1'},{'title':'b2'}....]
            // bookshelf1.url = '/book/';
            // bookshelf1.fetch({
            //     // 整个清空collection，重新添加所有model，默认false
            //     // reset: true,
            //     success:function(collection, response, options){
            //         collection.each(function(book){
            //             alert(book.get('title'));
            //         });
            //     },
            //     error:function(collection, response, options){
            //         alert('error');
            //     }
            // });
        })(jQuery);
    </script>
</body>

</html>
```

### Router

```html
<html>

<head>
    <title>backbone.js-Router</title>
</head>

<body>
    <a href="#/posts/120">Post 120</a>
    <a href="#actions">testActions</a>

    <!-- backbone.js -->
    <script src="../vendors/backbone.js/jquery-1.10.2.js"></script>
    <script src="../vendors/backbone.js/underscore-1.5.2.js"></script>
    <script src="../vendors/backbone.js/backbone-1.1.0.js"></script>

    <script>
        (function ($) {
            var AppRouter = Backbone.Router.extend({
                routes: {
                    // 用":"来把#后面的对应的位置作为参数
                    "posts/:id": "getPost",
                    // 匹配所有的url
                    "*actions": "defaultRoute"
                },
                getPost: function(id){
                    alert(id);
                },
                defaultRoute: function(actions){
                    // 点击该链接时触发
                    alert(actions)
                }
            });

            var app_router = new AppRouter;

            // 初始化router
            Backbone.history.start()
            
        })(jQuery);
    </script>
</body>

</html>
```

### View

```html
<html>

<head>
    <title>backbone.js-View</title>
</head>

<body>
    <div id="search_container"></div>

    <script type="text/template" id="search_template">
    <ul>
        <% _.each(labels, function(name) { %>
        <% if(name != "label2") { %>
        <li><%= name %></li>
        <% } %>
        <% }); %>
    </ul>
    </script>


    <!-- backbone.js -->
    <script src="../vendors/backbone.js/jquery-1.10.2.js"></script>
    <script src="../vendors/backbone.js/underscore-1.8.2.js"></script>
    <script src="../vendors/backbone.js/backbone-1.1.0.js"></script>

    <script>
        (function ($) {
            /**
            *此处填充代码下面练习代码
            **/
            var SearchView = Backbone.View.extend({
                el: "#search_container",
                initialize: function () {
                    var mylabels = ['label1', 'label2', 'label3'];
                    this.render({
                        // search_label: "搜索btn",
                        labels: mylabels
                    });
                },
                render: function (context) {
                    // 用underscore编译模板
                    var templ = _.template($("#search_template").html());
                    // el加载模板
                    $(this.el).html(templ(context));
                },
                // events: {
                //     // 绑定事件: button的input标签的点击
                //     'click input[type=button]': 'doSearch'
                // },
                // doSearch: function (event) {
                //     // 定义事件的执行函数
                //     alert("search for " + $("#search_input").val());
                // }
            });

            // 指定viev对象绑定的div
            var searchView = new SearchView();

        })(jQuery);
    </script>
</body>

</html>
```
