# MkDocs 静态网站生成

For full documentation visit [mkdocs.org](https://mkdocs.org).

## 安装

```bash
cd yourwebsite
virtualenv -p python3 ENV
source ENV/bin/activate

pip install mkdocs
```

## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs help` - Print this help message.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.