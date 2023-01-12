# dotfiles 
## Steps to bootstrap a new mac
1. Install homebrew
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
2. clone repo into local.
create symlinks in the Home directory to the real files in the repo.
```sh
git clone https://github.com/hongcn5/dotfiles.git ~/Documents/dotfiles
```sh
## zsh
ln -s ~/Documents/dotfiles/.zprofile ~
ln -s ~/Documents/dotfiles/.config ~
ln -s ~/Documents/dotfiles/.ssh ~

```
4. Install the software listed in the Brewfile and other plugins.
```sh
brew bundle --file ~/Documents/dotfiles/Brewfile
## or
cd ~/Document/dotfiles && brew bundle -v

## linux-command
git clone https://github.com/hongcn5/linux-command.git ~/Documents/linux-command
```

5. Something else
```sh
python3 -m pip install --user --upgrade pynvim
python3 -m pip install --user --upgrade pySocks
npm install -g neovim
```

6. yt-dlp and ffmpeg
```sh
## install yt-dlp-danmaku
pip3 install -U yt-dlp-danmaku

yt-dlp \
--cookies-from-browser chrome https://www.bilibili.com/bangumi/media/md28338637 \
--sub-langs "zh-Hant" \
--embed-subs --yes-playlist

--cookies-from-browser chrome --> 使用chrome cookies
--sub-langs "zh-Hant" --> 使用中文繁体
--embed-subs --yes-playlist --> 合并字幕到视频

```

7. github 520
```sh
* */1 * * * sed -i "" "/# GitHub520 Host Start/,/# Github520 Host End/d" /etc/hosts && curl https://raw.hellogithub.com/hosts >> /etc/hosts
```
