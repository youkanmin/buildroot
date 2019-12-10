#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

cp board/raspberrypi4/S99modules ${TARGET_DIR}/etc/init.d/S99modules
chmod 755 ${TARGET_DIR}/etc/init.d/S99modules

if [ -e ${TARGET_DIR}/etc/ssh/sshd_config ]; then
	sed  -i 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/' ${TARGET_DIR}/etc/ssh/sshd_config
	sed  -i 's/\#PermitEmptyPasswords no/PermitEmptyPasswords yes/' ${TARGET_DIR}/etc/ssh/sshd_config
fi
