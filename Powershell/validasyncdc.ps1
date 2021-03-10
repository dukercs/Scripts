# PowerShell
# Script: validasyncdc.ps1
# Autor: Rodolpho Costa Stach
# Empresa: DataTraffic S/A
# Função: Faz uma checagem com o cmdlet Get-ADReplicationPartnerMetadata para todos os domínios e verificar se houve algum erro dispara um email para o relay relay.email.com com destino infra@datatraffic.com.br
# Versao 1.01: Adicionado comando zabbix_sender para enviar um valor 0 (para ok) e 1 (para problema) para item sync trapper 
# Versao 1.02: Adicionado saida > $null nos comandos do zabbix_sender para simular um modo quieto
# Versao 1.03: Adicionado linhas na tabela e cor na primeira linha opcao -header na funcao ConvertTo-Html  e variavel $Header com CSS simples

# Variável do tipo Array que contem o resultado do cmdlet Get-ADReplicationPartnerMetadata com os DC que a ultima replicação falhou 
# Explicação:
#  Declaro a variável $dc como um array;
#  Com Get-ADReplicationPartnerMetadata -target * -scope server busco a informação de todos os DC (-target *) no escopo server 
#		Com where {$_.lastreplicationresult -ne "0"} pego todos os resultados que falharam 
#		Usando um select pego apenas o campo nome da lista dos servidores
#FIXME  Fui obrigado a usar o Get-Unique pois o Get-ADReplicationPartnerMetadata estava retornando duplicado o select
# 
$dc = @()
$dc += Get-ADReplicationPartnerMetadata -target * -Partition * -scope server | where {$_.lastreplicationresult -ne "0"} | Select-Object server | Get-Unique -AsString


# Função de disparo de email não autenticado com relay que tem no relay.email.com
# A função envia um email com o conteúdo do Get-ADReplicationPartnerMetadata -target * -scope server | where {$_.lastreplicationresult -ne "0"} | Select-Object server,lastreplicationattempt,lastreplicationresult,partner | ConvertTo-Html
#  Com Get-ADReplicationPartnerMetadata -target * -scope server busco a informação de todos os DC (-target *) no escopo server 
#  Faço um select nos atributos server, lastreplicationattempt(ultima tentativa de replicação), lastreplicationresult(Resultado da última replicação) e partner(DC onde tentou replicar)
#  Depois o resultado do select neste comando converto em html com o cmdlet ConvertTo-Html
#Email:
# Optei o uso do System.Net.Mail.MailMessage por questões de compatibilidade com versões 3, 4 e 5 do powershell nele instanciei um objeto nome mail para a mensagem:
# $mail nome do objeto ($mail = New-Object System.Net.Mail.MailMessage( "emailfrom@dominio" , "emailPara@dominio" ) )
# $mail.Subject = "Falha na sincronização" (Assunto do email)
# $mail.IsBodyHtml = $true ( Aqui é uma flag que indica que o corpo do e-mail é no formato Html
# $mail.Body = Get-ADReplicationPartnerMetadata -target * -scope server | Select-Object server,Partition,lastreplicationattempt,ConsecutiveReplicationFailures,lastreplicationresult,LastReplicationSuccess,partner | ConvertTo-Html
#   Aqui é o corpo do e-mail com o resultado do comando em HTML 
#Disparo do email com o System.Net.Mail.SmtpClient onde instanciei um novo objeto $client com o IP e porta do relay que temos na rede relay.email.com porta 25
# $client.EnableSsl = $false (Indica que a conexão com o relay não é criptografada com SSL
# $client.Send( $mail ) - Disparo do e-mail com o conteúdo do objeto $mail já definido

function enviarEmail{
$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@
	$mail = New-Object System.Net.Mail.MailMessage( "infra@datatraffic.com.br" , "infra@datatraffic.com.br" )
	$mail.Subject = "Falha na sincronização"
	$mail.IsBodyHtml = $true
	$mail.Body = Get-ADReplicationPartnerMetadata -target * -Partition * -scope server | Select-Object server,Partition,lastreplicationattempt,ConsecutiveReplicationFailures,lastreplicationresult,LastReplicationSuccess,partner | ConvertTo-Html -Head $Header

	$client = New-Object System.Net.Mail.SmtpClient( "relay.email.com" , 25 )
	$client.EnableSsl = $false
	$client.Send( $mail )
}

# Teste se teve algum servidor que falhou ou falharam a sincronização
# Apenas pego o comprimento da variável e testo se é maior que zero 0 (se o comando anterior nao retornar nada o array fica zerado e seu cumprimento é zero)
if ($dc.Length -gt 0) {
	enviarEmail
	&"C:\Program Files\Zabbix Agent\zabbix_sender.exe" -c 'C:\Program Files\Zabbix Agent\zabbix_agentd.conf' -k sync -o 1 > $null
}else{
	&"C:\Program Files\Zabbix Agent\zabbix_sender.exe" -c 'C:\Program Files\Zabbix Agent\zabbix_agentd.conf' -k sync -o 0 > $null
}