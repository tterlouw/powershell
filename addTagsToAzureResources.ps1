#Apply all tags from a resource group to its resources, and not keep existing tags on the resources
#This script has been taken from https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags
$rg = "addRG"

Set-AzurermResourceGroup -Name $rg -Tag @{ key="value"; key="value" }
$groups = Get-AzurermResourceGroup -Name $rg
foreach ($g in $groups)
{
    Get-AzurermResource -ResourceGroupName $g.ResourceGroupName | ForEach-Object {Set-AzurermResource -ResourceId $_.ResourceId -Tag $g.Tags -Force }
}

#Apply all tags from a resource group to its resources, and keep existing tags on resources that aren't duplicates
Set-AzResourceGroup -Name $rg -Tag @{ key="value"; key="value"; key="value" }
$group = Get-AzResourceGroup $rg
if ($null -ne $group.Tags) {
    $resources = Get-AzResource -ResourceGroupName $group.ResourceGroupName
    foreach ($r in $resources)
    {
        $resourcetags = (Get-AzResource -ResourceId $r.ResourceId).Tags
        if ($resourcetags)
        {
            foreach ($key in $group.Tags.Keys)
            {
                if (-not($resourcetags.ContainsKey($key)))
                {
                    $resourcetags.Add($key, $group.Tags[$key])
                }
            }
            Set-AzResource -Tag $resourcetags -ResourceId $r.ResourceId -Force
        }
        else
        {
            Set-AzResource -Tag $group.Tags -ResourceId $r.ResourceId -Force
        }
    }
}
