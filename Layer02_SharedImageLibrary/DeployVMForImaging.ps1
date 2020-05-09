

$resourceGroup = "acme-dev-eus-sigt-03-rg"
$location = "usgovvirginia"
$vmName = "acmedeussigt01"

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

$vmConfig = New-AzVMConfig -VMName $vmName -VMSize Standard_D8s_v3   | `
    Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2019-Datacenter" -Version "latest" | `
    Add-AzVMNetworkInterface -Id $nic.Id | `
    Set-AzVMBootDiagnostic -Disable | `
    ForEach-Object {
      $ResultVM = $_
      $Luns = 1..15 | foreach-object {"{0:D2}" -f $_ }
      foreach ($Lun in $Luns) {
        $ResultVM = Add-AzVMDataDisk -VM $ResultVM -Name "$($vmName)_DataDisk_$($Lun)" -LUN $Lun -Caching ReadWrite -DiskSizeinGB 63 -CreateOption Empty -StorageAccountType Standard_LRS
      } 
      $ResultVM    
    }
# Create a virtual machine
New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig -Verbose



