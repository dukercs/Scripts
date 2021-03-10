# PowerShell
# Script: Verifica Replicação
# Autor: Rodolpho Costa Stach
# Empresa: DataTraffic S/A
# Função: Executa um Measure-VMReplication e gera um relatório com nome do Servidor, estado da replicação, saúde e hora da última replicação
# Versao 1.01: Adicionado linhas na tabela e cor na primeira linha opcao -header na funcao ConvertTo-Html  e variavel $Header com CSS simples

# Função de disparo de email não autenticado com relay que tem no relay.email.com
# A função envia um email com o conteúdo do array $rep
#Email:
# Optei o uso do System.Net.Mail.MailMessage por questões de compatibilidade com versões 3, 4 e 5 do powershell nele instanciei um objeto nome mail para a mensagem:
# $mail nome do objeto ($mail = New-Object System.Net.Mail.MailMessage( "emailfrom@dominio" , "emailPara@dominio" ) )
# $mail.Subject é o assunto do e-mail.
# $mail.IsBodyHtml = $true ( Aqui é uma flag que indica que o corpo do e-mail é no formato Html
# $mail.Body = Array do Measure-VMReplication
#   Aqui é o corpo do e-mail com o resultado do comando em HTML 
#Disparo do email com o System.Net.Mail.SmtpClient onde instanciei um novo objeto $client com o IP e porta do relay que temos na rede relay.email.com porta 25
# $client.EnableSsl = $false (Indica que a conex�o com o relay não é criptografada com SSL
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
	$mail.Subject = "HYPERV-CLUSTER: Status da replicação"
	$mail.IsBodyHtml = $true
	$mail.Body = Get-ClusterNode -Cluster HYPERV-CLUSTER | foreach-object {Measure-VMReplication -ComputerName $_ |Select VMName, State, Health, LReplTime }| ConvertTo-Html -Head $Header

	$client = New-Object System.Net.Mail.SmtpClient( "relay.email.com" , 25 )
	$client.EnableSsl = $false
	$client.Send( $mail )
}

enviarEmail