#!/bin/bash

read -p "Usuario : " Login
read -p "Clave : " Pass
read -p "Expira (dia): " masaaktif

IP=`dig +short myip.opendns.com @resolver1.opendns.com`
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "====Informacion cuenta SSH ===="
echo -e "Host: $IP" 
echo -e "Puerto OpenSSH: 22,143"
echo -e "Puerto Dropbear: 80,443"
echo -e "Puerto Stunnel4: 442"
echo -e "Puerto Squid: 8080,3128"
echo -e "Puerto SSL: 442"
echo -e "Config OpenVPN (TCP 1194): http://$IP:81/client.ovpn"
echo -e "Usuario: $Login "
echo -e "Clave: $Pass"
echo -e "-----------------------------"
echo -e "Expira: $exp"
echo -e "============================="
echo -e ""
