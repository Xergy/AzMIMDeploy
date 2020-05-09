#Converts Generalized VM to Image

$RGName = "acme-dev-eus-sigt-03-rg"
$Location = "usgovvirginia"
$VMName = "acmedeussigt01"
$ImageName = "windows-server-2019-base"

Stop-AzVM -ResourceGroupName $RGName -Name $VMName -Force

Set-AzVm -ResourceGroupName $RGName -Name $VMName -Generalized 

$VM = Get-AzVM -Name $VMName -ResourceGroupName $RGName

$Image = New-AzImageConfig -Location $Location -SourceVirtualMachineId $VM.Id 

New-AzImage -Image $Image -ImageName $ImageName -ResourceGroupName $RGName