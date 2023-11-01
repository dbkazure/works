# This script would check Email authenication records viz SPF, DKIM and DMARC are set for your email domain. 
# These records are essential for preventing email spoof and ensuring better email deliverability.

#Enter domain name to check
$domainName = "outlook.com"

# This can be any string from your SPF record. spf.protection.outlook.com is the SPF record for Office 365 domains.
# This typically can be you mail server IP or hostname, if you're not sure just put "v=spf1"
$spfSearchString = "v=spf1"

# Change this value if you already know the DKIM string or you want to search for specific one
$dkimSearchString = "v=DKIM1"
# Outlook.com uses selector1 as DKIM selector, you get find this by analyzing email header or contact your email administrator. 
$dkimSelector = "selector1"

# Update the below value if you would want to look for a specific string in your DMARC record.
$dmarcSearchString = "v=DMARC1"

#SPF check
$spfRecord = Resolve-DnsName -Name $domainName -Type "TXT" |  Select-String -Pattern "$spfSearchString" -InputObject {$_.strings}

#DKIM Check
$dkimRecord = Resolve-DnsName -name "$dkimSelector._domainkey.$domainName" -type "TXT" | Select-String -Pattern "$dkimSearchString" -InputObject {$_.strings}

#DMARC check
$dmarcRecord = Resolve-DnsName -name _dmarc.$domainName -type "TXT" | Select-String -Pattern "$dmarcSearchString" -InputObject {$_.strings}

if ($spfRecord -eq " ")
{
"SPF     : Not Set`n"
} else
{
 "SPF    : $spfRecord`n"
}

if ($dkimRecord -eq " ")
{
"DKIM   : Not Set`n"
} else
{
"DKIM   : $dkimRecord`n"
}

if ($dmarcRecord -eq " ")
{
"DMARC  : Not Set`n"
} else
{
"DMARC  : $dmarcRecord`n"
}





