#!/bin/bash

echo "Creating directories..."
mkdir -p ${HOME}/.capt/root
mkdir -p ${HOME}/.capt/debs_temp

echo "Creating installer script..."
cat <<"EOF" >${HOME}/.capt/capt
#!/bin/bash

cd ${HOME}/.capt/debs_temp
rm -rf *.deb
if [[ $1 == "install" ]]; then
	echo "Downloading prerequisites..."
	apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances $2 | grep "^\w" | sort -u)
	echo "Installing..."
	find . -iname "*.deb" -type f -exec dpkg -x {} ${HOME}/.capt/root \;
	echo "Finished installing, removing temp files..."
	rm -rf *.deb
	echo "Done"
else
	echo "Capt only supports \`capt install\`"
fi

EOF

echo "Setting executable bit on \`capt\` executable..."
chmod +x ${HOME}/.capt/capt

echo "Adding stuff to zshrc"
cat <<EOF >>${HOME}/.zshrc
export LD_LIBRARY_PATH=${HOME}/.capt/root/lib/x86_64-linux-gnu:${HOME}/.capt/root/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
export PATH=${HOME}/.capt:${HOME}/.capt/root/usr/local/sbin:${HOME}/.capt/root/usr/local/bin:${HOME}/.capt/root/usr/sbin:${HOME}/.capt/root/usr/bin:${HOME}/.capt/root/sbin:${HOME}/.capt/root/bin:${HOME}/.capt/root/usr/games:${HOME}/.capt/root/usr/local/games:${HOME}/.capt/snap/bin:$PATH

EOF

echo "Adding stuff to bashrc"
cat <<EOF >>${HOME}/.bashrc
export LD_LIBRARY_PATH=${HOME}/.capt/root/lib/x86_64-linux-gnu:${HOME}/.capt/root/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
export PATH=${HOME}/.capt:${HOME}/.capt/root/usr/local/sbin:${HOME}/.capt/root/usr/local/bin:${HOME}/.capt/root/usr/sbin:${HOME}/.capt/root/usr/bin:${HOME}/.capt/root/sbin:${HOME}/.capt/root/bin:${HOME}/.capt/root/usr/games:${HOME}/.capt/root/usr/local/games:${HOME}/.capt/snap/bin:$PATH

EOF

FISHRC=${HOME}/.config/fish/config.fish
if [ -f $FISHRC ]; then
	echo "Adding stuff to fishrc"
	cat <<EOF >>$FISHRC

# add capt to PATH

set -p LD_LIBRARY_PATH ${HOME}/.capt/root/lib/x86_64-linux-gnu:${HOME}/.capt/root/usr/lib/x86_64-linux-gnu
set -p PATH ${HOME}/.capt:${HOME}/.capt/root/bin:${HOME}/.capt/root/sbin:${HOME}/.capt/root/usr/bin:${HOME}/.capt/root/usr/sbin:${HOME}/.capt/root/usr/games:${HOME}/.capt/root/usr/local/bin:${HOME}/.capt/root/usr/local/sbin:${HOME}/.capt/root/usr/local/games:${HOME}/.capt/snap/bin
EOF
fi

echo "Done, please restart your shell or run \`source ${HOME}/.zshrc\` / \`source ${HOME}/.bashrc\` / \'source ${HOME}/.config/fish/config.fish\' (depending on your shell)"
