$Config = Import-Csv -Path ..\Naming.csv | out-gridview -Title "Choose SIGs to Deploy:" -OutputMode Multiple
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

$CurrentAzObjectType = "rg"
If ($Config.AzObjectType -contains $CurrentAzObjectType) { 
    $RgNames = $Config | where-object {$_.AzObjectType -eq "rg"} | Select-Object -Property AzObjectType,SubscriptionId,Location,ResourceGroupName
    $RGs = $RgNames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $_ | New-AzResourceGroup -Force
    }
    $RGs.ResourceGroupName
} else {write-host "Skipping AzObjectType $($CurrentAzObjectType)..."}

$CurrentAzObjectType = "sa"
If ($Config.AzObjectType -contains $CurrentAzObjectType) { 
    $SANames = $Config | where-object {$_.AzObjectType -eq "sa"} | Select-Object -Property AzObjectType,SubscriptionId,Location,ResourceGroupName,Name
    $SAs = $SANames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $_ | New-AzStorageAccount -SkuName Standard_LRS 
    }
    $SAs.Name    
} else {write-host "Skipping AzObjectType $($CurrentAzObjectType)..."}

$CurrentAzObjectType = "aa"
If ($Config.AzObjectType -contains $CurrentAzObjectType) { 
    $AANames = $Config | where-object {$_.AzObjectType -eq "aa"} | Select-Object -Property AzObjectType,SubscriptionId,Location,ResourceGroupName,Name
    $AAs = $AANames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $_ | New-AzAutomationAccount 
    }
    $AAs.Name
} else {write-host "Skipping AzObjectType $($CurrentAzObjectType)..."}

$CurrentAzObjectType = "la"
If ($Config.AzObjectType -contains $CurrentAzObjectType) { 
    $LANames = $Config | where-object {$_.AzObjectType -eq "la"} | Select-Object -Property AzObjectType,SubscriptionId,Location,ResourceGroupName,Name
    $LAs = $LANames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $_ | New-AzOperationalInsightsWorkspace -Sku Standard 
    }
    $LAs.Name    
} else {write-host "Skipping AzObjectType $($CurrentAzObjectType)..."}

$CurrentAzObjectType = "vnet"
If ($Config.AzObjectType -contains $CurrentAzObjectType) { 
    $VNetNames = $Config | where-object {$_.AzObjectType -eq "vnet"} | Select-Object -Property AzObjectType,SubscriptionId,Location,ResourceGroupName,Name,Params
    $Vnets = $VNetNames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $Params = $_.Params | ConvertFrom-Json
        $_ | New-AzVirtualNetwork -AddressPrefix $Params.AddressSpace -DnsServer $Params.DnsServer
    }
    $Vnets.Name
} else {write-host "Skipping AzObjectType $($CurrentAzObjectType)..."}

$CurrentAzObjectType = "sn"
If ($Config.AzObjectType -contains $CurrentAzObjectType) { 
    $SubnetNames = $Config | where-object {$_.AzObjectType -eq "sn"} | Select-Object -Property AzObjectType,SubscriptionId,Location,ResourceGroupName,Name,sn:AddressSpace,Params
    $VnetResults = $SubnetNames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $Params = $_.Params | ConvertFrom-Json
        $CurrentVNet = Get-AzVirtualNetwork -ResourceGroupName $_.ResourceGroupName -Name $Params.VNet      
        Add-AzVirtualNetworkSubnetConfig -Name $_.Name -VirtualNetwork $CurrentVNet -AddressPrefix $Params.AddressSpace
        Set-AzVirtualNetwork -VirtualNetwork $CurrentVNet 
    }
    $VnetResults.Name
} else {write-host "Skipping AzObjectType $($CurrentAzObjectType)..."}

$CurrentAzObjectType = "peer"
If ($Config.AzObjectType -contains $CurrentAzObjectType) { 
    $PeerNames = $Config | where-object {$_.AzObjectType -eq "peer"} | Select-Object -Property AzObjectType,SubscriptionId,Location,ResourceGroupName,Name,Params
    $Peers = $PeerNames  | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $Params = $_.Params | ConvertFrom-Json
        $Vnet1 = Get-AzVirtualNetwork -ResourceGroupName $_.ResourceGroupName -Name $Params.VnetName
        $Vnet2 = Get-AzVirtualNetwork -ResourceGroupName $Params.RVNetRG -Name $Params.RVNetName
        Add-AzVirtualNetworkPeering -Name $_.Name -VirtualNetwork $Vnet1 -RemoteVirtualNetworkId $Vnet2.Id
    }
    $Peers.Name
} else {write-host "Skipping AzObjectType $($CurrentAzObjectType)..."}

$CurrentAzObjectType = "btn"
If ($Config.AzObjectType -contains $CurrentAzObjectType) { 
    $BastionNames = $Config | where-object {$_.AzObjectType -eq "btn"} | Select-Object -Property AzObjectType,SubscriptionId,Location,ResourceGroupName,Name,Params
    $Bastions = $BastionNames | Foreach-Object {
        If( (Get-AzContext).Subscription.Id -ne $_.SubscriptionId ) { Set-Azcontext -SubscriptionId $_.SubscriptionId | Out-Null}
        $Params = $_.Params | ConvertFrom-Json
        New-AzPublicIpAddress -ResourceGroupName $_.ResourceGroupName -name $Params.PIPName -location $_.Location -AllocationMethod Static -Sku Standard
        $PIP = Get-AzPublicIpAddress -Name $Params.PIPName -ResourceGroupName $_.ResourceGroupName
        $Vnet = Get-AzVirtualNetwork -ResourceGroupName $_.ResourceGroupName -Name $Params.VnetName
        New-AzBastion -ResourceGroupName $_.ResourceGroupName -Name $_.Name -PublicIpAddress $PIP  -VirtualNetwork $Vnet
    }
    $Bastions.Name    
} else {write-host "Skipping AzObjectType $($CurrentAzObjectType)..."}






