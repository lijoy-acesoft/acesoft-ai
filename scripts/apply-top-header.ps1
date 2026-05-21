# Applies shared top-header bar HTML + CSS link to all pages with main header
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false
$topHeaderPath = Join-Path $root 'includes\top-header-bar.html'
$topHeader = [System.IO.File]::ReadAllText($topHeaderPath, $utf8).TrimEnd()

$headerPattern = '(?s)<div class="header-top[^"]*">.*?(?=\s*<div class="container-fluid")'
$cssLink = '<link href="css/top-header-bar.css" rel="stylesheet" />'
$cssPattern = 'top-header-bar\.css'

$inlineHeaderCssPattern = '(?s)\s*\.header-top \{[^}]*\}.*?(?=\s*\.acesoft-hero|\s*\.service-hero|\s*\.contact-page-shell|\s*/\*  HERO|\s*/\* HERO|\s*\.main-header \.header-lower|\s*\.header-lower)'

$skip = @('footer.html')
$count = 0

Get-ChildItem $root -Filter '*.html' -File | ForEach-Object {
  if ($skip -contains $_.Name) { return }
  if ($_.DirectoryName -match '\\includes$') { return }

  $path = $_.FullName
  $c = [System.IO.File]::ReadAllText($path, $utf8)
  if ($c -notmatch 'class="header-top') { return }

  $newC = $c

  if ($newC -match $headerPattern) {
    $newC = [regex]::Replace($newC, $headerPattern, $topHeader, 1)
  } else {
    Write-Warning "header-top block not found: $($_.Name)"
    return
  }

  if ($newC -notmatch $cssPattern) {
    if ($newC -match 'footer-component\.css') {
      $newC = $newC -replace '(footer-component\.css" rel="stylesheet"[^>]*>)', "`$1`n  $cssLink"
    } elseif ($newC -match 'ai-service-extensions\.css') {
      $newC = $newC -replace '(ai-service-extensions\.css" rel="stylesheet"[^>]*>)', "`$1`n  $cssLink"
    } else {
      $newC = $newC -replace '(<link href="css/style\.css" rel="stylesheet"[^>]*>)', "`$1`n  $cssLink"
    }
  }

  if ($newC -match '\.header-top \.top-left \.list-style-one') {
    $newC = [regex]::Replace($newC, $inlineHeaderCssPattern, "`n", 1)
  }

  $legacyHeaderRules = '(?s)\s*\.header-top \.inner-container \{\s*min-height: 40px;\s*padding: 0 12px;\s*gap: 8px;\s*\}\s*\.header-top \.top-left \.list-style-one li:nth-child\(4\) \{\s*display: none;\s*\}\s*\.header-top \.top-left \.list-style-one li \{\s*height: 28px;\s*font-size: 10px;\s*padding: 0 8px;\s*\}\s*\.header-top \.top-right \.useful-links li a \{\s*height: 28px;\s*font-size: 10px;\s*padding: 0 10px;\s*\}\s*\.header-top \.top-left \{ overflow: hidden; \}'
  $legacyHeaderRules500 = '(?s)\s*\.header-top \.top-left \.list-style-one li:nth-child\(2\),\s*\.header-top \.top-left \.list-style-one li:nth-child\(3\) \{\s*display: none;\s*\}'
  if ($newC -match 'header-top \.top-left \.list-style-one') {
    $newC = [regex]::Replace($newC, $legacyHeaderRules, "`n", 1)
    $newC = [regex]::Replace($newC, $legacyHeaderRules500, "`n", 1)
  }

  if ($newC -eq $c) {
    Write-Warning "No changes: $($_.Name)"
    return
  }

  [System.IO.File]::WriteAllText($path, $newC, $utf8)
  $count++
  Write-Host "Top header: $($_.Name)"
}

Write-Host "Updated top header on $count files."
