#Create DNS Records

Add-DnsServerResourceRecordA -Name "mimportal" -IPv4Address "192.168.0.21" -ZoneName "corp.contoso.com"
Add-DnsServerResourceRecordA -Name "mimportal-a" -IPv4Address "192.168.0.21" -ZoneName "corp.contoso.com"
Add-DnsServerResourceRecordA -Name "mimportal-b" -IPv4Address "192.168.0.22" -ZoneName "corp.contoso.com"
Add-DnsServerResourceRecordA -Name "mimportal-s" -IPv4Address "192.168.0.27" -ZoneName "corp.contoso.com"

Add-DnsServerResourceRecordA -Name "mimspca-a" -IPv4Address "192.168.0.21" -ZoneName "corp.contoso.com"
Add-DnsServerResourceRecordA -Name "mimspca-b" -IPv4Address "192.168.0.22" -ZoneName "corp.contoso.com"
Add-DnsServerResourceRecordA -Name "mimspca-s" -IPv4Address "192.168.0.27" -ZoneName "corp.contoso.com"

Add-DnsServerResourceRecordA -Name "passwordreg" -IPv4Address "192.168.0.21" -ZoneName "corp.contoso.com"
Add-DnsServerResourceRecordA -Name "passwordreg-a" -IPv4Address "192.168.0.21" -ZoneName "corp.contoso.com"
Add-DnsServerResourceRecordA -Name "passwordreg-b" -IPv4Address "192.168.0.22" -ZoneName "corp.contoso.com"
Add-DnsServerResourceRecordA -Name "passwordreg-s" -IPv4Address "192.168.0.27" -ZoneName "corp.contoso.com"

Add-DnsServerResourceRecordA -Name "passwordreset" -IPv4Address "192.168.0.21" -ZoneName "corp.contoso.com"
Add-DnsServerResourceRecordA -Name "passwordreset-a" -IPv4Address "192.168.0.21" -ZoneName "corp.contoso.com"
Add-DnsServerResourceRecordA -Name "passwordreset-b" -IPv4Address "192.168.0.22" -ZoneName "corp.contoso.com"
Add-DnsServerResourceRecordA -Name "passwordreset-s" -IPv4Address "192.168.0.27" -ZoneName "corp.contoso.com"

Add-DnsServerResourceRecordA -Name "mimservice" -IPv4Address "192.168.0.25" -ZoneName "corp.contoso.com"
