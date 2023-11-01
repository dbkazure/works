# This powershell script would check the DNS records for each domain in the hostlist and update output in a text.
# Please remember to update the paths for below variables.
$hostlist = "D:\scripts\dnsrecordcheck\domains.txt"
$outfile = "D:\scripts\DNSresults.txt"

#DNS records to check - Enter it as array elements
$records=@("A", "MX", "NS")

"##########################$(date)######################################`n" >> $outfile
foreach ($host_name in get-content "$hostlist")
{
">>>>>>>>>>>>>>>>>>>>>>>>>>>$host_name<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" >> $outfile
foreach ($record in $records)
{

$lookupresult = Resolve-DnsName -Name $host_name -Type $record | Format-Table -Autosize
$lookupresult >> $outfile
}
}
