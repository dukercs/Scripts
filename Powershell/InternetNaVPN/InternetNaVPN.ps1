# Autor: Rodolpho Costa Stach
# Script: InternetNaVPN.ps1
# Funcao: Liberar acesso à Internet quando conectado a VPN pelo Windows 10 (Não testei em outras versões)
# Funcionamento: Desabilita a rota padrão como ip de vpn (SplitTunneling fica $true) e adiciona rotas da sua empresa para a VPN (Add-VpnConnectionRoute)
# Versão: 1.01 - Declarei a variavel redes como array linha 164 e comentei um teste que estava write-host na linha 179

# Limpeza de variáveis
$global:conecnome = ""
$global:rede = ""

# Função para janela com as VPN
# retorna variável $global:conecnome

function nomeVPN{Clear-Item Variable:global:conecnome
Clear-Item Variable:lista 2>&1>$null

$lista += Get-VpnConnection | foreach { $_.Name }

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Selecione a VPN'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'VPN encontradas'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80

foreach($var in $lista){
[void] $listBox.Items.Add($var)
}

$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $global:conecnome = $listBox.SelectedItem
}else{
    echo "Não foi selecionado VPN saindo..."

exit}
}

# função para janela pedindo o endereço de rede
#FIXME Não valida entrada
# retorna variável $global:rede
function ipRede{
Clear-Item Variable:global:rede 2>&1>$null
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Endereço de rede'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,25)
$label.Text = 'Informe a rede da empresa em CIDR 
Ex. 10.0.0.0/8 - Cancele para sair'
$form.Controls.Add($label)

$textBoxR = New-Object System.Windows.Forms.MaskedTextBox
$textBoxR.mask = "###.###.###.###"
$textBoxR.Location = New-Object System.Drawing.Point(10,50)
$textBoxR.Size = New-Object System.Drawing.Size(200,20)
$form.Controls.Add($textBoxR)

$labelbarra = New-Object System.Windows.Forms.Label
$labelbarra.Location = New-Object System.Drawing.Point(210,55)
$labelbarra.Size = New-Object System.Drawing.Size(10,30)
$labelbarra.Text = '/'
$form.Controls.Add($labelbarra)

$textBoxL = New-Object System.Windows.Forms.MaskedTextBox
$textBoxL.mask = "##"
$textBoxL.Location = New-Object System.Drawing.Point(220,50)
$textBoxL.Size = New-Object System.Drawing.Size(20,20)
$form.Controls.Add($textBoxL)


$form.Topmost = $true

$form.Add_Shown({$textBoxR.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    
    $netip = $textBoxR.Text.Replace(",",".").Replace(" ","")
    $cidr = $textBoxL.Text
    $global:rede = $netip+"/"+$cidr
    

}

}

#Verifica se foi passado uma conexão vpn válida
nomeVPN
if([string]::IsNullOrWhiteSpace($global:conecnome)){
    echo "sem nome de vpn saindo"
    exit
}


# Testa se a VPN já está configurada para não ser a rota padrão:
Clear-Item Variable:split 2>&1>$null
$split = Get-VpnConnection -name $global:conecnome | foreach {$_.SplitTunneling}

if( "$split" -eq "False" ){
	echo "Desativando rota padrão para VPN $global:conecnome"
	Set-VpnConnection –name $global:conecnome -SplitTunneling $true
}

# Repetição para pegar um ou mais endereços de rede para fazer a configuração.
Clear-Item variable:redes 2>&1>$null
$redes = @()
DO
{
ipRede
    if( -Not [string]::IsNullOrWhiteSpace($global:rede)){
        $redes += $global:rede
    }

}
Until($global:rede -eq $null)


# Valida se tem endereços para serem adicionadas rodas para VPN 
#FIXME Não valida se já existe a rota adiciona regra sobreescrevendo.
# Adiciona rotas mas pede confirmação
#Write-Host $redes
if($redes.Length -gt 0){
echo "Adicionar roteamento dinânico na VPN"
	Clear-Item Variable:ip 2>&1>$null
	Foreach ($ip in $redes){
		Add-VpnConnectionRoute -Confirm -ConnectionName $global:conecnome -DestinationPrefix $ip
	}
}
Clear-Item Variable:redes 2>&1>$null

