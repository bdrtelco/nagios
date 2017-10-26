Generando un Certificado SSL para apache.

Dejar Registro:
        0. Ingresar el Nombre del Sitio en el archivo Control.    control.txt
           Seleccionar Password y correltativo.

Generar llave:
        1.      openssl genrsa -des3 -out server.key 4096

        Ingrese la clave que selecciono en el paso 0.

Solicitar Requerimiento:
        2.  openssl req -new -key server.key -out server.csr

Firmar Requerimiento:   <##> es el correlativo que se lleva ( el control se lleva en /etc/ssl/control.txt
        3.      openssl x509 -req -days 3650 -in server.csr -CA ./certs/bdrnagca.crt -CAkey ./private/bdrnagca.key -set_serial <##> -out server.crt

Quitar la solicitud de llave:
        4.      openssl rsa -in server.key -out server.key.insecure

Mover los datos:
        5.      mv server.key server.key.secure
                mv server.key.insecure server.key


Como resultado deberia estar estos archivos:
        6.    ls -l server*
                -rw-r--r--  1 root root 2049 2008-06-02 13:32 server.crt [Our certificate]
                -rw-r--r--  1 root root 1748 2008-06-02 13:23 server.csr [our server signing request]
                -rw-r--r--  1 root root 3243 2008-06-02 13:54 server.key [our password-less server key]
                -rw-r--r--  1 root root 3311 2008-06-02 13:13 server.key.secure [our passworded server key]


	6.b  Migrando Certificado para Windows IIS 
		
	openssl pkcs12 -export -in server.crt -inkey server.key -out server.pfx -name "Certificado <nombre>" 
	openssl pkcs12 -export -out ides.conclave.gfbanrural.com.gt.pfx -inkey ides.gfbanrural.com.gt.key -in ides.gfbanrural.com.gt.crt -certfile IntermediateCA.crt


Mover a Directorio para historia y backup:

        7.      ./mueve_y_renombra.sh <micert_nuevo_nombre>

	7.b	ls -lt ./selfsigned/ | head -n   10

Los archivos quedaron guardados en el directorio selfsigned.
  Linux: Copiar los archivos:
                <micert_nuevo_nombre>.crt
                <micert_nuevo_nombre>.key


  Windows: usar <micert_nuevo_nombre>.pfx
