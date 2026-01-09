# Name: CrowdStrike Falcon EDR Get-DeviceControlPolicyMember

Import-Module ImportExcel
$filePath = "*.xlsx"
$worksheetName = ''
$excelData = Import-Excel -Path $filePath -WorksheetName $worksheetName
$columnValues = $excelData | Select-Object -ExpandProperty 'Host Name'

# Get valid OAuth2 access token in order to make requests to the CrowdStrike Flacon APIs.
Request-FalconToken -ClientId '' -ClientSecret ''

# Verify whether you have an active OAuth2 access token cached.
Write-Information "Verifying CrowdStrike OAuth2 access token." -InformationAction Continue

$AccessToken = Test-FalconToken

if ($null -ne $AccessToken -and $AccessToken.Token -eq $true) {
    Write-Information "Access token is valid." -InformationAction Continue
} else {
    Write-Warning "Access token is invalid or could not be verified."

    # Dump details for troubleshooting
    Write-Verbose ("Token check result: " + ($AccessToken | ConvertTo-Json -Depth 4))
}

$falconHostname = Get-FalconDeviceControlPolicyMember -Id <id> -Detailed | Select-Object -ExpandProperty hostname

Write-Host "Below are the endpoints with USB Full Access:"
Compare-Object $columnValues $falconHostname -IncludeEqual |
    Where-Object SideIndicator -eq '==' |
    Select-Object -ExpandProperty InputObject
