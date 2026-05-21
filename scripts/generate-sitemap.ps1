# Regenerates sitemap.xml with lastmod from file timestamps
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false
$base = 'https://www.aidevelopers.ca'
$skip = @('footer.html')
$priorityMap = @{
  'index.html' = '1.0'
  'ai-development-services.html' = '0.9'
  'ai-staffing.html' = '0.9'
  'ai-industries.html' = '0.9'
  'ai-consultation.html' = '0.9'
  'ai-development-canada.html' = '0.85'
  'ai-development-usa.html' = '0.85'
  'page-contact.html' = '0.8'
}

$urls = @()
Get-ChildItem $root -Filter '*.html' -File | Sort-Object { if ($_.Name -eq 'index.html') { '0' } else { $_.Name } } | ForEach-Object {
  if ($skip -contains $_.Name) { return }
  if ($_.Name -like 'site-header*') { return }
  $lastmod = $_.LastWriteTimeUtc.ToString('yyyy-MM-dd')
  $loc = if ($_.Name -eq 'index.html') { "$base/" } else { "$base/$($_.Name)" }
  $prio = if ($priorityMap.ContainsKey($_.Name)) { $priorityMap[$_.Name] } else { '0.7' }
  $urls += [pscustomobject]@{ Loc = $loc; Lastmod = $lastmod; Priority = $prio }
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
[void]$sb.AppendLine('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
foreach ($u in $urls) {
  [void]$sb.AppendLine('  <url>')
  [void]$sb.AppendLine("    <loc>$($u.Loc)</loc>")
  [void]$sb.AppendLine("    <lastmod>$($u.Lastmod)</lastmod>")
  [void]$sb.AppendLine("    <changefreq>weekly</changefreq>")
  [void]$sb.AppendLine("    <priority>$($u.Priority)</priority>")
  [void]$sb.AppendLine('  </url>')
}
[void]$sb.AppendLine('</urlset>')

$out = Join-Path $root 'sitemap.xml'
[System.IO.File]::WriteAllText($out, $sb.ToString(), $utf8)
Write-Host "Wrote $($urls.Count) URLs to sitemap.xml"
