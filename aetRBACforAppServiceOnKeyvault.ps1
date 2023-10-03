#This script adds RBAC roles to a keyvault so App Service certificates can be stored in the keyvault

$TenantId = ""
$SubscriptionId = ""
$AzureServiceName = "Microsoft Azure App service"
$KeyVaultName = ""

# Login to your Azure account
Connect-AzAccount -SubscriptionId $SubscriptionId -Tenant $TenantId

# Select the subscription where the Key Vault resides
Select-AzSubscription -SubscriptionId $SubscriptionId

# Get the principal Id of the service
$principalId = (Get-AzADServicePrincipal -DisplayName $AzureServiceName).Id
$principalId

# Get the Key Vault
$keyVault = Get-AzKeyVault -VaultName $KeyVaultName
$keyVault

# Assign the 'Key Vault Secrets User' role to the service principal for the Key Vault
New-AzRoleAssignment -ObjectId $principalId -RoleDefinitionName 'Key Vault Secrets User' -Scope $keyVault.ResourceId

# Assign the 'Key Vault Reader' role to the service principal for the Key Vault
New-AzRoleAssignment -ObjectId $principalId -RoleDefinitionName 'Key Vault Reader' -Scope $keyVault.ResourceId