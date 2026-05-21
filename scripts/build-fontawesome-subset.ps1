# Builds css/fontawesome-subset.css with only icons used across site HTML
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false
$faPath = Join-Path $root 'css\fontawesome.css'
$outPath = Join-Path $root 'css\fontawesome-subset.css'
$fa = [System.IO.File]::ReadAllText($faPath, $utf8)

$icons = New-Object System.Collections.Generic.HashSet[string]
Get-ChildItem $root -Filter '*.html' -File | ForEach-Object {
  $t = [System.IO.File]::ReadAllText($_.FullName, $utf8)
  foreach ($pat in @(
    'fa-brands\s+fa-([a-z0-9-]+)'
    'fa-solid\s+fa-([a-z0-9-]+)'
    'fa-regular\s+fa-([a-z0-9-]+)'
    'class="fa\s+fa-([a-z0-9-]+)'
    "class='fa\s+fa-([a-z0-9-]+)"
  )) {
    foreach ($m in [regex]::Matches($t, $pat)) { [void]$icons.Add($m.Groups[1].Value) }
  }
}

$baseRules = @'
/* Font Awesome subset — icons used on site */
.fa,.fas,.far,.fab,.fa-solid,.fa-regular,.fa-brands{
  display:inline-block;font-style:normal;font-variant:normal;line-height:1;text-rendering:auto;
  -webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale;
}
.fa::before,.fas::before,.far::before,.fab::before{display:inline-block}
.fa,.fas,.fa-solid{font-family:"Font Awesome 6 Pro";font-weight:900}
.far,.fa-regular{font-family:"Font Awesome 6 Pro";font-weight:400}
.fa-brands,.fab{font-family:"Font Awesome 6 Brands";font-weight:400}
'@

$fontFaces = New-Object System.Collections.Generic.List[string]
foreach ($m in [regex]::Matches($fa, '@font-face\s*\{[^}]+\}', 'Singleline')) {
  $block = $m.Value
  if ($block -match 'fa-solid-900|fa-brands-400') {
    $fontFaces.Add($block)
  }
}
if ($fontFaces.Count -lt 2) {
  throw "Expected solid + brands @font-face blocks in fontawesome.css (found $($fontFaces.Count))"
}

$legacyMap = @{
  'handshake-o' = 'handshake'
  'lightbulb-o' = 'lightbulb'
  'sun-o'       = 'sun'
}

$iconRules = New-Object System.Collections.Generic.List[string]
foreach ($name in ($icons | Sort-Object)) {
  $lookup = if ($legacyMap.ContainsKey($name)) { $legacyMap[$name] } else { $name }
  $escaped = [regex]::Escape($lookup)
  $rule = $null
  foreach ($pattern in @(
    '(?m)^\.fa-' + $escaped + '::before\s*\{[^}]+\}'
    '(?m)^\.fa-' + $escaped + ':before\s*\{[^}]+\}'
  )) {
    if ($fa -match $pattern) { $rule = $Matches[0]; break }
  }
  if ($rule) {
    [void]$iconRules.Add($rule)
    if ($lookup -ne $name) {
      [void]$iconRules.Add(($rule -replace "\.fa-$lookup", ".fa-$name"))
    }
    if ($name -eq 'whatsapp') {
      [void]$iconRules.Add('.fa-brands.fa-whatsapp::before{content:"\f232"}')
    }
  } else {
    Write-Warning "Icon rule not found: fa-$name (lookup fa-$lookup)"
  }
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine($baseRules)
[void]$sb.AppendLine(($fontFaces -join "`n`n"))
[void]$sb.AppendLine(($iconRules -join "`n"))
[System.IO.File]::WriteAllText($outPath, $sb.ToString(), $utf8)
Write-Host "Wrote $($icons.Count) icons + $($fontFaces.Count) font-faces to fontawesome-subset.css ($([math]::Round((Get-Item $outPath).Length/1KB,1)) KB)"
