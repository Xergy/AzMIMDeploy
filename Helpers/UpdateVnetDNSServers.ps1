$VnetConfigs = Import-Csv -Path ..\Naming.csv | Where-Object {$_.AzObjectType -eq "vnet" } | out-gridview -Title "Choose VNet to Configure" -OutputMode Multiple
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

If ($VnetConfigs -eq $Null) {Write-Host "Exiting - No Configuration..."; exit }


Foreach ($VnetConfig in $VnetConfigs) {
    $SubscriptionID = $VnetConfig.SubscriptionId
    If( (Get-AzContext).Subscription.Id -ne $SubscriptionID ) { Set-Azcontext -SubscriptionId $SubscriptionID | Out-Null}
    Write-Host "Updating VNet $($VnetConfig.Name)..."
    $Params = $VnetConfig.Params | ConvertFrom-Json
    $Vnet = Get-AzVirtualNetwork -Name $VnetConfig.Name -ResourceGroupName $VnetConfig.ResourceGroupName
    $Vnet.DhcpOptions.DnsServers = $Params.DNSServer
    Set-AzVirtualNetwork -VirtualNetwork $Vnet
}

Write-Host "Done!"