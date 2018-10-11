#!/bin/bash
# (c) inoro [20181011a]
# [componente-verificador-de-url]

function get_page {
    echo "Descargando la pagina para encontrar la imagen..."
    wget http://apod.nasa.gov/apod/ --quiet -O /tmp/apod.html
    grep -m 1 jpg /tmp/apod.html | sed -e 's/<//' -e 's/>//' -e 's/.*=//' -e 's/"//g' -e 's/^/http:\/\/apod.nasa.gov\/apod\//' > /tmp/pic_url
}

echo "### componente-verificador-de-url ###"

#get_page

# Obtenido el link de la imagen
#PICURL=`/bin/cat /tmp/pic_url`
PICURL='http://apod.nasa.gov/apod/image/1810/DSC_4229-Edit-2Falcon9Kraus2048.jpg'
PICURL='http://apod.nasa.gov/apod/image/1810/DSC_4229-Edit-2Falcon9Kraus2048.png'

echo  "La URL de la imagen es: $PICURL"

#if [[ "$PICURL" =~ ^(.*)(\.[a-z]{1,5})$ ]]; 
if [[ "$PICURL" =~ ^(http:\/\/apod.nasa.gov\/.*)(\.jpg|\.png)$ ]]; 
	then 
		echo "YES!!";
	else 
		echo "Not proper format :("; 
fi
