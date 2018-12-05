#!/bin/bash
# VERSION: 20181205a
# By boot1110001. Based on the script of Josh Schreuder (2011)


# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 	OPTIONS & VARIABLES
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Write 'yes' for save a description (in ~/description.txt) 
# from the APOD webpage. Any other option will be taken as a denial.
GET_DESCRIPTION="yes"

# Write the path to the directory where the images will be saved.
#~ PICTURES_DIR="$HOME/.apod-dybg/bg-picture"
PICTURES_DIR="$HOME/.apod-dybg/bg-picture"

# Enter the path to the directory where the replacement images will be saved.
#~ PICTURES_DIR2="$HOME/.apod-dybg/bg-picture2"
PICTURES_DIR2="$HOME/.apod-dybg/bg-picture2"

# Enter the directory path where the description will be saved.
#~ DESCRIPTION_DIR="$HOME/.apod-dybg/bg-description"
DESCRIPTION_DIR="$HOME/.apod-dybg/bg-description"

# Enter 'Length' in the language of your PC bash shell.
#~ LENGTH="Length"
LENGTH="Longitud"
#~ LENGTH="Lonxitude"

# Address of the default image.
#~ DEFAULT_IMG="$HOME/.apod-dybg/bg-default/bg-default-"$(( ( RANDOM % 3 )  + 1 ))".jpg"
DEFAULT_IMG="$HOME/.apod-dybg/bg-default/bg-default-"$(( ( RANDOM % 3 )  + 1 ))".jpg"

# Address of the icon image.
#~ ICON="$HOME/.icons/apod-dybg.png"
ICON="$HOME/.icons/apod-dybg.png"

# Assigning date.
TODAY=$(date +'%Y%m%d')


# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 	FUNCTIONS
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
function intro {
	echo " ==========================="
	echo " ==    Wallpaper APOD     =="
	echo " ==========================="
	echo "       by boot1110001       "
	echo " ==========================="
	echo "   Inspired by a script of  "
	echo "    Josh Schreuder (2011)   "
	echo " ==========================="
	echo "  GIT https://goo.gl/yPSXjL "
	echo ""
}

function get_page {
    echo "Downloading the page to find the image..."
    wget http://apod.nasa.gov/apod/ --quiet -O /tmp/apod.html
    grep -m 1 jpg /tmp/apod.html | sed -e 's/<//' -e 's/>//' -e 's/.*=//' -e 's/"//g' -e 's/^/http:\/\/apod.nasa.gov\/apod\//' > /tmp/pic_url
}

function image_as_bg {
	echo "Downloading image ..."
	wget --quiet $PICURL -O $PICTURES_DIR/${TODAY}_apod.jpg

	echo "Assigning the image as a desktop background..."
	gsettings set org.gnome.desktop.background picture-uri "file://"$PICTURES_DIR/${TODAY}_apod.jpg

	save_description
}

function get_page2 {
    echo "Downloading the page 2 to find the image..."
    wget http://www.aapodx2.com/ --quiet -O /tmp/apod.html
    grep -m 2 jpg /tmp/apod.html | sed -n '1!p' | sed -e 's/.*href="//' -e 's/><img.*//' -e 's/"//g' -e 's/^/http:\/\/www.aapodx2.com/' > /tmp/pic_url2
}

function image2_as_bg {
	get_page2
	
	# Getting the link of the image2.
	PICURL2=`/bin/cat /tmp/pic_url2`
	
	echo "Downloading image2..."
	wget --quiet $PICURL2 -O $PICTURES_DIR2/${TODAY}_apod2.jpg

	echo "Assigning the image2 as a desktop background..."
	gsettings set org.gnome.desktop.background picture-uri "file://"$PICTURES_DIR2/${TODAY}_apod2.jpg
	
	echo "Cleaning the previous image2..."
	# Deleting the previous image2 (everything that is not today's image2)
	rm $PICTURES_DIR2/$(ls $PICTURES_DIR2 | grep -v ${TODAY}_apod2.jpg)
}

function save_description {
    if [ ${GET_DESCRIPTION} == "yes" ]; then
        echo "Getting the description of the image..."
        # Get description.
        if [ -e $DESCRIPTION_DIR/description.txt ]; then
            rm $DESCRIPTION_DIR/description.txt
        fi

        if [ ! -e /tmp/apod.html ]; then
            get_page
        fi

        echo "Parsing the description..."
        sed -n '/<b> Explanation: <\/b>/,/<p> <center>/p' /tmp/apod.html |
        sed -e :a -e 's/<[^>]*>//g;/</N;//ba' |
        grep -Ev 'Explanation:' |
        tr '\n' ' ' |
        sed 's/  /\n\n/g' |
        awk 'NF { print $0 "\n" }' |
        sed 's/^[ \t]*//' |
        sed 's/[ \t]*$//' > $DESCRIPTION_DIR/description.txt
    fi
}

function clean_up {
    # Clean.
    echo "Cleaning temporary files:"
    if [ -e "/tmp/pic_url" ]; then
		echo " Erasing /tmp/pic_url..."
        rm /tmp/pic_url
    fi
    
    if [ -e "/tmp/pic_url2" ]; then
		echo " Erasing /tmp/pic_url2..."
        rm /tmp/pic_url2
    fi

    if [ -e "/tmp/apod.html" ]; then
		echo " Erasing /tmp/apod.html..."
        rm /tmp/apod.html
    fi
}

function check {
    # Check if the image has been downloaded.
    echo "Checking if the downloaded image is correct..."
	if [ ! -f "$PICTURES_DIR/"${TODAY}"_apod.jpg" ]; then
		echo "The image has not been downloaded, replacing it with the default image..."
		echo "Default image: $DEFAULT_IMG"
		
		gsettings set org.gnome.desktop.background picture-uri "file://$DEFAULT_IMG"
		notify-send -i "$ICON" "Fallo en la descarga del fondo de pantalla APOD" "La imagen de hoy de la 'Astronomy Picture of the Day' no se ha podido descargar. Asignado el fondo por defecto."
		#~ notify-send -i "$ICON" "Failure to download the APOD wallpaper" "Today's image of the 'Astronomy Picture of the Day' could not be downloaded. Assigned the background by default."
	else
		echo "The image has been downloaded correctly, ending..."
	fi
}


# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 	START
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
intro

echo "The path of the new file to save is: $PICTURES_DIR/"${TODAY}"_apod.jpg"

get_page

# Getting the link of the image.
PICURL=`/bin/cat /tmp/pic_url`

#~ For tests.
#~ PICURL="http://apod.nasa.gov/apod/image/1812/RocketLaunch_Jiang_960.jpg" # Good
PICURL="http://apod.nasa.gov/apod/image/1812/RocketLaunch_Jiang_960.jpgg" # Bad

echo "The URL of the image is: ${PICURL}"

echo "Is the image URL really an image?"
if [[ "$PICURL" =~ ^(http:\/\/apod.nasa.gov\/.*)(\.jpg|\.png)$ ]]; then
	echo "Yes! It's an image."
	
	# If we do not have today's image yet.
	if [ ! -e "$PICTURES_DIR/"${TODAY}"_apod.jpg" ]; then
		echo "The image is not saved, saving it..."
		image_as_bg
		echo "Cleaning the previous image..."
		# Deleting the previous image (everything that is not today's image)
		rm $PICTURES_DIR/$(ls $PICTURES_DIR | grep -v ${TODAY}_apod.jpg)
	else
	# If we already have the image, check that it is the most updated copy.

		echo "We already have an image, checking that it is the most updated copy..."

		# Getting the filesize (image size).
		SITEFILESIZE=$(wget --spider $PICURL 2>&1 | grep $LENGTH | awk '{print $2}')
		FILEFILESIZE=$(stat -c %s $PICTURES_DIR/${TODAY}_apod.jpg)

		# If the image has not been updated (the sizes don't match).
		echo "Do the sizes of the web image and the downloaded image match?"
		echo " ¿" "$SITEFILESIZE" "==" "$FILEFILESIZE" "?"
		
		if [ "$SITEFILESIZE" != "$FILEFILESIZE" ]; then
			echo "The image has not been updated (the sizes don't match), obtaining the updated copy..."
			rm $PICTURES_DIR/${TODAY}_apod.jpg
			image_as_bg
		else
		# If the image has been updated (the sizes match).
			echo "The image has already been updated (the sizes match), finishing."
			
			echo "Reassigning the image as a desktop background..." # NECESARY
			gsettings set org.gnome.desktop.background picture-uri "file://"$PICTURES_DIR/${TODAY}_apod.jpg
		fi
	fi
	
	clean_up
	check
	
else 
	echo "No, it's not an image (the URL does not have a correct format) :(" 
	echo "The URL is not a downloadable image, replacing it with the image2..."
	image2_as_bg
	#~ echo "The URL is not a downloadable image, replacing it with the default image..."
	#~ echo "Default image: $DEFAULT_IMG"
	#~ gsettings set org.gnome.desktop.background picture-uri "file://$DEFAULT_IMG"
	notify-send -i "$ICON" "Fallo en la descarga del fondo de pantalla APOD" "La imagen de hoy de la 'Astronomy Picture of the Day' no se ha podido descargar. Asignado el fondo por defecto."
	clean_up
fi

echo "Ending..."
exit
