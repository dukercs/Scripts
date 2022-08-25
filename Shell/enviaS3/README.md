# EnviaS3 <br />
## A partir de uma entrada na linha de comando envia arquvos para um bucket s3 e apaga a cópia local<br />
## Depende de um aws cli configurado com regiao<br /><br />
<hr />

## Uso<br />
<i>enviars3.sh <-p nome_profile/-na> path/para/arquivo bucket/path/remoto</i>

### Opções
* -p Indica o profile a ser usado como em aws --profile
* -na Não apaga o arquivo local