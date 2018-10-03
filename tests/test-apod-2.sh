#!/bin/bash
# (c) inoro [20160730001]
# [SHORT_NAME - Full_Name]

function get_page1 {
    echo "# Descargando la pagina para encontrar la imagen... 1"
     wget http://apod.nasa.gov/apod/ --quiet -O /tmp/apod.html
    
    echo ""
    grep -m 1 jpg /tmp/apod.html
    echo ""
    
    grep -m 1 jpg /tmp/apod.html | sed -e 's/<//' -e 's/>//' -e 's/.*=//' -e 's/"//g' -e 's/^/http:\/\/apod.nasa.gov\/apod\//' > /tmp/pic_url1
}

function get_page2 {
    echo "# Descargando la pagina para encontrar la imagen... 2"
    wget http://www.aapodx2.com/ --quiet -O /tmp/apod.html
    
    echo ""
    grep -m 2 jpg /tmp/apod.html
    echo ""
    
    grep -m 2 jpg /tmp/apod.html | sed -n '1!p' | sed -e 's/.*src="//' -e 's/alt=//' -e 's/"//g' -e 's/^/http:\/\/www.aapodx2.com/' > /tmp/pic_url2
    
    #MAL, PORQUE CAPTURAMOS LA IMAGEN PEQUEÑA (la: XXXXXp.jpg)
}

function get_page3 {
    echo "# Descargando la pagina para encontrar la imagen... 3"
    wget http://www.aapodx2.com/ --quiet -O /tmp/apod.html
    
    echo ""
    grep -m 2 jpg /tmp/apod.html
    echo ""
    
    # sed -n '1!p' --> IGNORAMOS LA PRIMERA LINEA DEL RESULTDO DEL GREP (-m 2)
    grep -m 2 jpg /tmp/apod.html | sed -n '1!p' | sed -e 's/.*href="//' -e 's/><img.*//' -e 's/"//g' -e 's/^/http:\/\/www.aapodx2.com/' > /tmp/pic_url3
    
    #BIEN, CAPTURAMOS LA IMAGEN GRANDE GRANDE
}

get_page1
get_page2
get_page3
# Obtenido el link de la imagen
PICURL1=`/bin/cat /tmp/pic_url1`
PICURL2=`/bin/cat /tmp/pic_url2`
PICURL3=`/bin/cat /tmp/pic_url3`
echo "# RESULT1: $PICURL1"
echo "# RESULT2: $PICURL2"
echo "# RESULT3: $PICURL3"
exit
