
#Create MIM Accounts
 
import-module activedirectory
$sp = ConvertTo-SecureString 'Pa$$w0rd' –asplaintext –force
 
New-ADUser –SamAccountName MIMAdmin –name MIMAdmin
Set-ADAccountPassword –identity MIMAdmin –NewPassword $sp
Set-ADUser –identity MIMAdmin –Enabled 1 –PasswordNeverExpires 1

New-ADUser –SamAccountName MIMMA –name MIMMA
Set-ADAccountPassword –identity MIMMA –NewPassword $sp
Set-ADUser –identity MIMMA –Enabled 1 –PasswordNeverExpires 1

New-ADUser –SamAccountName MIMPassword –name MIMPassword
Set-ADAccountPassword –identity MIMPassword –NewPassword $sp
Set-ADUser –identity MIMPassword –Enabled 1 –PasswordNeverExpires 1

New-ADUser –SamAccountName MIMService –name MIMService
Set-ADAccountPassword –identity MIMService –NewPassword $sp
Set-ADUser –identity MIMService –Enabled 1 –PasswordNeverExpires 1

New-ADUser –SamAccountName MIMSPAppPool –name MIMSPAppPool
Set-ADAccountPassword –identity MIMSPAppPool –NewPassword $sp
Set-ADUser –identity MIMSPAppPool –Enabled 1 –PasswordNeverExpires 1

New-ADUser –SamAccountName MIMSPFarm –name MIMSPFarm
Set-ADAccountPassword –identity MIMSPFarm –NewPassword $sp
Set-ADUser –identity MIMSPFarm –Enabled 1 –PasswordNeverExpires 1

New-ADUser –SamAccountName MIMSync –name MIMSync
Set-ADAccountPassword –identity MIMSync –NewPassword $sp
Set-ADUser –identity MIMSync –Enabled 1 –PasswordNeverExpires 1

New-ADUser –SamAccountName MIMADMA –name MIMADMA
Set-ADAccountPassword –identity MIMADMA –NewPassword $sp
Set-ADUser –identity MIMADMA –Enabled 1 –PasswordNeverExpires 1

#Create Groups

New-ADGroup –name MIMSyncAdmins –GroupCategory Security –GroupScope Global –SamAccountName MIMSyncAdmins
New-ADGroup –name MIMSyncOperators –GroupCategory Security –GroupScope Global –SamAccountName MIMSyncOperators
New-ADGroup –name MIMSyncJoiners –GroupCategory Security –GroupScope Global –SamAccountName MIMSyncJoiners
New-ADGroup –name MIMSyncBrowse –GroupCategory Security –GroupScope Global –SamAccountName MIMSyncBrowse
New-ADGroup –name MIMSyncPasswordSet –GroupCategory Security –GroupScope Global –SamAccountName MIMSyncPasswordSet

Add-ADGroupMember -identity MIMSyncAdmins -Members MIMAdmin
Add-ADGroupmember -identity MIMSyncAdmins -Members MIMService
Add-ADGroupmember -identity MIMSyncBrowse -Members MIMService
Add-ADGroupmember -identity MIMSyncPasswordSet -Members MIMService

# MIMPassword SPNs
setspn -S HTTP/passwordreg CORP\MIMPassword
setspn -S HTTP/passwordreg.corp.contoso.com CORP\MIMPassword
setspn -S HTTP/passwordreg-a CORP\MIMPassword
setspn -S HTTP/passwordreg-a.corp.contoso.com CORP\MIMPassword
setspn -S HTTP/passwordreg-b CORP\MIMPassword
setspn -S HTTP/passwordreg-b.corp.contoso.com CORP\MIMPassword
setspn -S HTTP/passwordreg-s CORP\MIMPassword
setspn -S HTTP/passwordreg-s.corp.contoso.com CORP\MIMPassword

setspn -S HTTP/passwordreset CORP\MIMPassword
setspn -S HTTP/passwordreset.corp.contoso.com CORP\MIMPassword
setspn -S HTTP/passwordreset-a CORP\MIMPassword
setspn -S HTTP/passwordreset-a.corp.contoso.com CORP\MIMPassword
setspn -S HTTP/passwordreset-b CORP\MIMPassword
setspn -S HTTP/passwordreset-b.corp.contoso.com CORP\MIMPassword
setspn -S HTTP/passwordreset-s CORP\MIMPassword
setspn -S HTTP/passwordreset-s.corp.contoso.com CORP\MIMPassword

# MIMSPAppPool SPNs
setspn -S HTTP/mimportal CORP\MIMSPAppPool
setspn -S HTTP/mimportal.corp.contoso.com CORP\MIMSPAppPool
setspn -S HTTP/mimportal-a CORP\MIMSPAppPool
setspn -S HTTP/mimportal-a.corp.contoso.com CORP\MIMSPAppPool
setspn -S HTTP/mimportal-b CORP\MIMSPAppPool
setspn -S HTTP/mimportal-b.corp.contoso.com CORP\MIMSPAppPool
setspn -S HTTP/mimportal-s CORP\MIMSPAppPool
setspn -S HTTP/mimportal-s.corp.contoso.com CORP\MIMSPAppPool

setspn -S HTTP/mimspcs-a CORP\MIMSPAppPool
setspn -S HTTP/mimspcs-a.corp.contoso.com CORP\MIMSPAppPool
setspn -S HTTP/mimspcs-b CORP\MIMSPAppPool
setspn -S HTTP/mimspcs-b.corp.contoso.com CORP\MIMSPAppPool
setspn -S HTTP/mimspcs-s CORP\MIMSPAppPool
setspn -S HTTP/mimspcs-s.corp.contoso.com CORP\MIMSPAppPool

# MIM Service SPNs
setspn -S FIMService/mimservice.corp.contoso.com CORP\MIMService

# Set Allow to Delegate to only "FIMService"
$user = Get-ADObject -LDAPFilter "(&(objectCategory=person)(sAMAccountName=MIMService))"
Set-ADObject $user.DistinguishedName -Add @{"msDS-AllowedToDelegateTo" = "FIMService/mimservice.corp.contoso.com"}

$user = Get-ADObject -LDAPFilter "(&(objectCategory=person)(sAMAccountName=MIMSPAppPool))"
Set-ADObject $user.DistinguishedName -Add @{"msDS-AllowedToDelegateTo" = "FIMService/mimservice.corp.contoso.com"}

