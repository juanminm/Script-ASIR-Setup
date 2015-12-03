## PARAMETROS ##################################################################
WANNET=$(zenity --entry --title="IP de la red WAN" --text="Dirección IP de la red WAN:" --entry-text "ej: 10.3.4.0")
DMZNET=$(zenity --entry --title="IP de la red DMZ" --text="Dirección IP de la red DMZ:" --entry-text "ej: 172.20.100.0")
LANNET=$(zenity --entry --title="IP de la red LAN" --text="Dirección IP de la red LAN:" --entry-text "ej: 192.168.100.0")

IPTABLEHOSTNAME=$(zenity --entry --title="Hostname del servidor iptables" --text="Hostname del servidor iptables:" --entry-text "<Introduce aqui el nombre>")
IPTABLESIPWAN=$(zenity --entry --title="Cuarto octeto de la dirección IP del servidor iptables para eth0" --text="Cuarto octeto de la dirección IP del servidor iptables para eth0:" --entry-text "ej. '84'")
IPTABLESIPWAN=`get_ip $WANNET $IPTABLESIPWAN`
IPTABLESIPLAN=$(zenity --entry --title="Cuarto octeto de la dirección IP del servidor iptables para eth1" --text="Cuarto octeto de la dirección IP del servidor iptables para eth1:" --entry-text "ej. '254'")
IPTABLESIPLAN=`get_ip $LANNET $IPTABLESIPLAN`
IPTABLESIPDMZ=$(zenity --entry --title="Cuarto octeto de la dirección IP del servidor iptables para eth2" --text="Cuarto octeto de la dirección IP del servidor iptables para eth2:" --entry-text "ej. '254'")
IPTABLESIPDMZ=`get_ip $DMZNET $IPTABLESIPDMZ`

#    read -p "Hostname del servidor DNS (ej. 'dns-server'): " DNSHOSTNAME
    read -p "Cuarto octecto de la IP del servidor DNS (ej. '22'): " DNSSRVIP
    DNSSRVIP=`get_ip $DMZNET $DNSSRVIP`
    read -p "Nombre del dominio DNS (ej. 'pc00.s04'): " DNSDOMAIN

DNSHOSTNAME=$(zenity --entry --title="Hostname del servidor DNS" --text="Hostname del servidor DNS:" --entry-text "<Introduce aqui el nombre>")
DNSSRVIP=$()
DNSSRVIP=`get_ip $DMZNET $DNSSRVIP`
DNSDOMAIN=$()

    read -p "Hostname del servidor Apache2 (ej. 'apache-server'): " APACHEHOSTNAME
    read -p "Dirección IP del servidor Apache2 (ej. 49): " APACHESRVIP
    APACHESRVIP=`get_ip $DMZNET $APACHESRVIP`
    read -p "Hostname del servidor Warrior (ej. 'warrior-server'): " WARRIORHOSTNAME
    read -p "Dirección IP del servidor Warrior (ej. 50): " WARRIORSRVIP
    WARRIORSRVIP=`get_ip $DMZNET $WARRIORSRVIP`




    read -p "Hostname del servidor MySQL (ej. 'mysql-server'): " MYSQLHOSTNAME
    read -p "Dirección IP del servidor MySQL (ej. 3): " MYSQLSRVIP
    MYSQLSRVIP=`get_ip $DMZNET $MYSQLSRVIP`




    read -p "Hostname del servidor LDAP (ej. 'Sldap-pc00')" LDAPHOSTNAME
    read -p "Cuarto octeto de la dirección IP del servidor LDAP (ej. '5'): " LDAPSRVIP
    LDAPSRVIP=`get_ip $LANNET $LDAPSRVIP`
    read -p "Nombre de dominio LDAP (ej 's04-pc00'): " DOMAINNAME
    read -p "Nombre de dominio Samba (ej. 'S04-PC00'): " SMBDOMAIN
