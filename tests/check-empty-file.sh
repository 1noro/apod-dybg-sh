#!/bin/bash
# (c) inoro [20181206a]
# [check empty file]

#~ /home/cosmo/.apod-dybg/bg-picture/20181206_apod.jpg
TODAY=$(date +'%Y%m%d')

echo "apod ("${HOME}"/.apod-dybg/bg-picture/"${TODAY}"_apod.jpg):"
if [ -s "$HOME""/.apod-dybg/bg-picture/"${TODAY}"_apod.jpg" ]; then   
        echo "FULL!!"
else
        echo "EMPTY!!"
fi

echo "apod ("${HOME}"/.apod-dybg/bg-picture2/"${TODAY}"_apod2.jpg):"
if [ -s ${HOME}"/.apod-dybg/bg-picture2/"${TODAY}"_apod2.jpg" ]; then   
        echo "FULL!!"
else
        echo "EMPTY!!"
fi
