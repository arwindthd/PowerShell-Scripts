# Name: CrowdStrike Falcon EDR Detections Export Plugin

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

# Get alerts from CrowdStrike Falcon EDR with severity not equals to 'Informational'

Get-FalconAlert -Filter "data_domains:'Endpoint'+created_timestamp:>='2026-01-01'+created_timestamp:<='2026-01-04'+severity_name:!'Informational'+product:'epp'" -Detailed |
    Select-Object -Property `
        @{Name='Date'; Expression={[DateTime]::Parse($_.created_timestamp).ToString('dd/MM/yyyy')}},
        severity_name,
        display_name,
        filename,
        filepath,
        sha256,
        @{Name='Tactic'; Expression={$_.mitre_attack.tactic}},
        @{Name='Technique'; Expression={$_.mitre_attack.technique}},
        @{Name='Hostname'; Expression={$_.device.hostname}} |
    Sort-Object -Property created_timestamp -Descending|
    Export-FalconReport "C:\Temp\CrowdStrike Report Week $(Get-Date -UFormat %V).csv"
