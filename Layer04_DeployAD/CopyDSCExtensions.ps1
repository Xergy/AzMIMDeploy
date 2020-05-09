# Commands for pushing DSC Resource Modules to Target Nodes.
# Resources you want to push must be available on this Authoring Machine.

#Required DSC resource modules
$moduleNames = "XWebAdministration", "xSMBShare", "cNtfsAccessControl", "OctopusDSC", "PSDSCResources", "DSCR_Font"

#ServerList to push files to
$Servers = "C:\temp\serverList.txt"
$serverList = (get-content $Servers |
    Where { $_ -notlike ";*" } | #lines that start with ';' will be considered comments
    ForEach { $_ } |
    select -Unique `
)

foreach ($server in $serverList)
{
    $Session = New-PSSession -ComputerName $server

    $getDSCResources = Invoke-Command -Session $Session -ScriptBlock {
        Get-DscResource
    }

    foreach ($module in $moduleNames)
    {
        if ($getDSCResources.moduleName -notcontains $module){
            #3. Copy module to remote node.
            $Module_params = @{
                Path = (Get-Module $module -ListAvailable).ModuleBase
                Destination = "$env:SystemDrive\Program Files\WindowsPowerShell\Modules\$module"
                ToSession = $Session
                Force = $true
                Recurse = $true
                Verbose = $true

            }

            Copy-Item @Module_params
        }
    }
    Remove-PSSession -Id $Session.Id
}