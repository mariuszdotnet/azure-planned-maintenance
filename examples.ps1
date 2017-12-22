# Export all VMs for maintenance in a specific RG and subsription
$myList = Get-MaitenanceList -subscriptionId "5aec60e9-f535-4bd7-a951-2833f043e918" -resoruceGroup "sql-db-vnet-serice-endpoints-rg" -Verbose
$myList | export-csv -Path "C:\git\test.csv" -NoTypeInformation

# OR

# Export all VMs for maintenance in a subsription
$myList = Get-MaitenanceList -subscriptionId "5aec60e9-f535-4bd7-a951-2833f043e918" -Verbose
$myList | export-csv -Path "C:\git\test.csv" -NoTypeInformation

# Run Maintenance on all VMs in a CSV file
Start-MaintenanceCSV -csvFilePath "C:\git\test.csv" -Verbose