#!/bin/bash
set -euo pipefail

mkdir -p dados/raw
cd dados/raw

BASE_URL="https://cloud5.lsd.ufcg.edu.br:8080/swift/v1/dadosjusbr"

anos=`seq 2018 2020`
orgaos="trepb mppb trt13 tjpb"
for ano in $anos; do
    for mes in `seq 1 12`; do
        for orgao in $orgaos; do
          echo "Baixando $orgao $ano-$mes"
          target=$orgao-$ano-$mes.zip
          curl -sSO $BASE_URL/$orgao/$target
        done
    done
done

for f in `ls *zip`; do unzip -o $f && mv data.csv $f-data.csv; done

cd -
