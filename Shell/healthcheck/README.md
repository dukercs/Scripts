# Healthcheck
## Monitorar porta ou aplicação web de dentro do cont&ecirc;iner
<br />
Fun&ccedil;&atilde;o principal &eacute; utilizando de comandos b&aacute;sicos esperar um tempo ap&oacute;s o  início do container antes da checagem de sa&uacute;de, para o docker-compose. <br />Pois tive problemas com sistemas que levavam muito tempo para iniciar e acabavam por fechar antes de iniciar. <br /> Esse era o meu problema, o start_period conforme documenta&ccedil;&atilde;o fazia a execu&ccedil;&atilde;o do CMD e este matava a aplica&ccedil;&atilde;o antes dela terminar de iniciar.<br /> Aqui vou  o tempo fazer a valida&ccedil;&atilde;o e se falhar reiniciar o cont&ecirc;iner. Aceito sugest&otilde;es para reiniciar o cont&ecirc;iner.
<hr />

> Utiliza&ccedil;&atilde;o:
>> saudevalida.sh -c ou -n e tempo em segundos <br /> Para as op&ccedil;&otilde;es -c ou -n sua imagem deve ter o curl ou netcat respectivamente.
>>> -c Uso para URL ent&atilde;o passe a URL com protocolo<br />
>>> -n Uso do netcat passe o IP e porta <br />
>>> -t Apenas retorna o tempo do cont&ecirc;iner<br />
>>> -d Na primeira op&ccedil;&atilde;o para habilitar debug no bash<br />
>>
<br />
<br />
<br />

## For english speakers
## Healthcheck on application port or URL from container's shell

The main function is by using basic commands it will wait a while after the container has started. Useful to docker-compose because the start_period do not wait to run the CMD and if the CMD kills the application, it'll do it so before the application boot. 

> Use
>> saudevalida.sh -c or -n and time in seconds<br /> The -c and -n requires curl and netcat respectively in the image<br />
>>> -c Uses curl to fetch an URL, requires URL with procotol<br />
>>> -n Uses netcat to attempt to connect to an IP and PORT.<br />
>>> -t Just returns the time from container<br />
>>> -d At first option to enable debug<br />
>> 
