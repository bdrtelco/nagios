FOBANNER="/etc/ssh/ssh-banner"
FOISSUE="/etc/issue"
FOSSHRC="/etc/ssh/sshrc"
FOMOTD="/etc/motd"

echo '+---------------------------------------------------------+' > $FOBANNER
echo '| Este servidor  es parte del Grupo Financiero Banrural   |' >>$FOBANNER
echo '|          Todo acceso es auditado y loggeado             |' >>$FOBANNER
echo '+---------------------------------------------------------+' >>$FOBANNER

cp $FOBANNER $FOISSUE

echo "" > $FOMOTD
echo "Precaucion:  Usted es responsable del uso que se haga de esta sesion" >> $FOMOTD 
echo "" >> $FOMOTD

echo 'if [ -n "$SSH_CLIENT" ]' > $FOSSHRC
echo 'then' >> $FOSSHRC
echo '  set $SSH_CLIENT'>> $FOSSHRC
echo '  echo ' >> $FOSSHRC
echo '  echo Se ha conectado desde:  $1 puerto $2'>> $FOSSHRC
echo '  echo '>> $FOSSHRC
echo 'fi'>> $FOSSHRC
echo 'echo '>> $FOSSHRC

