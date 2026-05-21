# Homepage performance: externalize inline CSS, defer JS, image hints
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false
$indexPath = Join-Path $root 'index.html'
$html = [System.IO.File]::ReadAllText($indexPath, $utf8)

# 1) Externalize large inline <style> block (second style in head)
$html = [regex]::Replace(
  $html,
  '(?s)\t<style>\s*\.flag-icon\s*\{.*?</style>(?=\s*</head>)',
  @"
	<link rel="preload" href="images/logo-2.png" as="image" type="image/png" fetchpriority="high">
	<link rel="preload" href="css/purged-home/index-page.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
	<noscript><link rel="stylesheet" href="css/purged-home/index-page.css"></noscript>
"@,
  1
)

# 2) Remove keywords meta
$html = [regex]::Replace($html, '(?s)\s*<meta name="keywords"[^>]*>\s*', "`n", 1)

# 3) Logo / about image dimensions
$html = $html.Replace(
  '<a href="index.html"><img src="images/logo-2.png"',
  '<a href="index.html"><img src="images/logo-2.png" width="160" height="140" decoding="async" fetchpriority="high"'
)
$html = $html.Replace(
  '<a href="index.html" title="Acesoft - AI Development Company London Ontario"><img src="images/logo-2.png"',
  '<a href="index.html" title="Acesoft - AI Development Company London Ontario"><img src="images/logo-2.png" width="160" height="140" decoding="async"'
)
$html = $html.Replace(
  '<a href="index.html"><img src="images/logo.png"',
  '<a href="index.html"><img src="images/logo.png" width="160" height="140" decoding="async"'
)
$html = $html.Replace(
  '<img src="images/resource/about-6.jpg"',
  '<img src="images/resource/about-6.jpg" width="494" height="494" loading="lazy" decoding="async"'
)
$html = $html.Replace(
  '<img src="images/resource/about-7.jpg"',
  '<img src="images/resource/about-7.jpg" width="308" height="309" loading="lazy" decoding="async"'
)

# 4) Remove Revolution Slider (unused on homepage)
$html = [regex]::Replace(
  $html,
  '(?s)\s*<!--Revolution Slider-->\s*<script src="plugins/revolution/[^<]+</script>\s*)+<!--Revolution Slider-->\s*',
  "`n",
  1
)
$html = [regex]::Replace($html, '\s*<script src="js/main-slider-script\.js"></script>\s*', "`n", 1)

# 5) Homepage JS: only jQuery + script.js (defer). Drop unused carousel/lightbox plugins.
$unusedJs = @(
  'js/popper.min.js',
  'js/bootstrap.min.js',
  'js/jquery.fancybox.js',
  'js/wow.js',
  'js/appear.js',
  'js/knob.js',
  'js/select2.min.js',
  'js/owl.js',
  'https://unpkg.com/three@0.160.0/build/three.min.js'
)
foreach ($src in $unusedJs) {
  $escaped = [regex]::Escape($src)
  $html = [regex]::Replace($html, '\s*<script(?:\s+defer)?\s+src="' + $escaped + '"[^>]*></script>\s*', "`n", 1)
}
$html = [regex]::Replace($html, '<script src="js/jquery.js"></script>', '<script defer src="js/jquery.js"></script>', 1)
$html = [regex]::Replace($html, '<script src="js/script.js"></script>', '<script defer src="js/script.js"></script>', 1)

# 6) WOW.js replaced by CSS in index-page.css (skip re-adding wow.js)

# 7) Refresh perf head critical inline from css/critical.css + top-header
$critical = [System.IO.File]::ReadAllText((Join-Path $root 'css\critical.css'), $utf8).Trim()
$topHeader = [System.IO.File]::ReadAllText((Join-Path $root 'css\top-header-bar.css'), $utf8).Trim()
$criticalInline = ($critical + "`n" + $topHeader) -replace '(?m)^\s*', '' -replace '(?m)\s+$', ''
$html = [regex]::Replace(
  $html,
  '(?s)(<!-- Performance: critical CSS[^\n]*\n.*?<style>).*?(</style>)',
  "`$1`n$criticalInline`n`$2",
  1
)

# 8) Homepage CSS bundle lives in perf block (css/purged-home/*); run npm run build:index-css after editing css/index-page.css

[System.IO.File]::WriteAllText($indexPath, $html, $utf8)
Write-Host "Optimized index.html ($((Get-Item $indexPath).Length) bytes)"
