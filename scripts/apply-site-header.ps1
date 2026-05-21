$root = Split-Path -Parent $PSScriptRoot
$src = Join-Path $root 'ai-development-services.html'
$utf8 = New-Object System.Text.UTF8Encoding $false
$lines = [System.IO.File]::ReadAllLines($src, $utf8)

$startIdx = -1
$endIdx = -1
for ($i = 0; $i -lt $lines.Length; $i++) {
  if ($lines[$i] -match '<!-- Main Header-->') { $startIdx = $i; break }
}
for ($i = $startIdx; $i -lt $lines.Length; $i++) {
  if ($lines[$i] -match '<!--End Main Header -->') { $endIdx = $i; break }
}
if ($startIdx -lt 0 -or $endIdx -lt 0) { throw 'Header markers not found' }

$header = ($lines[$startIdx..$endIdx] -join "`n")
$headerDev = $header
$navIndustries = "`n								<li><a href=`"ai-industries.html`">Industries</a></li>"
if ($headerDev -notmatch 'ai-industries\.html') {
  $headerDev = $headerDev -replace '(<li><a href="ai-staffing\.html">AI Staffing</a></li>)', "`$1$navIndustries"
  $header = $header -replace '(<li><a href="ai-staffing\.html">AI Staffing</a></li>)', "`$1$navIndustries"
}
$headerStaff = $header `
  -replace '<li><a href="ai-development-services.html" class="acesoft-nav-current-link">AI Development</a></li>', '<li><a href="ai-development-services.html">AI Development</a></li>' `
  -replace '<li><a href="ai-staffing.html">AI Staffing</a></li>', '<li><a href="ai-staffing.html" class="acesoft-nav-current-link">AI Staffing</a></li>'
$headerInd = $header `
  -replace '<li><a href="ai-development-services.html" class="acesoft-nav-current-link">AI Development</a></li>', '<li><a href="ai-development-services.html">AI Development</a></li>' `
  -replace '<li><a href="ai-staffing.html" class="acesoft-nav-current-link">AI Staffing</a></li>', '<li><a href="ai-staffing.html">AI Staffing</a></li>' `
  -replace '<li><a href="ai-staffing.html">AI Staffing</a></li>', '<li><a href="ai-staffing.html">AI Staffing</a></li>' `
  -replace '<li><a href="ai-industries.html">Industries</a></li>', '<li><a href="ai-industries.html" class="acesoft-nav-current-link">Industries</a></li>'

$includesDir = Join-Path $root 'includes'
if (-not (Test-Path $includesDir)) { New-Item -ItemType Directory -Path $includesDir | Out-Null }
[System.IO.File]::WriteAllText((Join-Path $includesDir 'site-header-development.html'), $headerDev, $utf8)
[System.IO.File]::WriteAllText((Join-Path $includesDir 'site-header-staffing.html'), $headerStaff, $utf8)
[System.IO.File]::WriteAllText((Join-Path $includesDir 'site-header-industries.html'), $headerInd, $utf8)

$devPages = @(
  'custom-ai-development-services.html','generative-ai-development.html','llm-development.html',
  'ai-agent-development.html','ai-chatbot-development.html','ai-automation-solutions.html',
  'machine-learning-development.html','ai-saas-product-development.html','enterprise-ai-development.html',
  'ai-integration-services.html','ai-mvp-development.html','ai-app-development.html'
)
$staffPages = @(
  'hire-ai-developers.html','dedicated-ai-development-team.html','ai-staff-augmentation-services.html',
  'offshore-ai-development-center.html','ai-outsourcing-company.html','remote-ai-engineers-for-hire.html'
)

function Set-PageHeader([string]$filePath, [string]$newHeader) {
  $content = [System.IO.File]::ReadAllText($filePath, $utf8)
  $pattern = '(?s)<header class="main-header header-style-one">.*?</header>'
  if ($content -notmatch $pattern) {
    Write-Warning "No header in $filePath"
    return
  }
  $updated = [regex]::Replace($content, $pattern, $newHeader.Trim())
  [System.IO.File]::WriteAllText($filePath, $updated, $utf8)
  Write-Host "Updated $filePath"
}

foreach ($p in $devPages) {
  Set-PageHeader (Join-Path $root $p) $headerDev
}
foreach ($p in $staffPages) {
  Set-PageHeader (Join-Path $root $p) $headerStaff
}
$industryPages = @(
  'ai-for-healthcare','ai-for-retail','ai-for-finance','ai-for-logistics','ai-for-manufacturing',
  'ai-for-real-estate','ai-for-ecommerce','ai-for-media-content','ai-for-asset-management',
  'ai-for-education','ai-for-insurance','ai-for-legal','ai-for-government',
  'ai-for-hospitality-travel','ai-for-agriculture','ai-for-telecommunications'
)
foreach ($p in $industryPages) {
  Set-PageHeader (Join-Path $root ($p + '.html')) $headerInd
}
Write-Host 'Done'
Write-Host 'Run scripts/apply-site-nav.ps1 to refresh navigation (Regions dropdown).'
