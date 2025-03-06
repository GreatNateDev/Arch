#!/bin/bash
sudo pacman -S wl-clipboard git base-devel fzf npm go --noconfirm
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
cd ..
rm -rf yay-bin
yay -S librewolf-bin --noconfirm
yay -S github-desktop-bin --noconfirm
yay -S  ttf-firacode-nerd --noconfirm
sudo cp -R config/* ~/.config/
sudo pacman -R ark --noconfirm
sudo cp -R etc/* /etc/
cd /usr/share/applications
sudo rm avahi-discover.desktop assistant.desktop bssh.desktop bvnc.desktop designer.desktop google-maps-geo-handler.desktop
sudo rm vim.desktop vlc.desktop qv4l2.desktop qvidcap.desktop org.kde.plasma-welcome.desktop
sudo rm qdbusviewer.desktop org.kde.kwrite.desktop org.kde.kate.desktop linguist.desktop htop.desktop
sudo rm lstopo.desktop org.kde.plasma-systemmonitor.desktop org.kde.kinfocenter.desktop org.kde.konsole.desktop org.kde.drkonqi.coredump.gui.desktop org.kde.drkonqi.desktop org.kde.discover.desktop org.kde.kuserfeedback-console.desktop
echo Yay now just install a theme and you are ready to go!
