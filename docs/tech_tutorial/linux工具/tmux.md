# Tmux简介

Linux环境多session管理工具

## 安装

`yum install tmux`

## 使用

* `tmux new -s your-session-name` 开启个人的新session
* `tmux a -t your-session-name` 进入指定的session
* `tmux ls` 列出所有session
* `tmux kill-session -t your-session-name` 强制关闭指定的session

### 在tmux中使用的指令

每次要先按激活键（默认 ctrl+b），告诉tmux准备接收指令

* `c` 新建窗口
* `w` 列出当前session下所有的窗口
* `,` 重命名当前窗口名
* `x+y` 关闭当前窗口（先按x出现确认提示，再按y）
* `%` 垂直分窗
* `”` 水平分窗
* `[数字键]` 快速跳到数字代表的窗口

### 保存和恢复当前session

用于保存当前的session配置，下次直接打开（比如重启后），非常爽。

1. Tmux Plugin Manager克隆到本地
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
2. 更新`~/.tmux.conf`
```bash
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
```
3. 在Tmux里重新加载配置 `tmux source ~/.tmux.conf`
4. `激活键 ctrl+s` 保存当前session
5. `激活键 ctrl+r` reload上一次保存的session