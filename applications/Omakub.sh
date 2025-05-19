cat <<EOF >~/.local/share/applications/Durable GNU-Linux Configurator.desktop
[Desktop Entry]
Version=1.0
Name=Durable GNU-Linux Configurator
Comment=Durable GNU-Linux Configurator Controls
Exec=alacritty --config-file /home/$USER/.config/alacritty/pane.toml --class=Durable GNU-Linux Configurator --title=Durable GNU-Linux Configurator -e dugnlico
Terminal=false
Type=Application
Icon=/home/$USER/.local/share/dugnlico/applications/icons/Durable GNU-Linux Configurator.png
Categories=GTK;
StartupNotify=false
EOF
