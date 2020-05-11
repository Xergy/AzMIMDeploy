$VMConfigs = Import-Csv -Path ..\Naming.csv | Where-Object {$_.AzObjectType -eq "vm" } | out-gridview -Title "Choose VMs to join to the domain:" -OutputMode Multiple
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

If ($VMConfigs -eq $Null) {Write-Host "Exiting - No Configuration..."; exit }

$DomainJoinPassword = Read-Host "Enter domain Join password" 
$DomainJoinPassword

Foreach ($VMConfig in $VMConfigs) {
    $Params = $VMConfig.Params | ConvertFrom-Json

    $Settings = @{
        Name = "corp.contoso.local" 
        User = "corp\admin-azure"
        Restart = "$true"
        Options = 3
    }

    $ProtectedSettings = @{
        Password = $DomainJoinPassword 
    }

    Set-AzVMExtension -ResourceGroupName $VMConfig.ResourceGroupName `
        -Location $VMConfig.Location `
        -VMName $VMConfig.Name `
        -Name "DomainJoin-$($VMConfig.Name)" `
        -Publisher "Microsoft.Compute" `
        -TypeHandlerVersion "1.3" `
        -ExtensionType "JsonADDomainExtension" `
        -Settings $Settings `
        -ProtectedSettings $ProtectedSettings `
        -AsJob
}

# Get-AzVMAEMExtension -Name "DomainJoin-$($VMConfig.Name)" -ResourceGroupName $ResourceGroupName -VMName $VMConfig.Name -Status
# Get-job | remove-job

Write-Host "Waiting on VMs to join..."
Get-Job | Wait-Job
Get-Job | Receive-Job
Get-Job | Remove-Job

Write-Host "Join Status info..."
Foreach ($VMConfig in $VMConfigs) {
    Get-AzVMAEMExtension -Name "DomainJoin-$($VMConfig.Name)" -ResourceGroupName $VMConfig.ResourceGroupName -VMName $VMConfig.Name -Status
}

Write-Host "Done!"


