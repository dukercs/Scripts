# criaquestoes.sh

## Descrição
Este script automatiza a criação de arquivos de questões em formato XML. Ele solicita informações ao usuário, como número da questão, nome e alternativas, e gera um arquivo XML formatado.

## Uso
Execute o script e siga as instruções interativas para inserir os dados da questão.

### Exemplo de uso:
```sh
./criaquestoes.sh
```

### Exemplo de entrada e saída:
```sh
criaquestoes.sh
Número da questão (QNUM): 07
Nome da questão (QNOME): Arquitetura Zabbix
Cole aqui a questão com todas as linhas antes das alternativas, depois dê um enter e finalize com CTRL+D para sair:
Em um ambiente de TI de uma grande empresa, a equipe de operações precisa garantir a disponibilidade e o desempenho dos serviços. Para isso, foi implementado um sistema de monitoramento utilizando a ferramenta Zabbix, que permite a coleta de métricas e a geração de alertas. O Zabbix é uma ferramenta de código aberto que oferece flexibilidade e escalabilidade, sendo amplamente utilizada para monitoramento de infraestrutura.

Durante a configuração do Zabbix, a equipe de TI precisa definir os principais componentes da arquitetura do Zabbix para garantir que a coleta de dados e a geração de alertas funcionem corretamente. Dentre os componentes listados abaixo, quais são essenciais para a operação do Zabbix?

    I. Zabbix Server
    II. Zabbix Database
    III. Zabbix Web Interface
    IV. Zabbix Agent
    V. Zabbix Proxy

Alternativas:
Vamos cadastrar as alternativas e depois a alternativa correta.
Texto da resposta A (ATEXTO): I, II e III
Texto da resposta B (BTEXTO): I, II, IV e V
Texto da resposta C (CTEXTO): II, III e V
Texto da resposta D (DTEXTO): I, II, III e IV
Texto da resposta E (ETEXTO): Todas as alternativas
Alternativa correta: D
Arquivo questao_07_Arquitetura_Zabbix.xml gerado com sucesso!
```

## Requisitos
- Shell Unix/Linux compatível (bash, sh)
- Permissão de execução para o script (`chmod +x criaquestoes.sh`)

## Autor
Desenvolvido para facilitar a criação automatizada de questões em XML.

## Licença
Este projeto é distribuído sob a Licença MIT.

