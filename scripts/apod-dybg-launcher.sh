#!/bin/bash
VERSION="20180916a"
# (c) inoro [20180916a]
echo "@ (c) inoro [$VERSION]"
# [apod-dybg-launcher - Launcher of apod-dybg*]
echo "@ [apod-dybg-launcher - Launcher of apod-dybg*]"
# *apod-dybg - Astronomy Picture of the Day Dynamic Background
echo "@ *apod-dybg - Astronomy Picture of the Day Dynamic Background"
echo ""

# Printing the current date in the log
echo "@ Printing the current date in the log"
echo "last-run: "`date '+%Y-%m-%d %H:%M:%S'` > "$HOME/.apod-dybg/last-run-log.txt"
echo '------------------------------------------------------------------------' >> "$HOME/.apod-dybg/last-run-log.txt"
# Launching the apod-dybg with parameters
echo "@ Launching the apod-dybg with parameters"
"$HOME/.apod-dybg/apod-dybg.sh" >> "$HOME/.apod-dybg/last-run-log.txt"
# Exiting luncher
echo "@ Exiting launcher"
exit
