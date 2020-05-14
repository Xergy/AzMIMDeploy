#Converts Generalized VM to Image
$Index = "01"
$RGName = "acme-prod-va-sigt-$($Index)-rg"
$Location = "usgovvirginia"
$VMName = "acmepvaimage$($Index)"

#Target Location for Image
$ImageName = "windows-server-2019-base"
$RGNameTarget = "el-prod-va-mgmt-rg"

Stop-AzVM -ResourceGroupName $RGName -Name $VMName -Force

Set-AzVm -ResourceGroupName $RGName -Name $VMName -Generalized 

$VM = Get-AzVM -Name $VMName -ResourceGroupName $RGName

$Image = New-AzImageConfig -Location $Location -SourceVirtualMachineId $VM.Id 

#Capture in Local RG - just for fun...
New-AzImage -Image $Image -ImageName $ImageName -ResourceGroupName $RGName 

#Capture in Target RG
New-AzImage -Image $Image -ImageName $ImageName -ResourceGroupName $RGNameTarget

