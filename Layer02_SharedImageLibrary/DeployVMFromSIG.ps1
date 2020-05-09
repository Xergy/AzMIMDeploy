$resourceGroup = "acme-dev-eus-sigt-02-rg"
$location = "EastUS"
$vmName = "acmedeussigt02"

Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

# Create user object
$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

# Create a resource group
New-AzResourceGroup -Name $resourceGroup -Location $location 

# Network pieces
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name acme-subnet01 -AddressPrefix 192.168.1.0/24 
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $location `
  -Name "acme-vnet" -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig 
$pip = New-AzPublicIpAddress -ResourceGroupName $resourceGroup -Location $location `
  -Name "$($vmName)-public-dns$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4
$nsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name "$($vmName)-NSG-RuleRDP"  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 3389 -Access Allow
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location `
  -Name "$($vmName)-nsg" -SecurityRules $nsgRuleRDP
$nic = New-AzNetworkInterface -Name "$($vmName)-nic" -ResourceGroupName $resourceGroup -Location $location `
  -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id -EnableAcceleratedNetworking

$imageVersionId = "/subscriptions/3ba3ebad-7974-4e80-a019-3a61e0b7fa91/resourceGroups/acme-dev-eus-sig-rg/providers/Microsoft.Compute/galleries/acmedevsig/images/windows-server-2019-base/versions/1.0.0"

# Create a virtual machine configuration using SIG Version Resource Id ($imageVersionId) to specify the shared image
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize Standard_D4_v3 | `
    Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
    Set-AzVMSourceImage -id $imageVersionId  | `
    Add-AzVMNetworkInterface -Id $nic.Id | `
    Set-AzVMBootDiagnostic -Disable

# Create a virtual machine
New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig -Verbose


