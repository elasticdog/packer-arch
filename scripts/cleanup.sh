#!/usr/bin/bash -x

# Clean the pacman cache.
/usr/bin/yes | /usr/bin/pacman -Scc
/usr/bin/pacman-optimize

# Write zeros to improve virtual disk compaction.
zerofile=$(/usr/bin/mktemp /zerofile.XXXXX)
/usr/bin/dd if=/dev/zero of="$zerofile" bs=1M
/usr/bin/rm -f "$zerofile"
/usr/bin/sync
