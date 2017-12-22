
# The following PowerShell function takes your subscription ID and prints out a list of VMs that are scheduled for maintenance.
# Source: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/maintenance-notifications
function MaintenanceIterator
{
    Select-AzureRmSubscription -SubscriptionId $args[0]

    $rgList= Get-AzureRmResourceGroup 

    for ($rgIdx=0; $rgIdx -lt $rgList.Length ; $rgIdx++)
    {
        $rg = $rgList[$rgIdx]        
        $vmList = Get-AzureRMVM -ResourceGroupName $rg.ResourceGroupName 
        for ($vmIdx=0; $vmIdx -lt $vmList.Length ; $vmIdx++)
        {
            $vm = $vmList[$vmIdx]
            $vmDetails = Get-AzureRMVM -ResourceGroupName $rg.ResourceGroupName -Name $vm.Name -Status
            if ($vmDetails.MaintenanceRedeployStatus)
            {
                Write-Output "VM: $($vmDetails.Name)  IsCustomerInitiatedMaintenanceAllowed: $($vmDetails.MaintenanceRedeployStatus.IsCustomerInitiatedMaintenanceAllowed) $($vmDetails.MaintenanceRedeployStatus.LastOperationMessage)"               
            }
          }
    }
}

function Get-MaitenanceList
{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory)]    
    [string]$subscriptionId,
    [string]$resoruceGroup
    )
    
    $maintenanceList = @()

    $subscription = Select-AzureRmSubscription -SubscriptionId $subscriptionId
    Write-Verbose "Subscription $($subscription.Name) selected."
    
    if($resoruceGroup){
        $rgList = Get-AzureRmResourceGroup -Name $resoruceGroup
    }
    else{
        $rgList = Get-AzureRmResourceGroup
    }

    for ($rgIdx=0; $rgIdx -lt $rgList.Length ; $rgIdx++)
    {
        $rg = $rgList[$rgIdx]
        Write-Verbose "Resoruce Group $($rg.ResourceGroupName) selected."        
        $vmList = Get-AzureRMVM -ResourceGroupName $rg.ResourceGroupName 
        for ($vmIdx=0; $vmIdx -lt $vmList.Length ; $vmIdx++)
        {
            $vm = $vmList[$vmIdx]
            $vmDetails = Get-AzureRMVM -ResourceGroupName $rg.ResourceGroupName -Name $vm.Name -Status
            if ($vmDetails.MaintenanceRedeployStatus)
            {
                $details = @{
                    rgName = $rg.ResourceGroupName                         
                    vmName = $vmDetails.Name              
                }                           
                $maintenanceList += New-Object PSObject -Property $details       
            }
          }
    }
    Write-Output $maintenanceList
}

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

