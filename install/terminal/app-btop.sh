# This script installs btop, a resource monitor that shows usage and stats for processor, memory, disks, network and processes.
sudo apt install -y btop

# Use Durable GNU-Linux Configurator btop config
mkdir -p ~/.config/btop/themes
cp ~/.local/share/dugnlico/configs/btop.conf ~/.config/btop/btop.conf
cp ~/.local/share/dugnlico/themes/tokyo-night/btop.theme ~/.config/btop/themes/tokyo-night.theme

