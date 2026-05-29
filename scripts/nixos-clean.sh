#!/bin/bash

# Script for cleaning Arch Linux System
# -------------------------------------
#
# @author: Eloy García Almadén
# @email: eloy.garcia.pca@gmail.com
# -------------------------------------

# Cleaning journal logs. Only the last two days logs will remain
echo "Cleaning journal logs. Only the last two days logs will remain"
sudo journalctl --vacuum-time=2d

# Cleaning pacman cache. Only one recent version of the installed packages will remain
echo "Cleaning pacman cache. Only one recent version of the installed packages will remain"
sudo paccache -rk 1

# Cleaning all cached versions of uninstalled packages
echo "Cleaning all cached versions of uninstalled packages"
sudo paccache -ruk0

# Cleaning orphan packages
echo "Cleaning orphan packages"
sudo pacman -Rns $(pacman -Qtdq)

# Cleaning yay cache
yay -Sc --aur

# Cleaning all snap packages cached
sudo rm -rf /var/lib/snapd/cache/*
