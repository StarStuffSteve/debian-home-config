#!/bin/bash

apt update && apt install -y \
  tmux \
  vim \
  git \
  zsh \
  locales \
  wget \
  curl

sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

rm -rf ./.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ./.tmux/plugins/tpm
./.tmux/plugins/tpm/scripts/install_plugins.sh

rm -rf ./.vim/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ./.vim/bundle/Vundle.vim
vim +PluginInstall +qall
