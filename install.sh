#!/bin/sh -e
cd /var/db/kiss
git clone https://github.com/kisslinux/repo
cd /var/db/kiss/repo
git clone https://github.com/kisslinux/community
cat > ~/.profile << 'EOF'
export KISS_PATH=''
KISS_PATH=$KISS_PATH:/var/db/kiss/repo/core
KISS_PATH=$KISS_PATH:/var/db/kiss/repo/extra
KISS_PATH=$KISS_PATH:/var/db/kiss/repo/xorg
KISS_PATH=$KISS_PATH:/var/db/kiss/repo/community/community
EOF
. ~/.profile
kiss b gnupg1
kiss i gnupg1
gpg --keyserver keys.gnupg.net --recv-key 46D62DD9F1DE636E
echo trusted-key 0x46d62dd9f1de636e >>/root/.gnupg/gpg.conf
git config merge.verifySignatures true
export CFLAGS="-O3 -pipe -march=native"
export CXXFLAGS="$CFLAGS"
export MAKEFLAGS="-j12"
kiss b sudo
kiss i sudo
kiss update
kiss update
cd /var/db/kiss/installed && kiss build *
kiss b util-linux
kiss i util-linux
kiss b eudev
kiss i eudev
passwd
adduser jasmine
kiss b xorg-server xinit xf86-input-libinput
kiss b liberation-fonts
kiss i liberation-fonts
addgroup jasmine video
addgroup jasmine audio
addgroup jasmine wheel
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+ALL\)/\1/' /etc/sudoers
mv /root/.profile /home/jasmine/.profile
