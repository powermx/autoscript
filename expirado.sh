#!/bin/bash


datenow=$(date +%s)


for user in $(awk -F: '{print $1}' /etc/passwd); do


expdate=$(chage -l $user|awk -F: '/Account expires/{print $2}')
echo $expdate | grep -q never && continue

echo -n "Usuario \`$user' expirado el $expdate "


expsec=$(date +%s --date="$expdate")


diff=$( echo $datenow - $expsec)


echo $diff | grep -q ^\- && echo okay && continue
printf ""


read -r -p "Borrar el usuario? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then


echo deleting $user ...


userdel -r $user

else
exit
fi
done
