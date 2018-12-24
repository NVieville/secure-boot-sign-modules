#!/bin/sh
#

# sbsm_uninstall.sh - Uninstall script for secure-boot-sign-modules.
#
# Copyright (c) 2018-2019 Nicolas Viéville <nicolas.vieville@uphf.fr>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Check if root launch this script.
if [ "$(id -u)" -ne 0 ] ; then
    echo "$0 have to be run as root - aborting" >&2
    exit 1
fi

SBSM_SUSPECT_MODULES=""
SBSM_LINKS_TO_REMOVE="/etc/kernel/postinst.d/sbsm_sign_modules \
/etc/kernel/prerm.d/sbsm_remove_signed_modules \
"
SBSM_FILES_TO_REMOVE="/usr/bin/sbsm_sign_modules \
/usr/bin/sbsm_remove_signed_modules \
/usr/bin/sbsm_build_modules_list \
/etc/sbsm/sbsm_modules_list_to_sign.txt \
/etc/sbsm/sbsm_config \
/usr/share/doc/sbsm/README \
/usr/share/doc/sbsm/README_fr \
"
SBSM_DIRS_TO_REMOVE="/etc/sbsm \
/usr/share/doc/sbsm \
/etc/kernel/postinst.d \
/etc/kernel/prerm.d \
"

/usr/bin/sbsm_remove_signed_modules
for MODULE_FOUND in $(find /lib/modules/ -name "*.sbsm_unsigned" -print)
do {
    SBSM_SUSPECT_MODULES="${MODULE_FOUND} ${SBSM_SUSPECT_MODULES}"
} ; done
SBSM_SUSPECT_MODULES=$(echo "${SBSM_SUSPECT_MODULES}" | sed -e 's% *$%%g' -e 's%^ *%%g' -e 's%  *% %g')

if [ -e /usr/lib/systemd/system/sbsm_sign_modules.service ] ; then
    systemctl stop sbsm_sign_modules.service
    systemctl disable sbsm_sign_modules.service
    rm -f /usr/lib/systemd/system/sbsm_sign_modules.service
fi

for ONE_LINK in ${SBSM_LINKS_TO_REMOVE}
do {
    if [ -e "${ONE_LINK}" ] ; then
        rm -f "${ONE_LINK}"
    fi
} ; done

for ONE_FILE in ${SBSM_FILES_TO_REMOVE}
do {
    if [ -e "${ONE_FILE}" ] ; then
        rm -f "${ONE_FILE}"
    fi
} ; done

for ONE_DIR in ${SBSM_DIRS_TO_REMOVE}
do {
    if [ -d "${ONE_DIR}" ] ; then
        if [ -z "$(ls -A ${ONE_DIR})" ]; then
            rm -rf "${ONE_DIR}"
        else
            echo "${ONE_DIR} is not empty - not removing it"
        fi
    fi
} ; done

echo "Done: sbsm removed from your system. Reboot needed."
if [ "x${SBSM_SUSPECT_MODULES}" != "x" ] ; then
    echo "Some suspect modules files were found, maybe they should be removed manually:"
    for ONE_MODULE in $(echo ${SBSM_SUSPECT_MODULES})
    do {
        echo "${ONE_MODULE}"
    } ; done
fi

exit 0
