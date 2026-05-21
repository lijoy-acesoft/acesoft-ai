# Updates main navigation with Regions dropdown (Canada / USA) on all pages with full header
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false

$canadaPages = @(
  'ai-development-canada.html','ai-consultant-london-ontario.html',
  'ai-consultants-toronto.html','ai-consultants-vancouver.html','ai-consultants-montreal.html',
  'ai-consultants-calgary.html','ai-consultants-ottawa.html','ai-consultants-kitchener-waterloo.html',
  'ai-consultants-windsor.html','ai-consultants-edmonton.html','ai-consultants-mississauga.html'
)
$usaPages = @(
  'ai-development-usa.html',
  'ai-consultants-new-york.html','ai-consultants-san-francisco.html','ai-consultants-los-angeles.html',
  'ai-consultants-chicago.html','ai-consultants-boston.html','ai-consultants-austin.html',
  'ai-consultants-seattle.html','ai-consultants-dallas.html','ai-consultants-atlanta.html',
  'ai-consultants-miami.html'
)
$staffPages = @(
  'ai-staffing.html','hire-ai-developers.html','dedicated-ai-development-team.html',
  'ai-staff-augmentation-services.html','offshore-ai-development-center.html',
  'ai-outsourcing-company.html','remote-ai-engineers-for-hire.html'
)
$industryPages = @(
  'ai-industries.html','ai-for-healthcare','ai-for-retail','ai-for-finance','ai-for-logistics',
  'ai-for-manufacturing','ai-for-real-estate','ai-for-ecommerce','ai-for-media-content',
  'ai-for-asset-management','ai-for-education','ai-for-insurance','ai-for-legal',
  'ai-for-government','ai-for-hospitality-travel','ai-for-agriculture','ai-for-telecommunications'
) | ForEach-Object { if ($_ -match '\.html$') { $_ } else { $_ + '.html' } }

function Get-ActiveMap([string]$fileName) {
  $m = @{
    home=$false; dev=$false; staff=$false; ind=$false
    regions=$false; canada=$false; usa=$false; consult=$false; contact=$false
  }
  switch -Regex ($fileName) {
    '^index\.html$' { $m.home=$true; break }
    '^page-contact\.html$' { $m.contact=$true; break }
    '^ai-consultation\.html$' { $m.consult=$true; break }
    '^ai-development-services\.html$' { $m.dev=$true; break }
    '^ai-staffing\.html$' { $m.staff=$true; break }
    '^ai-industries\.html$' { $m.ind=$true; break }
    '^ai-development-canada\.html$' { $m.regions=$true; $m.canada=$true; break }
    '^ai-development-usa\.html$' { $m.regions=$true; $m.usa=$true; break }
    default {
      if ($canadaPages -contains $fileName) { $m.regions=$true; $m.canada=$true }
      elseif ($usaPages -contains $fileName) { $m.regions=$true; $m.usa=$true }
      elseif ($staffPages -contains $fileName) { $m.staff=$true }
      elseif ($industryPages -contains $fileName) { $m.ind=$true }
      elseif ($fileName -match '^ai-for-') { $m.ind=$true }
      elseif ($fileName -match '^ai-consultants-' -or $fileName -match '^ai-consultant-') {
        $m.regions=$true
        if ($usaPages -contains $fileName) { $m.usa=$true } else { $m.canada=$true }
      }
      elseif ($fileName -match '^(custom-ai|generative-ai|llm-|ai-agent|ai-chatbot|ai-automation|machine-learning|ai-saas|enterprise-ai|ai-integration|ai-mvp|ai-app)') { $m.dev=$true }
      elseif ($fileName -match '^hire-ai|^dedicated-ai|^ai-staff-augmentation|^offshore-ai|^ai-outsourcing|^remote-ai') { $m.staff=$true }
      else { $m.dev=$true }
    }
  }
  return $m
}

function Link([hashtable]$m, [string]$key, [string]$href, [string]$label) {
  if ($m[$key]) { return "<li><a href=`"$href`" class=`"acesoft-nav-current-link`">$label</a></li>" }
  return "<li><a href=`"$href`">$label</a></li>"
}

function Get-NavigationHtml([hashtable]$m) {
  $dropClass = 'dropdown'
  if ($m.regions) { $dropClass = 'dropdown current' }
  $caCls = if ($m.canada) { ' class="acesoft-nav-current-link"' } else { '' }
  $usCls = if ($m.usa) { ' class="acesoft-nav-current-link"' } else { '' }
  $lines = @(
    '							<ul class="navigation">'
    ('								' + (Link $m 'home' 'index.html' 'Home').TrimStart())
    ('								' + (Link $m 'dev' 'ai-development-services.html' 'AI Development').TrimStart())
    ('								' + (Link $m 'staff' 'ai-staffing.html' 'AI Staffing').TrimStart())
    ('								' + (Link $m 'ind' 'ai-industries.html' 'Industries').TrimStart())
    "								<li class=`"$dropClass acesoft-regions-nav`">"
    '									<a href="ai-development-canada.html" class="acesoft-regions-toggle">Regions</a>'
    '									<ul class="acesoft-regions-menu">'
    "										<li><a href=`"ai-development-canada.html`"$caCls>AI Development Canada</a></li>"
    "										<li><a href=`"ai-development-usa.html`"$usCls>AI Development USA</a></li>"
    '									</ul>'
    '								</li>'
    ('								' + (Link $m 'consult' 'ai-consultation.html' 'AI Consultation').TrimStart())
    ('								' + (Link $m 'contact' 'page-contact.html' 'Get in Touch').TrimStart())
    '							</ul>'
  )
  return ($lines -join "`n")
}

$navPattern = '(?s)(<nav class="nav main-menu">\s*)<ul class="navigation">.*?</ul>\s*(?=</nav>)'

$files = Get-ChildItem $root -Filter '*.html' -File
$count = 0
foreach ($f in $files) {
  $c = [System.IO.File]::ReadAllText($f.FullName, $utf8)
  if ($c -notmatch '<nav class="nav main-menu">') { continue }
  $nav = Get-NavigationHtml (Get-ActiveMap $f.Name)
  $newC = [regex]::Replace($c, $navPattern, "`$1$nav", 1)
  if ($newC -eq $c) {
    Write-Warning "Nav not replaced: $($f.Name)"
    continue
  }
  [System.IO.File]::WriteAllText($f.FullName, $newC, $utf8)
  $count++
  Write-Host "Nav: $($f.Name)"
}
Write-Host "Updated navigation on $count files"
