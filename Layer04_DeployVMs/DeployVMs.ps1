$VMConfigs = Import-Csv -Path ..\Naming.csv | Where-Object {$_.AzObjectType -eq "vm" } | out-gridview -Title "Choose SIGs to Deploy:" -OutputMode Multiple
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

If ($VMConfigs -eq $Null) {Write-Host "Exiting - No Configuration..."; exit }

# Create user object
$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

Foreach ($VMConfig in $VMConfigs) {
    $Params = $VMConfig.Params | ConvertFrom-Json

    $resourceGroup = $VMConfig.ResourceGroupName
    $location = $VMConfig.Location
    $vmName = $VMConfig.Name

    Write-Host "Processing $($vmName)..."

    If( (Get-AzContext).Subscription.Id -ne $VMConfig.SubscriptionId ) { Set-Azcontext -SubscriptionId $VMConfig.SubscriptionId | Out-Null}

    If( [bool](Get-AzVM -ResourceGroupName $resourceGroup -Name $vmName -ErrorAction SilentlyContinue) ) {Write-Host "VM Alreedy Exists!"; continue }

    # Network Items
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $VMConfig.ResourceGroupName -Name $Params.VNetName  
    $subnet = Get-AzVirtualNetworkSubnetConfig -Name $Params.SubnetName -VirtualNetwork $vnet
    New-AzNetworkInterface -Name "$($vmName)-nic" -ResourceGroupName $resourceGroup -Location $location `
      -Subnet $subnet -EnableAcceleratedNetworking
    $nic = get-AzNetworkInterface -Name "$($vmName)-nic" -ResourceGroupName $resourceGroup
    
    $imageVersionId = $Params.ImageVersionId
    # Sample: "/subscriptions/3ba3ebad-7974-4e80-a019-3a61e0b7fa91/resourceGroups/acme-dev-eus-sig-rg/providers/Microsoft.Compute/galleries/acmedevsig/images/windows-server-2019-base/versions/1.0.0"
    
    $NewVM = New-AzVMConfig -VMName $vmName -VMSize Standard_D8s_v3   | `
        Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
        Set-AzVMSourceImage -id $imageVersionId | `
        Add-AzVMNetworkInterface -Id $nic.Id | `
        Set-AzVMBootDiagnostic -Disable # | `

    New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $NewVM -Verbose -AsJob
    
} # $VMConfigs





