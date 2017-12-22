#Returns an array of VM objects that require maintenance
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
            #if ($vmDetails.MaintenanceRedeployStatus)
            #{
                $details = @{
                    rgName = $rg.ResourceGroupName                         
                    vmName = $vmDetails.Name              
                }                           
                $maintenanceList += New-Object PSObject -Property $details       
            #}
          }
    }
    Write-Output $maintenanceList
}

Get-MaitenanceList -subscriptionId "5aec60e9-f535-4bd7-a951-2833f043e918" -resoruceGroup "sql-db-vnet-serice-endpoints-rg" -Verbose