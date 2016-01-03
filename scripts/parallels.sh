#!/usr/bin/env bash

echo '==> Include parallels tools'
/usr/bin/install --mode=0755 parallels_tools.sh "${TARGET_DIR}/parallels_tools.sh"

echo '==> installation complete!'
/usr/bin/sleep 3
/usr/bin/umount ${TARGET_DIR}
/usr/bin/systemctl poweroff
