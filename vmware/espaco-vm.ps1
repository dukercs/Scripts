# SCRIPT espaco-vm.ps1
# Funcao busca pelo VmwareTools informacao de espaço total, espaço livre e espaço usado de cada disco de todas as VM
# Ele salva uma planilha CSV em c:\temp\espaco_vm.csv
$Colecao = @()
$AllVMs = Get-View -ViewType VirtualMachine | Where {-not $_.Config.Template}
$OrdemVMs = $AllVMs | Select *, @{N="NumDisks";E={@($_.Guest.Disk.Length)}} | Sort-Object -Descending NumDisks
ForEach ($VM in $OrdemVMs){
 $Details = New-object PSObject
 $Details | Add-Member -Name Name -Value $VM.name -Membertype NoteProperty
 $DiskNum = 0
 Foreach ($disk in $VM.Guest.Disk){
 $Details | Add-Member -Name "Disk$($DiskNum)Caminho" -MemberType NoteProperty -Value $Disk.DiskPath
 $Details | Add-Member -Name "Disk$($DiskNum)Capacidade(MB)" -MemberType NoteProperty -Value ([math]::Round($disk.Capacity/ 1MB))
 $Details | Add-Member -Name "Disk$($DiskNum)Espaco Livre(MB)" -MemberType NoteProperty -Value ([math]::Round($disk.FreeSpace / 1MB))
 $Details | Add-Member -Name "Disk$($DiskNum)Espaco Usado(MB)" -MemberType NoteProperty -Value ([math]::Round(($disk.Capacity - $disk.FreeSpace) / 1MB))
 $DiskNum++
 }
 $Colecao += $Details
}
$Colecao | Export-Csv c:\temp\espaco_vm.csv

#FIM DO SCRIPT