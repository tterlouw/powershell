$dns = Get-AzureRmDnsRecordSet -Name "SETNAME" -RecordType CNAME -ResourceGroupName "DNS" -ZoneName "zone.com" | Where-Object -Property Records -Match "[prefix]"
$dnsname = $dns.records.cname

foreach ($item in $dnsname)
{
    $RecordSet = Get-AzureRmDnsRecordSet -Name $dns -RecordType CNAME -ResourceGroupName "DNS" -ZoneName "zone.com"

    foreach ($item2 in $dnsname)
    {
        Remove-AzureRmDnsRecordConfig -RecordSet $RecordSet -Cname $item2 | Set-AzureRmDnsRecordSet
    }
}