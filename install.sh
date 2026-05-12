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

echo "Select your browser:"
echo "1) Firefox"
echo "2) Brave"

read -p "Enter choice [1-2]: " browser_choice

case $browser_choice in
    1)
        BROWSER="firefox"
        ;;
    2)
        BROWSER="brave-browser"
        ;;
    *)
        echo "Invalid browser choice."
        exit 1
        ;;
esac

PACKAGES="fastfetch kitty topgrade $BROWSER"

case $choice in
    1)
        echo "Detected Fedora"
        sudo dnf update -y
        sudo dnf install -y $PACKAGES
        ;;
    
    2)
        echo "Detected Debian/Ubuntu"
        sudo apt update
        sudo apt install -y $PACKAGES
        ;;
    
    3)
        echo "Detected Arch Linux"
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm $PACKAGES
        ;;
    
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

echo "Installation complete!"
