# Connect to azure
Connect-AzAccount

# Set the variables
$subscription = ""
$storageAccountName = ""
$resourceGroupName = ""
$containerName = ""

Set-AzContext -Subscription $subscription

$context = (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName).Context

# Get the blobs in the container
$blobs = Get-AzStorageBlob -Container $containerName -Context $context

# Get the current date
$currentDate = Get-Date

# Loop through each blob
foreach ($blob in $blobs) {
    # Get the blob's last modified date
    $lastModifiedDate = $blob.LastModified.UtcDateTime

    # Calculate the difference in days between the current date and the last modified date
    $daysOld = ($currentDate - $lastModifiedDate).Days

    # If the blob is older than 90 days, delete it
    if ($daysOld -gt 90) {
        Remove-AzStorageBlob -Container $containerName -Blob $blob.Name -Context $context
    }
}