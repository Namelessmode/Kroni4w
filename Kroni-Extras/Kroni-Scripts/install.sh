set -e

# AUR Helper
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

#Install AUR Packages
yay -Syu --needed - < pkgs.sh
yay -S --needed - < thinkpad-440.sh


