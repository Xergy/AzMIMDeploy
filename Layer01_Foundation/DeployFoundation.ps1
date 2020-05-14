$Config = Import-Csv -Path ..\Naming.csv | out-gridview -Title "Choose SIGs to Deploy:" -OutputMode Multiple
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

$CurrentType = "rg"
If ($Config.Type -contains $CurrentType) {
    write-host "Processing Type $($CurrentType)..." 
    $RgNames = $Config | where-object {$_.Type -eq "rg"} | Select-Object -Property Type,SubscriptionId,Location,ResourceGroupName
    $RGs = $RgNames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $_ | New-AzResourceGroup -Force
    }
    $RGs.ResourceGroupName
} else {write-host "Skipping Type $($CurrentType)..."}

$CurrentType = "sa"
If ($Config.Type -contains $CurrentType) {
    write-host "Processing Type $($CurrentType)..."  
    $SANames = $Config | where-object {$_.Type -eq "sa"} | Select-Object -Property Type,SubscriptionId,Location,ResourceGroupName,Name
    $SAs = $SANames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $_ | New-AzStorageAccount -SkuName Standard_LRS 
    }
    $SAs.Name    
} else {write-host "Skipping Type $($CurrentType)..."}

$CurrentType = "vnet"
If ($Config.Type -contains $CurrentType) {
    write-host "Processing Type $($CurrentType)..."  
    $VNetNames = $Config | where-object {$_.Type -eq "vnet"} | Select-Object -Property Type,SubscriptionId,Location,ResourceGroupName,Name,Params
    $Vnets = $VNetNames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $Params = $_.Params | ConvertFrom-Json
        $_ | New-AzVirtualNetwork -AddressPrefix $Params.AddressSpace -DnsServer $Params.DnsServer
    }
    $Vnets.Name
} else {write-host "Skipping Type $($CurrentType)..."}

$CurrentType = "sn"
If ($Config.Type -contains $CurrentType) {
    write-host "Processing Type $($CurrentType)..."  
    $SubnetNames = $Config | where-object {$_.Type -eq "sn"} | Select-Object -Property Type,SubscriptionId,Location,ResourceGroupName,Name,sn:AddressSpace,Params
    $VnetResults = $SubnetNames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $Params = $_.Params | ConvertFrom-Json
        $CurrentVNet = Get-AzVirtualNetwork -ResourceGroupName $_.ResourceGroupName -Name $Params.VNet      
        Add-AzVirtualNetworkSubnetConfig -Name $_.Name -VirtualNetwork $CurrentVNet -AddressPrefix $Params.AddressSpace
        Set-AzVirtualNetwork -VirtualNetwork $CurrentVNet 
    }
    $VnetResults.Name
} else {write-host "Skipping Type $($CurrentType)..."}

$CurrentType = "peer"
If ($Config.Type -contains $CurrentType) {
    write-host "Processing Type $($CurrentType)..."  
    $PeerNames = $Config | where-object {$_.Type -eq "peer"} | Select-Object -Property Type,SubscriptionId,Location,ResourceGroupName,Name,Params
    $Peers = $PeerNames  | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $Params = $_.Params | ConvertFrom-Json
        $Vnet1 = Get-AzVirtualNetwork -ResourceGroupName $_.ResourceGroupName -Name $Params.VnetName
        $Vnet2 = Get-AzVirtualNetwork -ResourceGroupName $Params.RVNetRG -Name $Params.RVNetName
        Add-AzVirtualNetworkPeering -Name $_.Name -VirtualNetwork $Vnet1 -RemoteVirtualNetworkId $Vnet2.Id
    }
    $Peers.Name
} else {write-host "Skipping Type $($CurrentType)..."}

$CurrentType = "aa"
If ($Config.Type -contains $CurrentType) {
    write-host "Processing Type $($CurrentType)..."  
    $AANames = $Config | where-object {$_.Type -eq "aa"} | Select-Object -Property Type,SubscriptionId,Location,ResourceGroupName,Name
    $AAs = $AANames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $_ | New-AzAutomationAccount 
    }
    $AAs.Name
} else {write-host "Skipping Type $($CurrentType)..."}

$CurrentType = "la"
If ($Config.Type -contains $CurrentType) {
    write-host "Processing Type $($CurrentType)..." 
    $LANames = $Config | where-object {$_.Type -eq "la"} | Select-Object -Property Type,SubscriptionId,Location,ResourceGroupName,Name
    $LAs = $LANames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $_ | New-AzOperationalInsightsWorkspace -Sku Standard 
    }
    $LAs.Name    
} else {write-host "Skipping Type $($CurrentType)..."}

$CurrentType = "btn"
If ($Config.Type -contains $CurrentType) {
    write-host "Processing Type $($CurrentType)..."  
    $BastionNames = $Config | where-object {$_.Type -eq "btn"} | Select-Object -Property Type,SubscriptionId,Location,ResourceGroupName,Name,Params
    $Bastions = $BastionNames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $Params = $_.Params | ConvertFrom-Json
        New-AzPublicIpAddress -ResourceGroupName $_.ResourceGroupName -name $Params.PIPName -location $_.Location -AllocationMethod Static -Sku Standard
        $PIP = Get-AzPublicIpAddress -Name $Params.PIPName -ResourceGroupName $_.ResourceGroupName
        $Vnet = Get-AzVirtualNetwork -ResourceGroupName $_.ResourceGroupName -Name $Params.VnetName
        New-AzBastion -ResourceGroupName $_.ResourceGroupName -Name $_.Name -PublicIpAddress $PIP  -VirtualNetwork $Vnet 
    }
    $Bastions.Name    
} else {write-host "Skipping Type $($CurrentType)..."}






