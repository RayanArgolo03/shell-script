#!/bin/bash
set -e

function listProcessInfo() {

    local PS_FILE='processos.txt'
    # pega os 10 PIDs com maior uso de memória (sem cabeçalho)
    local PIDS=($(ps -e -o pid= --sort=-rss | head -n 10 | sed 's/^ *//'))

    echo "Preenchendo arquivo $PS_FILE.."
    echo "Processos no timestamp $(date +"%d/%m/%Y %H:%M")" >"$PS_FILE"

    for PID in $PIDS; do
        
        # obtém os campos e faz um parse robusto (usando awk)
        info=$(ps -p "$PID" -o pid=,comm=,rss=,etime=)
        pid=$(awk '{print $1}' <<<"$info")
        comm=$(awk '{print $2}' <<<"$info")
        rss=$(awk '{print $3}' <<<"$info")
        etime=$(awk '{print $4}' <<<"$info")

        # rss vem em KB, converte para MB com uma casa decimal
        RSS_MB=$(awk -v k="$rss" 'BEGIN{printf "%.1f", k/1024}')
        {
            echo "PID: $pid"
            echo "Comando: $comm"
            echo "Memória usada: ${RSS_MB} MB"
            echo "Tempo de execução: $etime"
            echo "---"
        } >>"$PS_FILE"

        sleep 2
    done
}

listProcessInfo
