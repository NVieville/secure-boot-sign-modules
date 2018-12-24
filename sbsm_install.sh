#!/bin/sh
#

# sbsm_install.sh - Install script for secure-boot-sign-modules.
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

VERSION="0.0.1"

# Check if root launch this script.
if [ "$(id -u)" -ne 0 ] ; then
    echo "$0 have to be run as root - aborting" >&2
    exit 1
fi

# Get and expand archive.
wget https://github.com/NVieville/secure-boot-sign-modules/archive/${VERSION}/secure-boot-sign-modules-${VERSION}.tar.gz
tar -xzvf secure-boot-sign-modules-${VERSION}.tar.gz

# Check needed directories.
if [ ! -d /usr/bin ] ; then
    mkdir -p -m 0555 /usr/bin
fi
if [ ! -d /etc/sbsm ] ; then
    mkdir -p -m 0755 /etc/sbsm
fi
if [ ! -d /etc/kernel/postinst.d ] ; then
    mkdir -p -m 0755 /etc/kernel/postinst.d
fi
if [ ! -d /etc/kernel/prerm.d ] ; then
    mkdir -p -m 0755 /etc/kernel/prerm.d
fi
if [ ! -d /usr/lib/systemd/system ] ; then
    mkdir -p -m 0755 /usr/lib/systemd/system
fi
if [ ! -d /usr/share/doc/sbsm ] ; then
    mkdir -p -m 0755 /usr/share/doc/sbsm
fi

# Fix uname path in sbsm_sign_modules.service file.
sed -i "s%/bin/uname%$(which uname)%g" secure-boot-sign-modules-${VERSION}/sbsm_sign_modules.service

# Copy needed files.
install -p -m 755 secure-boot-sign-modules-${VERSION}/sbsm_sign_modules /usr/bin/
install -p -m 755 secure-boot-sign-modules-${VERSION}/sbsm_remove_signed_modules /usr/bin/
install -p -m 755 secure-boot-sign-modules-${VERSION}/sbsm_build_modules_list /usr/bin/
install -p -m 644 secure-boot-sign-modules-${VERSION}/sbsm_sign_modules.service /usr/lib/systemd/system/
install -p -m 644 secure-boot-sign-modules-${VERSION}/sbsm_modules_list_to_sign.txt /etc/sbsm/
install -p -m 644 secure-boot-sign-modules-${VERSION}/sbsm_config /etc/sbsm/
install -p -m 644 secure-boot-sign-modules-${VERSION}/README /usr/share/doc/sbsm/
install -p -m 644 secure-boot-sign-modules-${VERSION}/README_fr /usr/share/doc/sbsm/

# Create links.
if [ -d /etc/kernel/postinst.d ] && [ -x /usr/bin/sbsm_sign_modules ] ; then
    ln -nsf /usr/bin/sbsm_sign_modules /etc/kernel/postinst.d/
fi
if [ -d /etc/kernel/prerm.d ] && [ -x /usr/bin/sbsm_remove_signed_modules ] ; then
    ln -nsf /usr/bin/sbsm_remove_signed_modules /etc/kernel/prerm.d/
fi

# Enable sbsm_sign_modules.service.
systemctl enable sbsm_sign_modules.service

# Build sbsm_modules_list_to_sign.txt file.
/usr/bin/sbsm_build_modules_list -y

# Cleanup.
rm -rf secure-boot-sign-modules-${VERSION}
rm -f secure-boot-sign-modules-${VERSION}.tar.gz
