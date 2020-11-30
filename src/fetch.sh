#!/bin/bash
set -euo pipefail

mkdir -p dados/raw
cd dados/raw

anos=`seq 2018 2020`
for ano in $anos; do
    for mes in `seq 1 12`; do
        curl -O https://cloud5.lsd.ufcg.edu.br:8080/swift/v1/dadosjusbr/mppb/mppb-$ano-$mes.zip
    done
done

for f in `ls *zip`; do unzip -o $f && mv data.csv $f-data.csv; done

cd -
