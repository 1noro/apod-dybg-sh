#!/bin/bash
# Package required to improve the experience (notify-osd)
VERSION="20181205a"
# (c) boot1110001 [20181205a]
echo "# (c) boot1110001 [$VERSION]"
# [install-or-update - Install or Update apod-dybg*]
echo "# [install-or-update - Install or Update apod-dybg*]"
# *apod-dybg - Astronomy Picture of the Day Dynamic Background
echo "# *apod-dybg - Astronomy Picture of the Day Dynamic Background"
echo ""

### Creating the folder structure
echo "### Creating the folder structure"
# Creating the folder for the program (if it does not already exist)
echo "# Creating the folders for the program (if it does not already exist)"
mkdir -p ~/.apod-dybg
echo "+ $HOME/.apod-dybg"
mkdir -p ~/.apod-dybg/icons
echo "+ $HOME/.apod-dybg/icons"
mkdir -p ~/.apod-dybg/bg-default
echo "+ $HOME/.apod-dybg/bg-default"
mkdir -p ~/.apod-dybg/bg-picture
echo "+ $HOME/.apod-dybg/bg-picture"
mkdir -p ~/.apod-dybg/bg-picture2
echo "+ $HOME/.apod-dybg/bg-picture2"
mkdir -p ~/.apod-dybg/bg-description
echo "+ $HOME/.apod-dybg/bg-description"
# Creating the folder for the .desktop file (if it does not already exist)
echo "# Creating the folder for the .desktop file (if it does not already exist)"
mkdir -p ~/.local/share/applications
echo "+ $HOME/.local/share/applications"
# Creating the folder for the autostar .desktop file (if it does not already exist)
echo "# Creating the folder for the autostar .desktop file (if it does not already exist)"
mkdir -p ~/.config/autostart
echo "+ $HOME/.config/autostart"
# Creating the folder for the app icon (if it does not already exist)
echo "# Creating the folder for the app icon (if it does not already exist)"
mkdir -p ~/.icons
echo "+ $HOME/.icons"
echo ""

### Copying files
echo "### Copying files"
# Copying the main script
echo "# Copying the main script"
cp scripts/apod-dybg.sh ~/.apod-dybg/apod-dybg.sh
# Changing script permissions
echo "# Changing script permissions"
chmod +x ~/.apod-dybg/apod-dybg.sh
# Copying the launcher script
echo "# Copying the launcher script"
cp scripts/apod-dybg-launcher.sh ~/.apod-dybg/apod-dybg-launcher.sh
# Changing launcher script permissions
echo "# Changing launcher script permissions"
chmod +x ~/.apod-dybg/apod-dybg-launcher.sh
# Copying all the default backgrounds
echo "# Copying all the default backgrounds"
cp -R bg-default/* ~/.apod-dybg/bg-default/
# Copying all the icons
echo "# Copying all the icons"
cp -R icons/* ~/.apod-dybg/icons/
# Copying the selected icon to the corresponding folder
echo "# Copying the selected icon to the corresponding folder"
cp icons/256x256/apod-dybg.png ~/.icons/apod-dybg.png
echo ""

### Creating the script Gnome shell launcher (.desktop)
echo "### Creating the script Gnome Shell launcher (.desktop)"
echo "[Desktop Entry]" > apod-dybg.desktop
echo "Type=Application" >> apod-dybg.desktop
echo "Version=$VERSION" >> apod-dybg.desktop
echo "Name=apod-dybg" >> apod-dybg.desktop
echo "Comment=Astronomy Picture of the Day Dynamic Background" >> apod-dybg.desktop
echo "Path=$HOME/.apod-dybg" >> apod-dybg.desktop
echo "Exec=$HOME/.apod-dybg/apod-dybg-launcher.sh" >> apod-dybg.desktop
echo "Icon=apod-dybg" >> apod-dybg.desktop
echo "Terminal=false" >> apod-dybg.desktop
#~ echo "Name[gl_ES]=apod-dybg" >> apod-dybg.desktop
echo "# Result:"
echo "#----------------------------------------------------------------"
cat apod-dybg.desktop
echo "#----------------------------------------------------------------"
# Copying the apod-dybg.desktop to the ~/.local/share/applications folder
echo "# Copying the apod-dybg.desktop to the ~/.local/share/applications folder"
cp apod-dybg.desktop ~/.local/share/applications/apod-dybg.desktop
# Moving the apod-dybg.desktop to the ~/.config/autostart folder
echo "# Moving the apod-dybg.desktop to the ~/.config/autostart folder"
mv apod-dybg.desktop ~/.config/autostart
echo ""
echo "### FINALIZED"

















