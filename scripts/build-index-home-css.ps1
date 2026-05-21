# Homepage-only CSS: purge against index.html, minify, output css/purged-home/
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$cssDir = Join-Path $root 'css'
$outDir = Join-Path $cssDir 'purged-home'
$indexHtml = Join-Path $root 'index.html'

if (-not (Test-Path $indexHtml)) { throw "Missing $indexHtml" }

if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

Push-Location $cssDir
try {
  npx purgecss --css style.css bootstrap.min.css responsive.css footer-component.css linear.css flaticon.css tm-bs-mp.css tm-utility-classes.css index-page.css --content $indexHtml --output purged-home --safelist fixed-header slideInDown animated mobile-menu-visible moblie-search-active is-regions-open acesoft-wa-prompt-hidden loaded
  Get-ChildItem (Join-Path $outDir '*.css') | ForEach-Object {
    npx cleancss -O1 --output $_.FullName $_.FullName | Out-Null
  }
  # Purged output lives in css/purged-home/ — fix relative urls (../ → ../../)
  Get-ChildItem (Join-Path $outDir '*.css') | ForEach-Object {
    $text = [System.IO.File]::ReadAllText($_.FullName)
    $text = $text -replace "url\((['""]?)\.\./fonts/", 'url($1../../fonts/'
    $text = $text -replace "url\((['""]?)\.\./images/", 'url($1../../images/'
    # Missing theme assets — avoid 404 console noise on homepage
    $text = $text.Replace('url(../../images/icons/shape.png)', 'none')
    $text = $text.Replace('url(../../images/icons/pattern-9.jpg)', 'none')
    [System.IO.File]::WriteAllText($_.FullName, $text)
  }
}
finally {
  Pop-Location
}

Get-ChildItem $outDir -Filter '*.css' | ForEach-Object {
  Write-Host ("  {0,-28} {1,6:N1} KiB" -f $_.Name, ($_.Length / 1KB))
}
Write-Host "Homepage CSS built in css/purged-home/"
