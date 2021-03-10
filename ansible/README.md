# Scripts ansible automatizando algumas tarefas
## Graylog_syslog
## cria_usuario_sudo

* Graylog_syslog<br />
Configura o rsyslog para enviar os logs de todas as mensagens das facilities(fontes) kern e authpriv e as mensagens emergenciais de qualquer facility(fonte) para um input tipo syslog tcp de um graylog. Nesse caso é apenas adicionado um arquivo na conf do rsyslog e feito o restart do rsyslog.

* cria_usuario_sudo<br />
Cria usuários e um grupo sudo_ti a partir de um arquivo contendo o nome do usuário e a senha em formato SHA512 do passwd para criar usei o openssl mas testei com mkpasswd e python3 com o modulo crypt vou deixar os 3 comandos para escolherem qual fica melhor:
 1. openssl<br />
  `$ openssl passwd -6 -salt xyz suasenhatexto`
 2. mkpasswd<br />
  `$ echo suasenhatexto|mkpasswd --method=SHA-512 --stdin`
 3. Python3<br />
  `$ python3 -c 'import crypt; print(crypt.crypt("suasenhatexto", crypt.mksalt(crypt.METHOD_SHA512)))' `

