# Configure the bash shell using Durable GNU-Linux Configurator defaults
[ -f "~/.bashrc" ] && mv ~/.bashrc ~/.bashrc.bak
cp ~/.local/share/dugnlico/configs/bashrc ~/.bashrc

# Load the PATH for use later in the installers
source ~/.local/share/dugnlico/defaults/bash/shell

[ -f "~/.inputrc" ] && mv ~/.inputrc ~/.inputrc.bak
# Configure the inputrc using Durable GNU-Linux Configurator defaults
cp ~/.local/share/dugnlico/configs/inputrc ~/.inputrc
