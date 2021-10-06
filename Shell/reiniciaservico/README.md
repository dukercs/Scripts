## Script para reiniciar serviços

Parece algo simples que um restart com systemctl já resolveria, mas trabalhei com sistema legado que não tinha o systemd e o legado service quase sempre é direcionado para o systemctl.

### **Função**
Faz o **stop/start** usando o service validando espaço disponível no / e em outra particao que desejar, pois um restart em um disco quase cheio pode acarretar em problemas maiores pela geração de log.

A cada stop/start faz uma validação se o comando foi executado corretamente (*saída de erro*) e aguarda o término da alteração de estado do serviço, fazendo uma série de verificações, tentei deixar essa parte do script bem comentada.

Fiquem a vontade para comentar e me mandar correções ou outras maneiras de fazer mais simples.

Minha necessidade quando na criação do script era reiniciar um antigo wildfly durante a madrugada, por solicitação do cliente.

Quero agradecer o pessoal do canal Shell Script Brasil (**@shellbr**) no telegram os users **@ra2tech** e **@HelioLoureiro** me ajudaram na regex para pegar um pid do processo em execução :+1: 
## Obrigado!