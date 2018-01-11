#!/bin/bash

SERVICIO=$1
CANTIDAD=$2

print_help(){
echo ""
echo "  genera_trafico.sh  version 1.0 "
echo ""
echo "     Genera Trafico para validar que los servicios se encuentran activos. "
echo ""
echo "     Sintaxis: "
echo ""
echo "         ./genera_trafico.sh <Servicio a Validar> <##> "
echo ""
echo "          <Servicio a Validar>: Servicio que se desea Validar. "
echo "          <##>: Numero de intentos de conexion para validar. "
echo ""
echo "		Ejemplo:    ./genera_trafico.sh sat 5"
echo ""
echo "          Los Servicios Validos son : "
echo "                   sat "
echo "                   bts "
echo "                   bts-sql "
echo "                   dolex "
echo "                   unitelyego "
echo "                   mipueblo "
echo "                   moneygram "
echo "                   telgua "
echo "                   agexport "
echo "                   pida "
echo "                   maycom "
echo "                   renap "
echo "                   renap-ws "
echo "                   sascim "
echo "                   eegsa "
echo "                   sib "
echo "                   migracion "
echo "                   viamericas "
echo "                   siafsag "
echo "                   oj "
echo "                   5b "
echo "                   yego "
echo "                   regmercantil "
echo "                   pingregmercantil "
echo ""
echo "          Desarrollado por:   Telecomunicaciones "

}

if [ "$#" -lt 2 ]; then
        print_help
        exit  0
fi

if [ "$#" -eq 2 ]; then
	VALIDO="0";
    if [ "$SERVICIO" = "sat" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.82 -c check_ping_sat";
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "bts" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_ping_bts";
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "bts-sql" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_sql_bts";
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "dolex" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_ftp_dolex"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "unitelyego" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.3 -c check_ping_unitelyego"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "mipueblo" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_ftp_mipueblo"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "moneygram" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_ping_moneygram"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "moneygramws" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_ws_moneygram"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "telgua" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.3 -c check_ping_telgua"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "agexport" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.3 -c check_ping_agexpront"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "pida" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.82 -c check_ping_pida"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "maycom" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.82 -c check_ping_maycom"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "renap" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_ping_renap"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "renap-ws" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_renap_ws"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "sascim" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.82 -c check_ping_sascim"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "eegsa" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.1 -c check_ping_eegsa"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "sib" ]; then
	comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.3 -c check_https_sib"
	VALIDO="1";
    fi
    if [ "$SERVICIO" = "migracion" ]; then
        comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.5 -c check_http_migracion"
        VALIDO="1";
    fi
    if [ "$SERVICIO" = "viamericas" ]; then
        comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_ftp_viamericas"
        VALIDO="1";
    fi
    if [ "$SERVICIO" = "siafsag" ]; then
        comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_http_siafsag"
        VALIDO="1";
    fi
    if [ "$SERVICIO" = "oj" ]; then
        comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.5 -c check_ping_oj"
        VALIDO="1";
    fi
    if [ "$SERVICIO" = "5b" ]; then
        comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.107 -c check_ping_5b"
        VALIDO="1";
    fi
    if [ "$SERVICIO" = "yego" ]; then
        comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.3 -c check_ping_unitelyego"
        VALIDO="1";
    fi
    if [ "$SERVICIO" = "telefonica" ]; then
        comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.3 -c check_ping_telefonica"
        VALIDO="1";
    fi
    if [ "$SERVICIO" = "siafsag" ]; then
        comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_http_siafsag"
        VALIDO="1";
    fi
    if [ "$SERVICIO" = "rgp" ]; then
        comando="/usr/lib/nagios/plugins/check_tcp -H 172.16.0.25 -p 9080"
        VALIDO="1";
    fi
   if [ "$SERVICIO" = "declaraguate" ]; then
        comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_https_declaraguate"
        VALIDO="1";
    fi
   if [ "$SERVICIO" = "regmercantil" ]; then
        comando="/usr/lib/nagios/plugins/check_nrpe -H 10.160.201.1 -c check_http_regmercantil"
        VALIDO="1";
    fi
   if [ "$SERVICIO" = "pingregmercantil" ]; then
        comando="/usr/lib/nagios/plugins/check_nrpe -H 140.254.1.82 -c check_ping_regmercantil"
        VALIDO="1";
    fi

    if [ "$VALIDO" = "1" ]; then
	date;
	for ((a=1; i < CANTIDAD; i++))
	do
		$comando;
	done
	date;
    fi
    if [ "$VALIDO" = "0" ]; then
	print_help
	exit 0
    fi
fi
