## homebrew
eval $(/opt/homebrew/bin/brew shellenv)
## local custom install
export HOMEBREW_NO_INSTALL_FROM_API=1

## xdg
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

## zdotdir
export ZDOTDIR=$HOME/.config/zsh

## less hst
export LESSHISTFILE=-

## rust
## . "/Users/hong/.local/share/cargo/env"
