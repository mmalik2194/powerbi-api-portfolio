param([Parameter(Mandatory=$true)][string]$SiteUrl,[Parameter(Mandatory=$true)][string]$ClientId)
$ErrorActionPreference='Stop'
# Run in PowerShell 7 with PnP.PowerShell installed. Use your tenant-approved Entra application client ID.
Connect-PnPOnline -Url $SiteUrl -Interactive -ClientId $ClientId
foreach($list in @('Airports','Inspections')) {
 if (-not (Get-PnPList -Identity $list -ErrorAction SilentlyContinue)) {New-PnPList -Title $list -Template GenericList | Out-Null}
}
$spec=@{
 Airports=@{AirportName='Text';AirportType='Text';Country='Text';Region='Text';Municipality='Text';Latitude='Number';Longitude='Number';ScheduledService='Text'}
 Inspections=@{AirportIdent='Text';Priority='Text';Status='Text';DueAt='DateTime';OwnerEmail='Text';IssueDescription='Note';ResolutionNotes='Note';LastReminderDate='Text'}
}
foreach($list in $spec.Keys) {
 foreach($name in $spec[$list].Keys) {
  if(-not (Get-PnPField -List $list -Identity $name -ErrorAction SilentlyContinue)) {Add-PnPField -List $list -DisplayName $name -InternalName $name -Type $spec[$list][$name] -AddToDefaultView | Out-Null}
 }
}
foreach($name in @('AirportIdent','Status','DueAt')) {Set-PnPField -List Inspections -Identity $name -Values @{Indexed=$true} | Out-Null}
Set-PnPField -List Airports -Identity Title -Values @{Indexed=$true;EnforceUniqueValues=$true} | Out-Null
# Idempotent asset import only. Synthetic inspection requests are intentionally not submitted automatically.
$assets=Import-Csv (Join-Path $PSScriptRoot 'data/Airports_import.csv')
$existing=@{};Get-PnPListItem -List Airports -PageSize 500 | ForEach-Object {$existing[$_.FieldValues.Title]=$true}
foreach($a in $assets) {
 if(-not $existing.ContainsKey($a.Title)) {
  Add-PnPListItem -List Airports -Values @{Title=$a.Title;AirportName=$a.AirportName;AirportType=$a.AirportType;Country=$a.Country;Region=$a.Region;Municipality=$a.Municipality;Latitude=[double]::Parse($a.Latitude,[cultureinfo]::InvariantCulture);Longitude=[double]::Parse($a.Longitude,[cultureinfo]::InvariantCulture);ScheduledService=$a.ScheduledService} | Out-Null
 }
}
Write-Host 'Lists provisioned and public airport assets imported. Create demo inspections through the app.'
