# Secure-Boot-Sign-Modules

Shell scripts, systemd, configuration and documentation files to sign GNU/Linux kernel modules with Secure Boot.

This repository contains all the files needed to sign GNU/Linux kernel modules not signed by default by distributions (third party drivers or special packages). It is configured by default to work with Ubuntu distribution, but can be easily configured to work with other distributions.
For this, see the auto-documented file `sbsm_config` (found here `/etc/sbsm/sbsm_config` if installed).
See also `README*` files to kown how to use these files or to tweak them.
### Installation
The `sbsm_install.sh` file is provided to help installation. It's possible to get it and execute it with the following commands in a root terminal:
```
wget https://github.com/NVieville/secure-boot-sign-modules/raw/master/sbsm_install.sh

# Make it executable:

chmod +x sbsm_install.sh

# Review it and launch it:

./sbsm_install.sh
```

After reviewing the files provided in this repository, and if you trust them, it's also possible to use the "oneliner" below to get and execute the installation script:
```
wget -q -O - https://github.com/NVieville/secure-boot-sign-modules/raw/master/sbsm_install.sh | sh
```
Once installed, check the configuration files `/etc/sbsm/sbsm_modules_list_to_sign.txt` and `/etc/sbsm/sbsm_config` to see if they fit your needs. If needed refer to the `README*` files to modify them.
### Uninstall
It is also possible to uninstall these files with the help of the `sbsm_uninstall.sh` shell script.
```
wget https://github.com/NVieville/secure-boot-sign-modules/raw/master/sbsm_uninstall.sh

# Make it executable:

chmod +x sbsm_uninstall.sh

# Review it and launch it:

./sbsm_uninstall.sh
```
Same as for installation, it is possible to uninstall these files using this "oneliner":
```
wget -q -O - https://github.com/NVieville/secure-boot-sign-modules/raw/master/sbsm_uninstall.sh | sh
```
##### Notes:
All the files provided in this repository are made available as is, and only limited support will be available.
