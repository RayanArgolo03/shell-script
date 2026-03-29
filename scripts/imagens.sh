#!/bin/bash
set -eu

FORMAT=""

function readFormat() {
    FORMATS=$(convert -list format | awk '/ rw/ {print tolower($1)}' | sed 's/\*//g' | awk '{print NR " - " $0}')
    LAST_FORMAT_COUNT=$(echo "$FORMATS" | awk 'END {print NR}')

    echo "Bem vindo ao conversor de imagens!"
    echo "$FORMATS"

    while true; do
        read "OPTION?❓ Insira o número do formato que deseja converter (1 a $LAST_FORMAT_COUNT): "

        if ! [[ "$OPTION" =~ ^[0-9]+$ ]] || [[ "$OPTION" -lt 1 || "$OPTION" -gt "$LAST_FORMAT_COUNT" ]]; then
            echo "❌ Opção \"$OPTION\" inválida. Digite um número entre 1 e $LAST_FORMAT_COUNT!!"
        else
            FORMAT=$(echo "$FORMATS" | grep "^$OPTION " | awk '{print $3}')
            echo "✅ Tudo certo! Formato escolhido: $FORMAT"

            break
        fi
    done
}

function makeDir() {
    DIR="imagens-convertidas-para-$FORMAT"

    echo "🔎 Criando pasta..."
    sleep 2
    if [[ -d "$DIR" ]]; then
        echo "❌ Pasta com formato $FORMAT já existe, delete e tente novamente!"
        exit 1
    fi

    mkdir "$DIR"
    echo "✅ Feito! pasta criada corretamente"
}

function convertImages(){
    echo "🔎 Convertendo imagens para pasta imagens-convertidas-para-$FORMAT..."
}

readFormat
makeDir
convertImages
