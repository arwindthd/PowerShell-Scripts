# RevokeSMBShareAccess is a PowerShell script that utilizes built-in PowerShell modules to revoke SMB Share Access for 'Everyone' object.

Get-SmbShare | ForEach-Object {
  $shareName = $_.Name

  # Find the share access to each and every SMB Share
  $access = Get-SmbShareAccess -Name $shareName

  # If a shared folder is accessible to 'Everyone', access for 'Everyone' will be revoked
  if ($access | Where-Object {$_.AccountName -eq 'Everyone' }) {
    Revoke-SmbShareAccess - Name $shareName -AccountName 'Everyone' -Confirm:$false
  }
}
