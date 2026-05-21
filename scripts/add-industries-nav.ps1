$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false
$insert = "`n								<li><a href=`"ai-industries.html`">Industries</a></li>"
$files = Get-ChildItem $root -Filter '*.html' -File | Where-Object { $_.Name -notmatch '^ai-for-' -and $_.Name -ne 'ai-industries.html' }
foreach ($f in $files) {
  $c = [System.IO.File]::ReadAllText($f.FullName, $utf8)
  if ($c -notmatch 'ai-industries\.html' -and $c -match 'ai-staffing\.html">AI Staffing') {
    $c = $c -replace '(<li><a href="ai-staffing\.html"[^>]*>AI Staffing</a></li>)', "`$1$insert"
    [System.IO.File]::WriteAllText($f.FullName, $c, $utf8)
    Write-Host "Nav updated: $($f.Name)"
  }
}
# Refresh header includes from ai-development-services
$src = Join-Path $root 'ai-development-services.html'
$lines = [System.IO.File]::ReadAllLines($src, $utf8)
$startIdx = ($lines | Select-String -Pattern '<!-- Main Header-->' | Select-Object -First 1).LineNumber - 1
$endIdx = ($lines | Select-String -Pattern '<!--End Main Header -->' | Select-Object -First 1).LineNumber - 1
$header = ($lines[$startIdx..$endIdx] -join "`n")
$headerDev = $header
$headerStaff = $header `
  -replace '<li><a href="ai-development-services.html" class="acesoft-nav-current-link">AI Development</a></li>', '<li><a href="ai-development-services.html">AI Development</a></li>' `
  -replace '<li><a href="ai-staffing.html">AI Staffing</a></li>', '<li><a href="ai-staffing.html" class="acesoft-nav-current-link">AI Staffing</a></li>'
$headerInd = $header `
  -replace '<li><a href="ai-development-services.html" class="acesoft-nav-current-link">AI Development</a></li>', '<li><a href="ai-development-services.html">AI Development</a></li>' `
  -replace '<li><a href="ai-staffing.html">AI Staffing</a></li>', '<li><a href="ai-staffing.html">AI Staffing</a></li>' `
  -replace '<li><a href="ai-industries.html">Industries</a></li>', '<li><a href="ai-industries.html" class="acesoft-nav-current-link">Industries</a></li>'
$includesDir = Join-Path $root 'includes'
[System.IO.File]::WriteAllText((Join-Path $includesDir 'site-header-development.html'), $headerDev, $utf8)
[System.IO.File]::WriteAllText((Join-Path $includesDir 'site-header-staffing.html'), $headerStaff, $utf8)
[System.IO.File]::WriteAllText((Join-Path $includesDir 'site-header-industries.html'), $headerInd, $utf8)
Write-Host 'Header includes refreshed'
