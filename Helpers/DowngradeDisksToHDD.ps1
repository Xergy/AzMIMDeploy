
$Disks_All = Get-AzSubscription | Out-GridView -Title "Select Subs" -OutputMode Multiple | 
ForEach-Object { $_ | Set-AzContext | 
    ForEach-Object { Get-AzDisk } 
} 

$Disks = $Disks_All | Out-GridView -Title "Select VMs to shutdown" -OutputMode Multiple

# $Disks | select-object  Name,@{n="SkuName";e={$_.sku.name} }

If ($Disks -eq $Null) {Write-Host "Exiting - No VMs..."; exit }

# $Results = $Disks | ForEach-Object {
#     $SubscriptionID = $_.Id.tostring().split('/')[2]
#     If( (Get-AzContext).Subscription.Id -ne $SubscriptionID ) { Set-Azcontext -SubscriptionId $SubscriptionID | Out-Null}
#     $DiskUpdateConfig = New-AzDiskUpdateConfig -SkuName Standard_LRS
#     $_ | Update-AzDisk -DiskUpdate $DiskUpdateConfig 
# } 

$Disks | foreach-object {
    $MaxThreads = 25
    While (@(Get-Job | Where { $_.State -eq "Running" }).Count -ge $MaxThreads)
    {  Write-Host "Waiting for open thread...($MaxThreads Maximum)"
       Start-Sleep -Seconds 3
    }
    $CurrentDisk = $_  
    $Scriptblock = {
       param($Item) 
       $DiskUpdateConfig = New-AzDiskUpdateConfig -SkuName Standard_LRS
       # Possiable Values: Standard_LRS, Premium_LRS, StandardSSD_LRS, or UltraSSD_LRS
       $Item | Update-AzDisk -DiskUpdate $diskUpdateConfig
    }

    Start-Job -ScriptBlock $Scriptblock -ArgumentList $CurrentDisk
 }
  
 While (@(Get-Job | Where { $_.State -eq "Running" }).Count -ne 0)
 {  Write-Host "Waiting for background jobs..."
    Get-Job    #Just showing all the jobs
    Start-Sleep -Seconds 3
 }
  
 Get-Job       #Just showing all the jobs
 $Data = ForEach ($Job in (Get-Job)) {
    Receive-Job $Job
    Remove-Job $Job
 }
  
 $Data | Format-Table -AutoSize

 Write-Host "Doublecheck results, sometimes this has to be run more than once!"



