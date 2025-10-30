set -e

# AUR Helper
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

#Install AUR Packages
yay -Syu --needed - < ~/Kroni4w/Kroni-Extras/Kroni-Scripts/pkgs.sh
mv ~/Kroni4w/Kroni-Extras/* ~/
mv ~/Kroni4w/* ~/.config/
~/Kroni-Scripts/services.sh


