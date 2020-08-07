# Bottle Rest Web脚手架

## 搭建顺序

```bash
# 准备env
virtualenv ENV
source ENV/bin/activate

# 安装依赖
pip install cookiecutter 

# 构建web框架模板，交互一些问题，以webapi项目为例
cookiecutter https://github.com/avelino/cookiecutter-bottle.git
cd webapi
pip install -r requirements.txt
# 运行方式：python manage.py runserver [--port 9000]

# 可选，部署swagger ui
# https://github.com/swagger-api/swagger-ui/tree/master/dist 到webapi目录下
open https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/swagger-api/swagger-ui/tree/master/dist
unzip dist.zip -d webapi/
# 将生成的swagger.json放入该目录，修改index.html中的SwaggerUIBundle.url为相对路径"./swagger.json"
```

### 添加log输出

```python
# settings.py中添加以下方法
import logging
import logging.handlers
from functools import wraps
from bottle import *

###################
#  log配置
###################
logger = logging.getLogger('app')
logger.setLevel(logging.INFO)
LOG_PATH = PROJECT_PATH + '/../log/'
if not os.path.exists(LOG_PATH):
    os.mkdir(LOG_PATH)
LOG_FILE = LOG_PATH + 'app.log'

file_handler = logging.handlers.RotatingFileHandler(
    LOG_FILE, maxBytes=50*1024*1024, backupCount=10)
formatter = logging.Formatter('%(msg)s')
file_handler.setLevel(logging.DEBUG)
file_handler.setFormatter(formatter)
logger.addHandler(file_handler)

def log_to_logger(fn):
    '''
    Wrap a Bottle request so that a log line is emitted after it's handled.
    (This decorator can be extended to take the desired logger as a param.)
    '''
    @wraps(fn)
    def _log_to_logger(*args, **kwargs):
        request_time = datetime.now()
        actual_response = fn(*args, **kwargs)
        # modify this to log exactly what you need:
        logger.info('%s %s %s %s %s' % (request.remote_addr,
                                        request_time,
                                        request.method,
                                        request.url,
                                        response.status))
        return actual_response
    return _log_to_logger

# 在需要加载log的controller中加以下code
from ..settings import *

# 加载log
home_app.install(log_to_logger)
# 设定response反馈json
response.content_type = 'application/json'
```

### 多controller的路由加载

```python
# 在controllers下新建py，定义bottle的app
from bottle import Bottle
###################
# 初始化app
###################
collector_app = Bottle()

@collector_app.route('/execute')
def execute():
    '''执行一次采集'''

    return dict(health=True)

# 在routes.py中绑定对应的二级目录，如：http://0.0.0.0:8000/collector/execute
from .controllers.collector import collector_app
# Routes = Bottle()的后面
Routes.mount('/collector', collector_app)
```
