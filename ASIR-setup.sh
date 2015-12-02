#!/bin/bash

## Este script generará multiples scripts que contendran los comandos para tener
## todos los servidores con sus servicios y configuraciones.

## FUNCIONES ###################################################################
get_ip(){
	NETPART=`echo $1 | cut -d'.' -f1-3`
	echo "$NETPART.$2"
}
################################################################################

## PARAMETROS ##################################################################
read -p "Dirección IP de la red WAN (ej: 10.3.4.0): " WANNET
read -p "Dirección IP de la red DMZ (ej: 172.20.100.0): " DMZNET
read -p "Dirección IP de la red LAN (ej: 192.168.100.0): " LANNET

read -p "Hostname del servidor iptables: " IPTABLEHOSTNAME
read -p "Cuarto octeto de la dirección IP del servidor iptables para eth0 (ej. '84'): " IPTABLESIPWAN
IPTABLESIPWAN=`get_ip $WANNET $IPTABLESIPWAN`
read -p "Cuarto octeto de la dirección IP del servidor iptables para eth1 (ej. '254'): " IPTABLESIPLAN
IPTABLESIPLAN=`get_ip $LANNET $IPTABLESIPLAN`
read -p "Cuarto octeto de la dirección IP del servidor iptables para eth2 (ej. '254'): " IPTABLESIPDMZ
IPTABLESIPDMZ=`get_ip $DMZNET $IPTABLESIPDMZ`

read -p "Hostname del servidor DNS (ej. 'dns-server'): " DNSHOSTNAME
read -p "Cuarto octecto de la IP del servidor DNS (ej. '22'): " DNSSRVIP
DNSSRVIP=`get_ip $DMZNET $DNSSRVIP`
read -p "Nombre del dominio DNS (ej. 'pc00.s04'): " DNSDOMAIN

read -p "Hostname del servidor Apache2 (ej. 'apache-server'): " APACHEHOSTNAME
read -p "Dirección IP del servidor Apache2 (ej. 49): " APACHESRVIP
APACHESRVIP=`get_ip $DMZNET $APACHESRVIP`
read -p "Hostname del servidor Warrior (ej. 'warrior-server'): " WARRIORHOSTNAME
read -p "Dirección IP del servidor Warrior (ej. 50): " WARRIORSRVIP
WARRIORSRVIP=`get_ip $DMZNET $WARRIORSRVIP`

read -p "Hostname del servidor MySQL (ej. 'mysql-server'): " MYSQLHOSTNAME
read -p "Dirección IP del servidor MySQL (ej. 3): " MYSQLSRVIP
MYSQLSRVIP=`get_ip $DMZNET $MYSQLSRVIP`
################################################################################

## SERVIDOR IPTABLES ###########################################################

################################################################################

## SERVIDOR DNS ################################################################

################################################################################

## SERVIDOR WEB ################################################################

################################################################################

## SERVIDOR LDAP ###############################################################

################################################################################

## SERVIDOR MYSQL ##############################################################

################################################################################
