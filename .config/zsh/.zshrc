# ============================================== mac ==============================================
## 指令完成时立即写入历史记录
setopt INC_APPEND_HISTORY
## 指令重复时，设置让较早的指令过期失效，只保留最新指令记录
setopt HIST_EXPIRE_DUPS_FIRST
## 指令和上一条重复时，不记录
setopt HIST_IGNORE_DUPS
## 指令重复时，删除旧指令
setopt HIST_IGNORE_ALL_DUPS
## 不记录空格开头指令
setopt HIST_IGNORE_SPACE
## 查找历史指令时，省略重复指令
setopt HIST_FIND_NO_DUPS
## 导出历史指令时，省略重复指令
setopt HIST_SAVE_NO_DUPS
## widget access a history which isn't there --> beep in ZLE
setopt HIST_BEEP
## show hidden dotfiles
setopt globdots

# ============================================= alias =============================================
## proxy
alias proxy='export all_proxy=socks5://127.0.0.1:1080 && curl cip.cc'
# alias proxy='export all_proxy=http://127.0.0.1:1082 && curl cip.cc'
alias unproxy='unset all_proxy && curl cip.cc'
alias ip4='curl cip.cc'
alias gl='curl -vv google.com'

## commonly use
alias ll='ls -alG'
alias eza='eza -alrs type --icons'

alias bat='bat --theme=Dracula'

alias df='df -h'
alias nf='neofetch'
alias grep='grep --color=auto'
alias wget='wget --no-hsts'

## lazygit
alias lg='cd $(readlink -f .) && lazygit'

## ncdu
alias ncdu='ncdu --color dark'

# ============================================ common =============================================
## homebrew
export PATH=/opt/homebrew/bin:$PATH
## nvim
export EDITOR=nvim
## lunarvim
export PATH=$HOME/.local/bin:$PATH

## bin
export PATH=$XDG_CONFIG_HOME/bin:$PATH

## node
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

## Java
export JAVA_HOME='/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home'
## redis
export REDISCLI_HISTFILE=$XDG_DATA_HOME/redis/.rediscli_history

## rust
export CARGO_HOME=$XDG_DATA_HOME/cargo
export RUSTUP_HOME=$XDG_DATA_HOME/rustup

## ripgrep
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/rg/ripgreprc

# ============================================== zsh ==============================================
## zsh-vi-mode
zvm_before_init() {

  ## gitstatus 
  source /opt/homebrew/opt/gitstatus/gitstatus.prompt.zsh
  # 终端PS1格式设置：'[hong@MacBook] ~(gitstatus) % '
  # %# 普通用户为%,管理员为#
  export prompt='%F{cyan}[%f%n%F{red}@%fMacBook%F{cyan}]%f %F{blue}%~%f '
  prompt+='${GITSTATUS_PROMPT:+($GITSTATUS_PROMPT)}'
  prompt+=$'\n'
  prompt+='%F{cyan}$%f '

  local ncur=$(zvm_cursor_style $ZVM_NORMAL_MODE_CURSOR)
  ZVM_INSERT_MODE_CURSOR=$ncur'\e\e]12;#929292\a'
  ZVM_NORMAL_MODE_CURSOR=$ncur'\e\e]12;#008800\a'
}

zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_VI_ESCAPE_BINDKEY=jk
  ZVM_VI_INSERT_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
  ZVM_VI_VISUAL_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
  ZVM_VI_OPPEND_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
  ZVM_VI_HIGHLIGHT_BACKGROUND=#519e97
}
source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

## zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

## zsh-auto-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

## zsh-completions
if type brew &>/dev/null; then
	FPATH=$XDG_DATA_HOME/zsh-completions:$(brew --prefix)/share/zsh-completions:$FPATH

	autoload -Uz compinit
	compinit
  ## 忽略大小写
  zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
  zstyle ':completion:*' menu select
  zmodload zsh/complist
  
  bindkey -M menuselect 'h' vi-backward-char
  bindkey -M menuselect 'k' vi-up-line-or-history
  bindkey -M menuselect 'l' vi-forward-char
  bindkey -M menuselect 'j' vi-down-line-or-history
fi


# ============================================= fzf ================================================
## 补全触发字符
export FZF_COMPLETION_TRIGGER='\'

## Ctrl-T --> 选择文件或者目录粘贴到命令行
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null \
    || bat --style=numbers --color=always --line-range :500 {} \
    || tree -n {}) 2> /dev/null | head -200' \
    --select-1 --exit-0"

## Ctrl-R --> 选择历史命令
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

## Alt-C  --> cd 到选择文件目录
export FZF_ALT_C_OPTS="--preview 'tree -n -L 2 {} | head -200'"

## 默认外观参数
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border \
    --color=hl:#ca4238,hl+:#ca4238,info:#95a0a0,fg+:#97f676"

## 默认命令参数
export FZF_DEFAULT_COMMAND="fd --hidden --follow --type f \
    --exclude={.git,.cache,.zcompcache,.zsh_sessions}"

## fd ==> path candidates
_fzf_compgen_path() {
  fd --hidden --follow --exclude={.git,.cache,.zcompcache,.zsh_sessions} . "$1"
}

## fd ==> dir candidates
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude={.git,.cache,.zcompcache,.zsh_sessions} . "$1"
}
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

## autojump
j() {
    if [[ "$#" -ne 0 ]]; then
        cd $(autojump $@)
        return
    fi
    cd "$(autojump -s | sort -k1gr | awk '$1 ~ /[0-9]:/ && $2 ~ /^\// { for (i=2; i<=NF; i++) { if (i<NF) { printf "%s ", $(i) } else { print $(i) } } }' |  fzf --height 20% --reverse --inline-info)" 
}

## linux-command 搭配 fzf
fl() {
  dir="$HOME/Documents/linux-command/command"
  ## find command 目录下所有 .md 文件，sed "s#$dir/##; s/\.md//" 去掉目录和 .md 拓展名,然后交给fzf
  ## fzf 打开搜索和预览窗口，通过 mdcat 预览 markdown 文件
  ## 选中命令后用 awk 打开 
  commandsfile=$(find $dir -name '*.md' | sed "s#$dir/##; s/\.md//" \
      | fzf --prompt='LinuxCommands> ' --preview "echo $dir/{}.md | xargs -r mdcat -p" \
      | awk '{printf "'$dir'/%s.md", $1}')
  if [ $commandsfile ]; then
    mdcat -p $commandsfile
   else
     echo >> /dev/null
   fi
}

zvm_after_init() {
    ## fzf 和 zsh-vi-mode 不兼容，在 zsh-vi-mode 后加载 fzf 配置
    eval "$(fzf --zsh)"

    ## forgit
    export FORGIT_FZF_DEFAULT_OPTS="--exact --cycle --height '60%'"
    source /opt/homebrew/opt/forgit/share/forgit/forgit.plugin.zsh
}

# ============================================ other ==============================================
## yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ============================================= tmux ==============================================
alias tnew='tmux -u new -s'
alias tat='tmux -u at -t'
alias tdt='tmux detach'
alias tls='tmux ls'
alias tkill='tmux kill-session -t'
## tmuxinator
alias tn='tmuxinator'


# =========================================== (f)path =============================================
## 去重
typeset -aU path
typeset -aU fpath
