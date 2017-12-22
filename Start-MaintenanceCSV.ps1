function Start-MaintenanceCSV{

    [CmdletBinding()]
    param(
    [Parameter(Mandatory)]    
    [string]$csvFilePath
    )
    
    $maintenanceList = Import-Csv -Path $csvFilePath

    foreach($item in $maintenanceList){
       $result = Restart-AzureRmVM -PerformMaintenance -Name $item.vmName -ResourceGroupName $item.rgName
       Write-Verbose $result
    }
}

#Start-MaintenanceCSV -csvFilePath "C:\git\test.csv" -Verbose