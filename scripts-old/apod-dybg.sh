#!/bin/bash

# VERSION: 20180913a
# Por boot1110001. Basado en un script de Josh Schreuder (2011)

# ********************************
# *** OPCIONES
# ********************************
# Escriba 'yes' para guardar una descripción (en ~/description.txt) 
# desde la página de APOD. Cualquier otra opción sera tomada como una 
# negación.
GET_DESCRIPTION="yes"
# Escriba la ruta del directorio donde se guardaran las imágenes
#~ PICTURES_DIR=~/Pictures
PICTURES_DIR="$HOME/.apod-dybg/bg-picture"
# Escriba la ruta del directorio donde se guardará la descripción
DESCRIPTION_DIR="$HOME/.apod-dybg/bg-description"
# Escriba 'Length' (Longitud) en el idioma de su PC
#~ $LENGTH=Length
LENGTH="Lonxitude"
# Dirección de la imagen por defecto
DEFAULT_IMG="$HOME/.apod-dybg/bg-default/bg-default-"$(( ( RANDOM % 3 )  + 1 ))".jpg"
# Dierección de la imagen de icono
ICON="$HOME/.icons/apod-dybg.png"

# ********************************
# *** FUNCIONES
# ********************************
function get_page {
    echo "Descargando la pagina para encontrar la imagen..."
    wget http://apod.nasa.gov/apod/ --quiet -O /tmp/apod.html
    grep -m 1 jpg /tmp/apod.html | sed -e 's/<//' -e 's/>//' -e 's/.*=//' -e 's/"//g' -e 's/^/http:\/\/apod.nasa.gov\/apod\//' > /tmp/pic_url
}

function save_description {
    if [ ${GET_DESCRIPTION} == "yes" ]; then
        echo "Obteniendo la descripcion de la imagen..."
        # Obtener descripción
        if [ -e $DESCRIPTION_DIR/description.txt ]; then
            rm $DESCRIPTION_DIR/description.txt
        fi

        if [ ! -e /tmp/apod.html ]; then
            get_page
        fi

        echo "Parseando la descripcion..."
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
    # Limpiar
    echo "Limpiando los archivos temporales..."
    if [ -e "/tmp/pic_url" ]; then
        rm /tmp/pic_url
    fi

    if [ -e "/tmp/apod.html" ]; then
        rm /tmp/apod.html
    fi
    
}

function check {
    # Comprobar si se ha descargado una imagen
    echo "Comprobando si la imagen descargada es correcta..."
	if [ ! -f "$PICTURES_DIR/"${TODAY}"_apod.jpg" ]; then
		echo "La imagen no se ha descargado, reemplazando por la imagen por defecto..."
		gsettings set org.gnome.desktop.background picture-uri "file://$DEFAULT_IMG"
		notify-send -i "$ICON" "Fallo en la descarga del fondo de pantalla APOD" "La imagen de hoy de la 'Astronomy Picture of the Day' no se ha podido descargar. Asignado el fondo por defecto."
	else
		echo "La imagen se ha descargado correctamente, finalizando..."
	fi
}

# ********************************
# *** INICIO
# ********************************
echo "============================="
echo "== Fondo de pantalla APOD  =="
echo "============================="
echo "       BY boot1110001        "
echo "============================="
echo "  Inspirado en un script de  "
echo "    Josh Schreuder (2011)    "
echo ""

# Asignar fecha
TODAY=$(date +'%Y%m%d')

echo  "La ruta del nuevo archivo a guardar es: $PICTURES_DIR/"${TODAY}"_apod.jpg"

# Si aún no tenemos la imagen hoy
if [ ! -e "$PICTURES_DIR/"${TODAY}"_apod.jpg" ]; then
    echo "La imagen no esta guradada, guradandola..."

    get_page

    # Obtenido el link de la imagen
    PICURL=`/bin/cat /tmp/pic_url`

    echo  "La URL de la imagen es: ${PICURL}" #<----------------- poner un if para comprobar que es una imagen

    echo  "Descargando imagen..."
    wget --quiet $PICURL -O $PICTURES_DIR/${TODAY}_apod.jpg

    echo "Asignando la imagen como fondo de escritorio..."
    #~ gconftool-2 -t string -s /desktop/gnome/background/picture_filename $PICTURES_DIR/${TODAY}_apod.jpg
    gsettings set org.gnome.desktop.background picture-uri "file://"$PICTURES_DIR/${TODAY}_apod.jpg

    save_description
    
    echo "Limpiando la imagen anterior..."
    # Borrando la imagen anterior (todo lo que no sea la imagen de hoy)
	rm $PICTURES_DIR/$(ls $PICTURES_DIR | grep -v ${TODAY}_apod.jpg)

# Si ya tenemos la imagen, comprobar que es la copia mas actualizada
else
    get_page

    # Obtenido el link de la imagen
    PICURL=`/bin/cat /tmp/pic_url`

    echo  "La URL de la imagen es: ${PICURL}"

    # Obteniendo el filesize (tamaño de la imagen)
    SITEFILESIZE=$(wget --spider $PICURL 2>&1 | grep $LENGTH | awk '{print $2}')
    FILEFILESIZE=$(stat -c %s $PICTURES_DIR/${TODAY}_apod.jpg)

    # Si la imagen ha sido actualizada
    echo "¿" "$SITEFILESIZE" "!=" "$FILEFILESIZE" "?"
    if [ "$SITEFILESIZE" != "$FILEFILESIZE" ]; then
        echo "La imagen ha sido actualizada, obteniendo la copia actualizada..."
        rm $PICTURES_DIR/${TODAY}_apod.jpg

        # Obtenido el link de la imagen
        PICURL=`/bin/cat /tmp/pic_url`

        echo  "Descargando la imagen..."
        wget --quiet $PICURL -O $PICTURES_DIR/${TODAY}_apod.jpg

        echo "Asignando la imagen como fondo de escritorio..."
        #gconftool-2 -t string -s /desktop/gnome/background/picture_filename $PICTURES_DIR/${TODAY}_apod.jpg
        gsettings set org.gnome.desktop.background picture-uri "file://"$PICTURES_DIR/${TODAY}_apod.jpg

        save_description

    # Si la imagen es la misma
    else
        echo "La imagen es la misma, acabado."
    fi
fi

clean_up
check
