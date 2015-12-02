#!/bin/bash

## Este script generará multiples scripts que contendran los comandos para tener
## todos los servidores con sus servicios y configuraciones.

## PARAMETROS GLOBALES #########################################################
read -p "Hostname del servidor LDAP (ej. 'Sldap-pc11')" LDAPHOSTNAME
read -p "Dirección IP del servidor LDAP (ej. 192.168.100.5): " LDAPSRVIP
read -p "Nombre de dominio LDAP (ej 's04-pc00'): " DOMAINNAME
read -p "Nombre de dominio Samba (ej. 'S04-PC00'): " SMBDOMAIN
read -p "Contraseña de root de SAMBA (ej. 'ausias'): " SMBROOTPASS
################################################################################

## SERVIDOR IPTABLES ###########################################################

################################################################################

## SERVIDOR DNS ################################################################

################################################################################

## SERVIDOR WEB ################################################################

################################################################################

## SERVIDOR LDAP ###############################################################
sudo apt-get install slapd ldap-utils samba samba-doc libpam-smbpass smbclient smbldap-tools winbind
sudo dpkg-reconfigure slapd
sudo slapcat
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/cosine.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/nis.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/inetorgperson.ldif
sudo -u root bash <<'EOF'
zcat /usr/share/doc/samba-doc/examples/LDAP/samba.schema.gz > /etc/ldap/schema/samba.schema
cat <<'EOF2' >samba.conf
include /etc/ldap/schema/core.schema
include /etc/ldap/schema/cosine.schema
include /etc/ldap/schema/nis.schema
include /etc/ldap/schema/inetorgperson.schema
include /etc/ldap/schema/samba.schema
EOF2
mkdir /tmp/slapd.d
slaptest -f samba.conf -F /tmp/slapd.d/
cp "/tmp/slapd.d/cn=config/cn=schema/cn={4}samba.ldif" "/etc/ldap/slapd.d/cn=config/cn=schema"
chown openldap:openldap '/etc/ldap/slapd.d/cn=config/cn=schema/cn={4}samba.ldif'
/etc/init.d/slapd stop
/etc/init.d/slapd start
ldapsearch -LLLQY EXTERNAL -H ldapi:/// -b cn=schema,cn=config "(objectClass=olcSchemaConfig)" dn
EOF
sudo cp /etc/samba/smb.conf smb.conf.old
sudo cat <<EOF > /etc/samba/smb.conf
;
; /etc/smb.conf
;
[global]
# Nombre de dominio
   workgroup = $DOMAINNAME
# Nombre de servidor para ser visto por los PCs de Windows.
   netbios name = ${DOMAINNAME}-samba
# Es un PDC
   domain logons = yes
   domain master = yes
# Es un Servidor WINS
   wins support = yes
   obey pam restrictions = yes
   dns proxy = no
   os level = 35
   log file = /var/log/samba/log.%m
   max log size = 1000
   syslog = 0
   panic action = /usr/share/samba/panic-action %d
   pam password change = yes
# Permitir a los ususarios de Windows cambiar su password con Ctrl-Alt-Del
   unix password sync = no
   ldap passwd sync = yes
# Imprimir desde los PCs vía CUPS
   load printers = yes
   printing = cups
   printcap name = cups
# Use LDAP for Samba user accounts and groups ..
   passdb backend = ldapsam:ldap://localhost
# This must match init.ldif ...
   ldap suffix = dc=${DOMAINNAME},dc=local
# The password for cn=admin MUST be stored in /etc/samba/secrets.tdb
# This is done by running 'sudo smbpasswd -w'
   ldap admin dn = cn=admin,dc=${DOMAINNAME},dc=local
# 4 OUs that Samba uses when creating user accounts , computer accounts , etc.
# (Because we are using smbldap-tools, call them 'Users','Computers',etc.)
   ldap machine suffix = ou=Computers
   ldap user suffix = ou=Users
   ldap group suffix = ou=Groups
   ldap idmap suffix = ou=Idmap
# Samba and LDAP server are on the same server in this example.
   ldap ssl = no
# Scripts for Samba to use if it creates users, groups, etc.
   add user script = /usr/sbin/smbldap-useradd -m '%u'
   delete user script = /usr/sbin/smbldap-userdel '%u'
   add group script = /usr/sbin/smbldap-group-add -p '%g'
   delete group script = /usr/sbin/smbldap-groupdel '%g'
   add user to group script = /usr/sbin/smbldap-groupmod -m '%u''%g'
   delete user from group script = /usr/sbin/smbldap-groupmod -x '%u''%g'
   set primary group script = /usr/sbin/smbldap-usermod -g '%g''%u'
# Script that Samba users when a PC joins the domain ..
# (when changing ' Computer Properties' on the PC)
   add machine script = /usr/smb/smbldap-useradd -w '%u'
# Values used when a new user is created ..
# (Note: '%L' does not work properly with smbldap-tools 0.9.4-1)
# Opción 1 – Sin perfil móvil, cuando inicie sesión un usuario, se creará el “home” en
# cada equipo local.
   logon drive =
   logon home =
   logon path =
   logon script = allusers.bat
#
# This is required for Windows XP client ..
   server signing = auto
   server schannel = auto
[homes]
   comment = Home Directories
   valid users = %S
   read only = no
   browseable = no
[netlogon]
   comment = Network Logon Service
   path = /var/lib/samba/netlogon
   admin users = root
   guest ok = yes
   browsable =no
   logon script = allusers.bat
[Profiles]
   comment = Roaming Profile Share
   # would probably change this to elsewhere in a production system ...
   path = /var/lib/samba/profiles
   read only = no
   profile acls = yes
   browseable = no
[printers]
   comment = All Printers
   path = /var/spool/samba
   use client driver = yes
   create mask = 0600
   guest ok = yes
   printable = yes
   browseable = no
   public = yes
   writable = yes
   admin users = root
   write list = root
[print$]
   comment = Printer Drivers Share
   path = /var/lib/samba/printers
   write list = root
   create mask = 0664
   directory mask = 0775
   admin users = root
[shared]
   writeable = yes
   path = /var/lib/samba/shared
   public = yes
   browseable = yes
[archive]
   path = /exports/archive
   browseable = yes
   create mask = 755
   directory mask = 755
   read only = no
EOF
testparm
read -p "Lee y comprueba el testparm. Despues dale a ENTER"
sudo service smbd restart
sudo service nmbd restart
sudo service winbind restart
sudo smbpasswd -W
sudo smbclient -L localhost
sudo mkdir -v -m 777 /var/lib/samba/profiles
sudo mkdir -v -p -m 777 /var/lib/samba/netlogon
sudo cp /usr/share/doc/smbldap-tools/examples/smbldap.conf.gz /etc/smbldap-tools/
sudo cp /usr/share/doc/smbldap-tools/examples/smbldap_bind.conf /etc/smbldap-tools/
sudo gzip -d /etc/smbldap-tools/smbldap.conf.gz
LocalSID=`sudo net getlocalsid | cut -d':' -f2 | tr -d ' '`
sed -i -e "s/SID=\".*\"/SID=\"$LocalSID\"/g" \
-e "s/sambaDomain=\".*\"/sambaDomain=$SMBDOMAIN/g" \
-e "s/slaveLDAP=/#slaveLDAP=/g" \
-e "s/masterLDAP=\".*\"/masterLDAP=\"ldap:\/\/$LDAPHOSTNAME.$DOMAINNAME.local\/\"/g" \
-e "s/ldapTLS=\"1\"/ldapTLS=\"0\"/g" \
-e "s/verify=\"require\"/verify=\"none\"/g" \
-e "s/clientcert=\".*\"/clientcert=\"\/etc\/smbldap-tools\/smbldap-tools.$DOMAINNAME.local.pem\"/g" \
-e "s/clientkey=\".*\"/clientkey=\"\/etc\/smbldap-tools\/smbldap-tools.$DOMAINNAME.local.key\"/g" \
-e "s/suffix=\".*\"/suffix=\"dc=$DOMAINNAME,dc=local\"/g" \
-e "s/userSmbHome=\".*\"/userSmbHome=\""'\\\\'"$SMBDOMAIN"'\\%U'"\"/g" \
-e "s/userProfile=\".*\"/userProfile=\""'\\\\'"$SMBDOMAIN"'\\profiles\\%U'"\"/g" \
-e "s/userHomeDrive=\".*\"/userHomeDrive=\"H:\"/g" \
-e "s/mailDomain=\".*\"/mailDomain=\"$DOMAINNAME.local\"/g" \
/etc/smbldap-tools/smbldap.conf

sed -i -e "s/slaveDN=\"/#slaveSID=\"/g" \
-e "s/slavePw=\"/#slavePw=\"/g" \
-e "s/masterDN=\".*\"/masterDN=\"cn=admin,dc=$DOMAINNAME,dc=local\"/g" \
-e "s/masterPw=\".*\"/masterPw=\"$SMBROOTPASS\"/g" \
/etc/smbldap-tools/smbldap_bind.conf

sudo smbldap-populate
sudo service smbd restart
sudo service nmbd restart
sudo service winbind restart
sudo service slapd restart
read -p "Se va a instalar libnss-ldap, lo siguiente que debes escribir en orden es:
    ldap://$LDAPSRVIP
    dc=$DOMAINNAME,dc=local
    3
    Sí
    No
    cn=admin,dc=$DOMAINNAME,dc=local
	******"
sudo apt-get install libnss-ldap
read -p "Ahora se reconfigurará, lo mismo pero añadiendo:
	debconf: Sí
	Local crypt: crypt"
sudo dpkg-reconfigure ldap-auth-config
sudo auth-client-config -t nss -p lac_ldap
read -p "Selecciona las siguientes:
    [*] Unix authentication                                                                                                                                  │
    [*] Winbind NT/Active Directory authentication                                                                                                           │
    [*] LDAP Authentication"
sudo pam-auth-update
read -p "Comprueba los siguientes grupos..."
sudo getent group | less
sudo apt-get install apache2 ldap-account-manager
sudo service apache2 restart
read -p "A partir de aquí configura el LDAP mediante el LDAP Manager"
################################################################################

## SERVIDOR MYSQL ##############################################################

################################################################################
