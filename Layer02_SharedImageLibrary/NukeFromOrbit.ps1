$RGsToNuke = Get-AzResourceGroup | Out-GridView -OutputMode Multiple -Title "Multi-select RGs to remove - Choose wisely..."

Write-Host "`nThe following $($RGsToNuke.count) Resource Groups are staged for deletion:"
$RGsToNuke | select-object -Property ResourceGroupName,Location,ResourceId  | ft -AutoSize

Write-Host "`nType ""BreakGlass"" to remove these Resource Group, or Ctrl-C to Exit" -ForegroundColor Green
$HostInput = $Null
$HostInput = Read-Host "Final Answer" 
If ($HostInput -ne "BreakGlass" ) {
    Write-Host "Exiting..."
    exit
} 

# Start Timer
$elapsed = [System.Diagnostics.Stopwatch]::StartNew()

$Jobs = $RGsToNuke | Remove-AzResourceGroup -force -AsJob 

Write-Host "`n$(Get-Date -Format yyyy-MM-ddTHH.mm) Removing RGs, this could take a while, because it’s the only way to be sure... "

$Jobs | wait-job | Out-Null

$JobResults =  $Jobs | Receive-Job

Write-Host "`nResults:"
$JobResults

Write-Host "`n$(Get-Date -Format yyyy-MM-ddTHH.mm.ss) Done! Total Elapsed Time: $($elapsed.Elapsed.ToString())" 
$elapsed.Stop()
Write-Host "Done!!!"

# 1..3 | foreach-object {new-azresourcegroup -Name "TestRG$($_)" -Location EastUS }