

## Servicios Instalados ##

- OpenSSH  : 22, 143
- Dropbear : 80, 443
- Stunnel4 : 442
- Squid3   : 8080, 3128 (Limitado a la ip del SSH)
- OpenVPN  : TCP 1194 (Config : http://ip_vps:81/client.ovpn)
- badvpn   : badvpn-udpgw port 7300
- nginx    : 81

## Menu del Script ##

- menu         (Menu)
- nuevo        (Crear una cuenta SSH)
- prueba       (Crea una cuenta de Prueba)
- borrar       (Borra una cuenta SSH)
- checar       (Verifica una cuenta SSH o usuario)
- lista        (Lista de usuarios SSH)
- expirado     (Borrar usuario SSH expirado)
- restart      (Restart Servicios Dropbear, Webmin, Squid3, OpenVPN dan SSH)
- reboot       (Reboot VPS)
- speedtest    (Speedtest VPS)
- info         (Información del Sistema)

## Opciones ##

- DDoS Deflate (Sistema Anti DDoS
- Webmin
- Timezone : America/New_York
- IPv6     : [off]

## Instalacion ##

Copia y pega el siguiente comando para realizar la instalación

`apt-get update && apt-get install ca-certificates && wget https://raw.githubusercontent.com/powermx/autoscript/master/debian7.sh && chmod +x debian7.sh && ./debian7.sh`


Android México Team / PwrMX
=========

# Telegram: http://t.me/pwrmx/
# Blog: http://powermx.org/
