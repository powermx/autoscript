#!/bin/bash

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +8
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
wget "http://www.webmin.com/jcameron-key.asc"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc

# update
apt-get update

# install webserver
apt-get -y install nginx

# install essential package
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar

# install neofetch
echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | sudo tee -a /etc/apt/sources.list
curl -L "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" -o Release-neofetch.key && sudo apt-key add Release-neofetch.key && rm Release-neofetch.key
apt-get update
apt-get install -y neofetch

# install figlet
apt-get -y install figlet

echo "clear" >> .bashrc
echo 'MYIP=$(wget -qO- ipv4.icanhazip.com)' >> .bashrc
echo 'DATE=$(date +"%d-%m-%y")' >> .bashrc
echo 'TIME=$(date +"%T")' >> .bashrc
echo 'figlet -k "$HOSTNAME"' >> .bashrc
echo 'echo -e ""' >> .bashrc
echo 'echo -e "Nombre del Servidor : $HOSTNAME"' >> .bashrc
echo 'echo -e "IP del Servidor   : $MYIP"' >> .bashrc
echo 'echo -e "Fecha del Servidor : $DATE"' >> .bashrc
echo 'echo -e "Hora del Servidor : $TIME"' >> .bashrc
echo 'echo -e ""' >> .bashrc
echo 'echo -e "Bienvenido!"' >> .bashrc
echo 'echo -e "Teclee menu para ver el listado de comandos."' >> .bashrc
echo 'echo -e ""' >> .bashrc

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>1 + 1 = 2</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/vps.conf"
service nginx restart

# blockir torrent
iptables -A OUTPUT -p tcp --dport 6881:6889 -j DROP
iptables -A OUTPUT -p udp --dport 1024:65534 -j DROP
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
rm -f /etc/openvpn/openvpn.tar
wget -O /etc/openvpn/1194.conf "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_baru.conf
wget -O /etc/network/if-up.d/iptables "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# setting port ssh
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 80"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

# install stunnel4
apt-get -y install stunnel4
wget -O /etc/stunnel/stunnel.pem "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/stunnel.pem"
wget -O /etc/stunnel/stunnel.conf "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/stunnel.conf"
sed -i $MYIP2 /etc/stunnel/stunnel.conf
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart

# install fail2ban
apt-get -y install fail2ban;
service fail2ban restart

# install squid3
cd
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget -O webmin_1.870_all.deb "http://prdownloads.sourceforge.net/webadmin/webmin_1.870_all.deb"
dpkg -i --force-all webmin_1.870_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm /root/webmin_1.870_all.deb
service webmin restart

# install ddos deflate
cd
apt-get -y install dnsutils dsniff
wget https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/ddos-deflate-master.zip
unzip ddos-deflate-master.zip
cd ddos-deflate-master
./install.sh
rm -rf /root/ddos-deflate-master.zip

# setting banner
rm /etc/issue.net
wget -O /etc/issue.net "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/issue.net"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
service ssh restart
service dropbear restart

# download script
cd /usr/bin
wget -O menu "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/menu.sh"
wget -O nuevo "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/nuevo.sh"
wget -O prueba "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/prueba.sh"
wget -O borrar "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/borrar.sh"
wget -O checar "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/checar.sh"
wget -O lista "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/lista.sh"
wget -O expirado "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/expirado.sh"
wget -O restart "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/restart.sh"
wget -O speedtest "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/speedtest_cli.py"
wget -O info "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/info.sh"
wget -O acerca "https://bitbucket.org/blackkcatt/autoscript/raw/cdfff898e8b1caa50b6d422b9f2e89cf1e050a80/acerca.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x menu
chmod +x nuevo
chmod +x prueba
chmod +x borrar
chmod +x checar
chmod +x lista
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x expirado
chmod +x acerca

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service stunnel4 restart
service squid3 restart
service fail2ban restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo "Servicios:" | tee log-install.txt
echo "===========================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenSSH  : 22, 143"  | tee -a log-install.txt
echo "Dropbear : 80, 443"  | tee -a log-install.txt
echo "Stunnel4 : 442"  | tee -a log-install.txt
echo "Squid3   : 8080, 3128 (limit to IP SSH)"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:81/client.ovpn)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo "nginx    : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "menu         (Muestra una lista de comandos disponibles)"  | tee -a log-install.txt
echo "nuevo        (Crear una cuenta SSH)"  | tee -a log-install.txt
echo "prueba       (Crear una cuenta de prueba)"  | tee -a log-install.txt
echo "borrar       (Eliminar una cuenta SSH)"  | tee -a log-install.txt
echo "checar       (Verificar Login)"  | tee -a log-install.txt
echo "lista        (Verificar lista de cuentas SSH)"  | tee -a log-install.txt
echo "expirado     (Borrar usuarios expirados)"  | tee -a log-install.txt
echo "restart      (Restart Servicios Dropbear, Webmin, Squid3, OpenVPN dan SSH)"  | tee -a log-install.txt
echo "reboot       (Reboot VPS)"  | tee -a log-install.txt
echo "speedtest    (Speedtest VPS)"  | tee -a log-install.txt
echo "info         (Muestra información del Sistema)"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Otras Caracteristicas"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "Horario : America/Nueva_York"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Log Installation --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "VPS AUTO REBOOT TODAS LAS NOCHES A LAS 12"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==========================================="  | tee -a log-install.txt
cd
rm -f /root/debian7.sh