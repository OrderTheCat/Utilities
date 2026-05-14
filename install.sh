# Source

DIR1=~/Utilities/topgrade.toml

# Destination

DEST1=~/.config

# Move

mv "$DIR1" "$DEST1"

echo "Setup of system utilities done!"

#!/bin/bash

# Figure out which distribution the user is on.

echo "Select your Linux distribution:"
echo "1) Fedora"
echo "2) Debian/Ubuntu"
echo "3) Arch Linux"

read -p "Enter choice [1-3]: " choice

echo "Select your Discord client:"
echo "1) Discord"
echo "2) Vesktop"

read -p "Enter choice [1-2]: " discord_choice

case $discord_choice in
    1)
        DISCORD_FLATPAK="com.discordapp.Discord"
        ;;
    2)
        DISCORD_FLATPAK="com.vesktop.Vesktop"
        ;;
    *)
        echo "Wrong choice. Please run the script again and select a valid option."
        exit 1
        ;;
esac

PACKAGES="fastfetch kitty topgrade"

case $choice in
    1)
        echo "Detected Fedora"
        sudo dnf update -y
        sudo dnf install -y flatpak $PACKAGES
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        sudo flatpak install flathub $DISCORD_FLATPAK -y
        ;;
    
    2)
        echo "Detected Debian/Ubuntu"
        sudo apt update
        sudo apt install -y flatpak $PACKAGES
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        sudo flatpak install flathub $DISCORD_FLATPAK -y
        ;;
    
    3)
        echo "Detected Arch Linux"
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm flatpak $PACKAGES
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        sudo flatpak install flathub $DISCORD_FLATPAK -y
        ;;
    
    *)
        echo "Wrong choice. Please run the script again and select a valid option."
        exit 1
        ;;
esac

echo "Setup is done!"
