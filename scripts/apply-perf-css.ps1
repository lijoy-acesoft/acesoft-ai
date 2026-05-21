# Optimized CSS: purged bundles, FA subset, page-specific optional assets
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false

$critical = [System.IO.File]::ReadAllText((Join-Path $root 'css\critical.css'), $utf8).Trim()
$topHeader = [System.IO.File]::ReadAllText((Join-Path $root 'css\top-header-bar.css'), $utf8).Trim()
$criticalInline = ($critical + "`n" + $topHeader) -replace '(?m)^\s*', '' -replace '(?m)\s+$', ''

$fontUrl = 'https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap'

# Purged CSS (run: npm run build:css)
$coreCss = @(
  'css/purged/bootstrap.min.css'
  'css/purged/style.css'
  'css/purged/responsive.css'
  'css/footer-component.css'
  'css/purged/linear.css'
  'css/fontawesome-subset.css'
  'css/purged/flaticon.css'
  'css/purged/tm-bs-mp.css'
  'css/purged/tm-utility-classes.css'
)

# Homepage: index-only purge + minify (npm run build:index-css) — no animate.css (WOW uses index-page keyframes)
$indexHomeCss = @(
  'css/purged-home/bootstrap.min.css'
  'css/purged-home/style.css'
  'css/purged-home/responsive.css'
  'css/purged-home/footer-component.css'
  'css/purged-home/linear.css'
  'css/fontawesome-subset.css'
  'css/purged-home/flaticon.css'
  'css/purged-home/tm-bs-mp.css'
  'css/purged-home/tm-utility-classes.css'
  'css/purged-home/index-page.css'
)

$optionalCss = @{
  owl = 'css/purged/owl.css'
  fancybox = 'css/purged/jquery.fancybox.min.css'
}

$hubPages = @(
  'index.html', 'page-contact.html', 'ai-development-services.html', 'ai-staffing.html',
  'ai-consultation.html', 'ai-industries.html', 'ai-development-canada.html', 'ai-development-usa.html'
)
$serviceLanding = @(
  'ai-development-canada.html', 'ai-development-usa.html', 'ai-industries.html',
  'ai-development-services.html', 'ai-staffing.html', 'ai-consultation.html'
)

function Get-DeferLink([string]$href) {
  @"
  <link rel="preload" href="$href" as="style" onload="this.onload=null;this.rel='stylesheet'">
  <noscript><link rel="stylesheet" href="$href"></noscript>
"@
}

function Get-PageCssList([string]$fileName) {
  if ($fileName -eq 'index.html') {
    return [string[]]$indexHomeCss
  }
  $list = [System.Collections.Generic.List[string]]::new()
  foreach ($c in $coreCss) { [void]$list.Add([string]$c) }
  if ($serviceLanding -contains $fileName) {
    $list.Add('css/seo-service-landing.css')
  }
  if ($fileName -eq 'index.html' -or $fileName -eq 'page-contact.html') {
    return $list
  }
  if ($fileName -match '^ai-for-' -or $fileName -in @(
    'custom-ai-development-services.html', 'generative-ai-development.html', 'llm-development.html',
    'ai-agent-development.html', 'ai-chatbot-development.html', 'ai-automation-solutions.html',
    'machine-learning-development.html', 'ai-saas-product-development.html', 'enterprise-ai-development.html',
    'ai-integration-services.html', 'ai-mvp-development.html', 'ai-app-development.html',
    'hire-ai-developers.html', 'dedicated-ai-development-team.html', 'ai-staff-augmentation-services.html',
    'offshore-ai-development-center.html', 'ai-outsourcing-company.html', 'remote-ai-engineers-for-hire.html'
  )) {
    $list.Add('css/seo-landing-shell.css')
    $list.Add('css/ai-service-extensions.css')
  }
  if ($fileName -match '^ai-consultants-' -or $fileName -eq 'ai-consultant-london-ontario.html') {
    if (-not $list.Contains('css/seo-landing-shell.css')) { $list.Add('css/seo-landing-shell.css') }
  }
  return $list
}

function Build-PerfHead([string]$fileName) {
  $pageCss = Get-PageCssList $fileName
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.AppendLine('  <!-- Performance: critical CSS + purged deferred stylesheets -->')
  [void]$sb.AppendLine('  <link rel="preconnect" href="https://fonts.googleapis.com">')
  [void]$sb.AppendLine('  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>')
  [void]$sb.AppendLine('  <style>')
  [void]$sb.AppendLine($criticalInline)
  [void]$sb.AppendLine('  </style>')
  [void]$sb.AppendLine('  <script src="js/loadcss-polyfill.js"></script>')
  foreach ($href in $pageCss) {
    if (-not (Test-Path (Join-Path $root ($href -replace '/', '\')))) {
      Write-Warning "Missing CSS: $href - run npm run build:css"
    }
    [void]$sb.AppendLine((Get-DeferLink $href))
  }
  [void]$sb.AppendLine((Get-DeferLink $fontUrl))
  return $sb.ToString().TrimEnd()
}

# Only replace an existing perf block, or a bounded legacy stylesheet block (never the whole <head>)
$perfBlockPattern = '(?s)<!--\s*Performance:[^\n]*\n.*?(?=<link rel="shortcut icon"|<link rel="icon"|<meta )'
$legacyCssPattern = '(?s)(?:<!--\s*Stylesheets\s*-->\s*)?(?:<link href="css/[^"]+\.css"[^>]*>\s*){2,12}(?=<link rel="shortcut icon"|<link rel="icon")'

$skip = @('footer.html')
$count = 0
$minBytes = 8000

Get-ChildItem $root -Filter '*.html' -File | ForEach-Object {
  if ($skip -contains $_.Name) { return }
  if ($_.Length -lt $minBytes) {
    Write-Warning "Skip (too small): $($_.Name) - restore HTML first"
    return
  }
  $c = [System.IO.File]::ReadAllText($_.FullName, $utf8)
  if ($c -notmatch '<head') { return }

  $perfHead = Build-PerfHead $_.Name
  $newC = $c

  if ($c -match $perfBlockPattern) {
    $newC = [regex]::Replace($c, $perfBlockPattern, "$perfHead`n", 1)
  }
  elseif ($c -match $legacyCssPattern) {
    $newC = [regex]::Replace($c, $legacyCssPattern, "$perfHead`n", 1)
  }
  else {
    Write-Warning "No safe CSS anchor: $($_.Name)"
    return
  }

  if ($newC.Length -lt ($c.Length * 0.25)) {
    Write-Error "Refusing to write $($_.Name): replacement removed too much content"
    return
  }

  try {
    [System.IO.File]::WriteAllText($_.FullName, $newC, $utf8)
    $count++
    Write-Host "Perf CSS: $($_.Name)"
  } catch {
    Write-Warning "Write failed: $($_.Name) - $($_.Exception.Message)"
  }
}

Write-Host "Updated $count pages. Run npm run build:css after HTML or CSS changes."
