$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false
$badClose = '</' + 'motion>'
$goodClose = '</div>'
$badLabel = '<' + 'motion' + ' class="silo-label">'
$goodLabel = '<div class="silo-label">'
Get-ChildItem $root -Filter '*.html' | Where-Object { $_.Name -match '^ai-consult' -or $_.Name -eq 'ai-development-services.html' } | ForEach-Object {
  $c = [System.IO.File]::ReadAllText($_.FullName, $utf8)
  $c = $c.Replace($badClose, $goodClose)
  $c = $c.Replace($badLabel, $goodLabel)
  [System.IO.File]::WriteAllText($_.FullName, $c, $utf8)
  Write-Host "Fixed $($_.Name)"
}
