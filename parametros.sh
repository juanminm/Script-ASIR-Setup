#!/bin/bash
## PARAMETROS ##################################################################
get_ip(){
	NETPART=`echo $1 | cut -d'.' -f1-3`
	echo "$NETPART.$2"
}

pideIPZ(){
    # $1 sera de donde es dicha IP (ej: "de la red LAN") y $2 sera la IP ejemplo
    zenity --entry --title="IP $1" --text="Dirección IP $1:" --entry-text "ej. '$2'"
}

pideHostZ(){
    # $1 es el nombre de la 'utilidad' del servidor (ej: Apache2, DNS) y $2 el nombre real de dicha maquina (apache-server, dns-server)
    zenity --entry --title="Hostname del servidor $1" --text="Hostname del servidor $1:" --entry-text "$2"
}

pide4octZ(){
    # $1 sera de donde es dicho octeto (ej: "del servidor iptables") y $2 sera el numero ejemplo
    zenity --entry --title="Cuarto octeto de la dirección IP $1" --text="Cuarto octeto de la dirección IP $1:" --entry-text "ej. '$2'"
}

pideDomZ(){
    # $1 sera de donde es el dominio (DNS, Samba, LDAP) y $2 el nombre ejemplo
    zenity --entry --title="Nombre del dominio $1" --text="Nombre del dominio $1: " --entry-text "ej. '$2'"
}

WANNET=$(pideIPZ "de la red WAN" "10.3.4.0")
DMZNET=$(pideIPZ "de la red DMZ" "172.20.100.0")
LANNET=$(pideIPZ "de la red LAN" "192.168.100.0")

IPTABLEHOSTNAME=$(pideHostZ "iptables" "iptables-server")
IPTABLESIPWAN=$(pide4octZ "del servidor iptables para eth0" "84")
IPTABLESIPWAN=`get_ip $WANNET $IPTABLESIPWAN`
IPTABLESIPLAN=$(pide4octZ "del servidor iptables para eth1" "254")
IPTABLESIPLAN=`get_ip $LANNET $IPTABLESIPLAN`
IPTABLESIPDMZ=$(pide4octZ "del servidor iptables para eth2" "254")
IPTABLESIPDMZ=`get_ip $DMZNET $IPTABLESIPDMZ`

DNSHOSTNAME=$(pideHostZ "DNS" "dns-server")
DNSSRVIP=$(pide4octZ "del servidor DNS" "22")
DNSSRVIP=`get_ip $DMZNET $DNSSRVIP`
DNSDOMAIN=$(pideDomZ "DNS" "pc00.s04")

APACHEHOSTNAME=$(pideHostZ "Apache2" "apache-server")
APACHESRVIP=$(pide4octZ "del servidor Apache2" "49")
APACHESRVIP=`get_ip $DMZNET $APACHESRVIP`
WARRIORHOSTNAME=$(pideHostZ "Warrior" "warrior-server")
WARRIORSRVIP=$(pide4octZ "del servidor Warrior" "50")
WARRIORSRVIP=`get_ip $DMZNET $WARRIORSRVIP`

MYSQLHOSTNAME=$(pideHostZ "MySQL" "mysql-server")
MYSQLSRVIP=$(pide4octZ "del servidor MySQL" "3")
MYSQLSRVIP=`get_ip $DMZNET $MYSQLSRVIP`

LDAPHOSTNAME=$(pideHostZ "LDAP" "Sldap-pc00")
LDAPSRVIP=$(pide4octZ "del servidor LDAP" "5")
LDAPSRVIP=`get_ip $LANNET $LDAPSRVIP`
DOMAINNAME=$(pideDomZ "LDAP" "s04-pc00")
SMBDOMAIN=$(pideDomZ "Samba" "S04-PC00")
