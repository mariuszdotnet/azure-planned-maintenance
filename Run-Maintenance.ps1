#Login-AzureRmAccount
#Get-AzureRmVM -ResourceGroupName update-wc-rg -Name myvm2 -Status

Restart-AzureRmVM -PerformMaintenance -Name $args[0] -ResourceGroupName $args[1]