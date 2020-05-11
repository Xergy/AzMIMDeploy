$DCConfigs = Import-Csv -Path ..\Naming.csv | Where-Object {$_.AzObjectType -eq "vm" -and $_.Name -like "*addc*" } | out-gridview -Title "Choose DC to Configure" -OutputMode Multiple
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

If ($DCConfigs -eq $Null) {Write-Host "Exiting - No Configuration..."; exit }

Write-Host "Shutting down VMs..."
Foreach ($DCConfig in $DCConfigs) {
    $DC = $DCConfig | get-AzVM
    $DC | Stop-AzVM -Force -ErrorAction SilentlyContinue -AsJob
}
Get-job | Wait-Job 
Get-Job | Receive-Job
Get-Job | Remove-Job 

Write-Host "Configuring VM Nics..."
Foreach ($DCConfig in $DCConfigs) {
    $SubscriptionID = $DCConfig.SubscriptionId
    If( (Get-AzContext).Subscription.Id -ne $SubscriptionID ) { Set-Azcontext -SubscriptionId $SubscriptionID | Out-Null}
    $Params = $DCConfig.Params | ConvertFrom-Json
    
    #Stop DC
    $DC = $DCConfig | get-AzVM
    $DC | Stop-AzVM -Force -ErrorAction SilentlyContinue

    $NicName = $DC.NetworkProfile[0].NetworkInterfaces.Id.tostring().split('/')[8]
    $Nic = Get-AzNetworkInterface -ResourceGroupName $DC.ResourceGroupName -Name $NicName
    $Nic.IpConfigurations[0].PrivateIpAddress = $Params.StaticIP
    $Nic.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
    Set-AzNetworkInterface -NetworkInterface $Nic     

    # Get the Nic of the DC
}

Write-Host "Starting VMs..."
Foreach ($DCConfig in $DCConfigs) {
    $DC = $DCConfig | get-AzVM
    $DC | Start-AzVM -ErrorAction SilentlyContinue -AsJob
}
Get-job | Wait-Job 
Get-Job | Receive-Job
Get-Job | Remove-Job 

Write-Host "Done!"

# $VMConfigs[0] | get-AzVM
# $Nic = Get-AzNetworkInterface -ResourceGroupName "el-prod-usva-mgmt-rg" -Name "elpmgmtaddc01-nic"
# $StaticIP = "10.103.13.100"
# $Nic.IpConfigurations[0].PrivateIpAddress = $StaticIP
# $Nic.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
# Set-AzNetworkInterface -NetworkInterface $Nic

