$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

$rg = "[RESOURCEGROUP]"
$storageAccountName = "[STORAGEACCOUNTNAME]"
$SubscriptionId = "[SUBSCRIPTIONID]"
$TenantId = "[TENANTID]"

Select-AzureRmSubscription -SubscriptionId $SubscriptionId -TenantId $TenantId -verbose

#$storageaccount = Get-AzureRmStorageAccount -ResourceGroupName $rg -Name $storageAccountName
$storageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $storageAccountName).Value[0] 

$StorageContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey 

$container = (Get-AzureRmStorageContainer -ResourceGroupName $rg -StorageAccountName $storageAccountName).Name
$StatusColor = @{Stopped = ' bgcolor="Red">Stopped<';Running = ' bgcolor="Green">Running<';}
$webAppState = Get-AzureRmWebApp -ResourceGroupName $rg | Where-Object {$_.State} | select RepositorySiteName, State | ConvertTo-HTML -Fragment 
$StatusColor.Keys | foreach { $webAppState = $webAppState -replace ">$_<",($StatusColor.$_) }
$lastRunTime = Get-Date -verbose
$convertHTML = ConvertTo-HTML -head "Webapp state, last run: $lastRunTime" -Body "$webAppState" | Out-File .\index.html -Force 

Set-AzureStorageBlobContent -Container $container -File .\index.html -Blob index.html -Context $StorageContext -Properties @{"ContentType" = "text/html"} -Force