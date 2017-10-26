#!/usr/bin/perl

print "Programa para Convertir las minusculas a MAYUSCULAS\n";
print "Ingrese Texto: ";
$texto=<stdin>;
chop($texto);
$textoconvertido= uc($texto);
print "Texto Convertido a Mayusculas: ", $textoconvertido,"\n";


