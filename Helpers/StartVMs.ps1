
$VMs_All = Get-AzSubscription | Out-GridView -Title "Select Subs" -OutputMode Multiple | 
ForEach-Object { $_ | Set-AzContext | 
    ForEach-Object { Get-AzVM -Status } 
} 

$VMs_Filtered = $VMs_All | Out-GridView -Title "Select VMs to Start:" -OutputMode Multiple

If ($VMs_Filtered -eq $Null) {Write-Host "Exiting - No VMs..."; exit }

$Results = $VMs_Filtered | ForEach-Object {
    $SubscriptionID = $_.Id.tostring().split('/')[2]
    If( (Get-AzContext).Subscription.Id -ne $SubscriptionID ) { Set-Azcontext -SubscriptionId $SubscriptionID | Out-Null}
    $_ | Start-AzVM -AsJob -ErrorAction SilentlyContinue 
} 

Write-Host "Waiting on VMs to start..."
Get-Job | Wait-Job
Get-Job | Receive-Job
Get-Job | Remove-Job
Write-Host "Done!"
