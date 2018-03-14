#!/bin/bash

IP=`dig +short myip.opendns.com @resolver1.opendns.com`

Login=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
hari="1"
Pass=`</dev/urandom tr -dc a-f0-9 | head -c9`

useradd -e `date -d "$hari days" +"%Y-%m-%d"` -s /bin/false -M $Login
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "====Cuenta SSH de Prueba===="
echo -e "Host: $IP" 
echo -e "Puerto OpenSSH: 22,143"
echo -e "Puerto Dropbear: 80,443"
echo -e "Puerto Stunnel4: 442"
echo -e "Puerto Squid: 8080,3128"
echo -e "Puerto SSL: 442"
echo -e "Config OpenVPN (TCP 1194): http://$IP:81/client.ovpn"
echo -e "Usuario: $Login"
echo -e "Clave: $Pass\n"
echo -e "========================="
echo -e ""
