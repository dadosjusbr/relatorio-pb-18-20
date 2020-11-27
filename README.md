# Análises com dados do DadosJusBR

Código e reports de análises com os dados libertados pelo projeto. Temos no ar: 

  * [Descritivo dos dados de um mês do MPPB libertados com a versão do dadosjus de nov/2020](https://dadosjusbr.github.io/analises/relatorio-ago-2020.html)
  * [Um texto descrevendo o projeto e a obtenção de dados dos órgãos na BP](https://dadosjusbr.github.io/analises/relatorio.html)
  * [Apresentação de análises em dez/2019](https://dadosjusbr.github.io/analises/index.html)

## Para gerar um csv com todos os dados do MPPB

```
./src/fetch.sh
./src/transform_load.R
```

## Para desenvolver

Dados brutos vão em `dados/raw`, e prontos em `dados/ready`. 

Código para obter dados (e colocá-los em `dados/raw`) e transformar dados (colocando-os e `dados/ready`), assim como funções reusáveis vão em `src/`. 

Relatórios que usam dados prontos (`dados/ready`) ficam em `reports/`. Coloque o html de versões para publicação em `docs/` e eles estarão disponíveis em https://dadosjusbr.github.io/analises/. Não coloque o html dos relatórios em `reports/`. 
