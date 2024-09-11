# PowerShell Script to Remove a User from the Administrators Group

# Remove remnants of deleted accounts or groups.
@(([ADSI]"WinNT://./Administrators").psbase.Invoke('Members')|% {$_.GetType().InvokeMember('AdsPath','GetProperty',$null,$($_),$null)}) -match '^WinNT'|%{$_.replace("WinNT://","")}|%{if($_ -match "S-1"){Remove-LocalGroupMember -Group "Administrators" -Member "$_"}}


# Get Username from Local Administrator group. It looks for PrincipalSource that matches "AzureAD".
$findUser = Get-LocalGroupMember -Name Administrators | Where-Object PrincipalSource -Match "AzureAD" | Select-Object Name

# Remove user from Administrator group.
Remove-LocalGroupMember -Group "Administrators" -Member $findUser
