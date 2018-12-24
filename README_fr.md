# Secure-Boot-Sign-Modules

Scripts shell, fichiers systemd, de configuration et de documentation pour signer les modules du noyau GNU/Linux avec Secure Boot.

Ce dépôt contient tous les fichiers nécessaires à signer les modules du noyau GNU/Linux non-signés par défaut par certaines distributions (pilotes tiers ou paquetages spéciaux). Il est configuré par défaut pour la distribution Ubuntu, mais peut être facilement configuré pour d'autres distributions.
Pour cela, voir le fichier auto-documenté `sbsm_config` (situé ici `/etc/sbsm/sbsm_config` si installé).
Voir également les fichiers `README*` pour le mode d'emploi de ces fichiers et comment les ajuster.
### Installation
Le fichier `sbsm_install.sh` est fourni pour faciliter l'installation. Il est possible de le récupérer et de l'exécuter avec les commandes suivantes lancées dans un terminal sous root:
```
wget https://github.com/NVieville/secure-boot-sign-modules/raw/master/sbsm_install.sh

# Rendre le fichier exécutable :

chmod +x sbsm_install.sh

# L'examiner et le lancer :

./sbsm_install.sh
```

Après analyse des fichiers fournis dans ce dépôt, et si vous leurs faites confiance, il est aussi possible d'utiliser la commande en une seule ligne ci-dessous pour récupérer et exécuter le script d'installation :
```
wget -q -O - https://github.com/NVieville/secure-boot-sign-modules/raw/master/sbsm_install.sh | sh
```
Une fois installés, vérifier les fichiers de configuration `/etc/sbsm/sbsm_modules_list_to_sign.txt` et `/etc/sbsm/sbsm_config` pour voir s'ils correspondent à vos besoins. Si nécessaire, référez-vous aux fichiers `README*` pour les modifier.
### Désinstallation
Il est également possible de désinstaller ces fichiers avec l'aide du script shell `sbsm_uninstall.sh`.
```
wget https://github.com/NVieville/secure-boot-sign-modules/raw/master/sbsm_uninstall.sh

# Le rendre exécutable :

chmod +x sbsm_uninstall.sh

# L'examiner et le lancer :

./sbsm_uninstall.sh
```
Comme pour l'installation, il est possible de désinstaller ces fichiers en utilisant la commande en une seule ligne ci-dessous :
```
wget -q -O - https://github.com/NVieville/secure-boot-sign-modules/raw/master/sbsm_uninstall.sh | sh
```
##### Notes:
Tous les fichiers de ce dépôt sont fournis tels quels, et seul un support limité sera disponible.
