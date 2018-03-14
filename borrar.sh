#!/bin/bash

read -p "Nombre del usuario a eliminar: " Pengguna

if getent passwd $Pengguna > /dev/null 2>&1; then
        userdel $Pengguna
        echo -e "User $Pengguna eliminado."
else
        echo -e "ERROR: Usuario $Pengguna no fue encontrado"
fi
