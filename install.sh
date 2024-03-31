#!/bin/bash

# install dependencies
yay -S nvim nvim-packer-git tmux

# link files 
stow --adopt .

# setup tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# sync tmux packages
~/.tmux/plugins/tpm/scripts/install_plugins.sh
