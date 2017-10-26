#!/bin/bash

NEWNAME=$1

print_help(){
echo ""
echo "  mueve_y_renombra.sh"
echo ""
echo "     Mueve los certificados hacia ./selfsigned y los renombra con el nombre indicado."
echo ""
echo "          Sintaxis: "
echo ""
echo "               mueve_y_renombra.sh  <nuevo_nombre>"
echo ""
echo ""
echo "          Desarrollado por: Karl Monzon"
echo ""
echo ""

}

if [ "$#" -lt 1 ]; then
        print_help
        exit  0
fi

DESTDIR="./selfsigned"
mv ./server.crt         $DESTDIR/$NEWNAME.crt
mv ./server.csr         $DESTDIR/$NEWNAME.csr
mv ./server.key         $DESTDIR/$NEWNAME.key
mv ./server.key.secure  $DESTDIR/$NEWNAME.key.sec
mv ./server.pfx         $DESTDIR/$NEWNAME.pfx

chmod 400  $DESTDIR/$NEWNAME.*
chmod 444  $DESTDIR/$NEWNAME.crt

echo "fin.."
echo ""

