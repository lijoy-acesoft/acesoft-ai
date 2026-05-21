$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false
$badOpen = [string]([char]60) + 'motion' + ' class="silo-links">'
$goodOpen = [string]([char]60) + 'motion' + ' class="silo-links">'
$goodOpen = '<' + 'div' + ' class="silo-links">'
Get-ChildItem (Join-Path $root 'ai-for-*.html') | ForEach-Object {
  $c = [System.IO.File]::ReadAllText($_.FullName, $utf8)
  $c = $c.Replace('href="ai-development-services.html" href="ai-development-services.html"', 'href="ai-development-services.html"')
  if ($c.Contains($badOpen)) { $c = $c.Replace($badOpen, $goodOpen) }
  [System.IO.File]::WriteAllText($_.FullName, $c, $utf8)
  Write-Host "Fixed $($_.Name)"
}
