# Applies footer.html to all public pages (footer-root hubs + landing page footers)
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false
$footerPath = Join-Path $root 'footer.html'
$footer = [System.IO.File]::ReadAllText($footerPath, $utf8).Trim()
$footerBlock = "<div id=`"footer-root`">`n$footer`n</div>"

$footerRootPattern = '(?s)<div id="footer-root">.*?(?=\s*</div>\s*(?:<!--\s*(?:End\s+)?Page\s+Wrapper|</div>\s*(?:</div>\s*)?<div class="scroll-to-top"))'
$landingFooterPattern = '(?s)<footer class="main-footer[^"]*">.*?</footer>'

$skip = @('footer.html')
$count = 0

Get-ChildItem $root -Filter '*.html' -File | ForEach-Object {
  if ($skip -contains $_.Name) { return }
  $c = [System.IO.File]::ReadAllText($_.FullName, $utf8)
  $newC = $c

  if ($c -match 'id="footer-root"') {
    $newC = [regex]::Replace($c, $footerRootPattern, $footerBlock, 1)
  }
  elseif ($c -match '<footer class="main-footer') {
    $newC = [regex]::Replace($c, $landingFooterPattern, $footerBlock, 1)
  }
  else {
    return
  }

  if ($newC -eq $c) {
    Write-Warning "Footer not replaced: $($_.Name)"
    return
  }
  [System.IO.File]::WriteAllText($_.FullName, $newC, $utf8)
  $count++
  Write-Host "Footer: $($_.Name)"
}

Write-Host "Updated footer on $count files"
