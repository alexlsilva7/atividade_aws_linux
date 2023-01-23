#!/bin/bash
# Script que verifica o status do serviço httpd e salva o resultado em um arquivo no diretório /mnt/nfs/alex
# Autor: Alex Lopes
# Data: 22/01/2023

DATA=$(date +%d/%m/%Y)
HORA=$(date +%H:%M:%S)
SERVICO="httpd"
STATUS=$(systemctl is-active $SERVICO)

if [ $STATUS == "active" ]; then
    MENSAGEM="O $SERVICO está ONLINE"
    echo "$DATA $HORA - $SERVICO - active - $MENSAGEM" >> /mnt/nfs/alexlopes/online.txt
else
    MENSAGEM="O $SERVICO está offline"
    echo "$DATA $HORA - $SERVICO - inactive - $MENSAGEM" >> /mnt/nfs/alexlopes/offline.txt
fi
