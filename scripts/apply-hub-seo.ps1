# Hub SEO: remove keywords meta, align OG/Twitter with page title + description
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false

$hubMeta = @{
  'index.html' = @{
    canonical = 'https://www.aidevelopers.ca/'
    ogUrl = 'https://www.aidevelopers.ca/'
    title = 'AI Development Company in Canada | Enterprise AI Solutions | Acesoft'
    description = 'Acesoft is an AI development company in Canada delivering enterprise AI solutions, custom AI systems, automation, and machine learning services for scalable business growth.'
  }
  'ai-development-services.html' = @{
    title = 'AI Development Services | Custom Enterprise AI Solutions | Acesoft'
    description = 'Explore Acesoft AI development services for enterprises, including custom AI applications, LLM solutions, RAG systems, MLOps, and intelligent automation.'
  }
  'ai-staffing.html' = @{
    title = 'AI Staffing Services | Hire AI Engineers & ML Experts | Acesoft'
    description = 'Scale your team with Acesoft AI staffing services. Hire vetted AI engineers, ML specialists, data scientists, and MLOps experts for flexible delivery.'
  }
  'ai-consultation.html' = @{
    title = 'AI Consultation Services | AI Strategy, Discovery & Roadmaps | Acesoft'
    description = 'Get expert AI consultation from Acesoft. Define AI strategy, prioritize use cases, assess data readiness, and build an execution roadmap for measurable ROI.'
  }
  'ai-industries.html' = @{
    title = 'AI Solutions by Industry | Sector-Specific AI | Acesoft'
    description = 'Industry-specific AI solutions for healthcare, finance, retail, logistics, and more. Acesoft builds secure, production-ready AI for your sector in Canada and the USA.'
  }
  'ai-development-canada.html' = @{
    title = 'AI Development Canada | AI Consultants & Engineers | Acesoft'
    description = 'AI development and consulting across Canada—Toronto, Vancouver, Montreal, Calgary, Ottawa, and more. Custom AI systems, staffing, and enterprise delivery from Acesoft.'
  }
  'ai-development-usa.html' = @{
    title = 'AI Development USA | AI Consultants & Engineers | Acesoft'
    description = 'AI development and consulting across the USA—New York, San Francisco, Chicago, Boston, Austin, and more. Custom AI systems and enterprise delivery from Acesoft.'
  }
  'page-contact.html' = @{
    title = 'Contact Acesoft | AI Development Company in Canada'
    description = 'Contact Acesoft to discuss your AI development project in Canada, including custom AI solutions, machine learning systems, automation, and enterprise AI implementation.'
  }
}

$keywordsPattern = '(?s)\s*<meta name="keywords"[^>]*content="[^"]*">\s*'

foreach ($name in $hubMeta.Keys) {
  $path = Join-Path $root $name
  if (-not (Test-Path $path)) { continue }
  $m = $hubMeta[$name]
  $c = [System.IO.File]::ReadAllText($path, $utf8)

  $c = [regex]::Replace($c, $keywordsPattern, "`n", 1)

  if ($m.canonical) {
    $c = [regex]::Replace($c, '<link rel="canonical" href="[^"]*">', "<link rel=`"canonical`" href=`"$($m.canonical)`">", 1)
  }

  $pageUrl = if ($m.ogUrl) { $m.ogUrl } else { "https://www.aidevelopers.ca/$name" }

  $c = [regex]::Replace($c, '(?s)<meta property="og:title" content="[^"]*">', "<meta property=`"og:title`" content=`"$($m.title.Replace('"','&quot;'))`">", 1)
  $c = [regex]::Replace($c, '(?s)<meta property="og:description"\s*content="[^"]*">', "<meta property=`"og:description`" content=`"$($m.description.Replace('"','&quot;'))`">", 1)
  $c = [regex]::Replace($c, '<meta property="og:url" content="[^"]*">', "<meta property=`"og:url`" content=`"$pageUrl`">", 1)
  $c = [regex]::Replace($c, '(?s)<meta name="twitter:title" content="[^"]*">', "<meta name=`"twitter:title`" content=`"$($m.title.Replace('"','&quot;'))`">", 1)
  $c = [regex]::Replace($c, '(?s)<meta name="twitter:description"\s*content="[^"]*">', "<meta name=`"twitter:description`" content=`"$($m.description.Replace('"','&quot;'))`">", 1)

  [System.IO.File]::WriteAllText($path, $c, $utf8)
  Write-Host "SEO meta: $name"
}

Write-Host 'Hub SEO metadata updated.'
