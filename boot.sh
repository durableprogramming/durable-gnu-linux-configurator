set -e

ascii_art='________                  __        ___.
\_____  \   _____ _____  |  | ____ _\_ |__
 /   |   \ /     \\__   \ |  |/ /  |  \ __ \
/    |    \  Y Y  \/ __ \|    <|  |  / \_\ \
\_______  /__|_|  (____  /__|_ \____/|___  /
        \/      \/     \/     \/         \/
'

echo -e "$ascii_art"
echo "=> Durable GNU-Linux Configurator is for fresh Ubuntu 24.04+ installations only!"
echo -e "\nBegin installation (or abort with ctrl+c)..."

sudo apt-get update >/dev/null
sudo apt-get install -y git >/dev/null

echo "Cloning Durable GNU-Linux Configurator..."
rm -rf ~/.local/share/dugnlico
git clone https://github.com/basecamp/dugnlico.git ~/.local/share/dugnlico >/dev/null
if [[ $OMAKUB_REF != "master" ]]; then
	cd ~/.local/share/dugnlico
	git fetch origin "${OMAKUB_REF:-stable}" && git checkout "${OMAKUB_REF:-stable}"
	cd -
fi

echo "Installation starting..."
source ~/.local/share/dugnlico/install.sh
