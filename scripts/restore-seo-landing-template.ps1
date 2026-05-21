# Rebuild custom-ai-development-services.html (marker template) from hire-java shell
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false
$src = Join-Path (Split-Path $root -Parent) 'hiredevelopers\hire-java-developers.html'
$dest = Join-Path $root 'custom-ai-development-services.html'
$headerPath = Join-Path $root 'includes\site-header-development.html'
$footerPath = Join-Path $root 'footer.html'

if (-not (Test-Path $src)) { throw "Missing template: $src" }

$html = [System.IO.File]::ReadAllText($src, $utf8)

# Paths and branding
$html = $html.Replace('hire-java-developers', 'custom-ai-development-services')
$html = $html.Replace('Hire Java Developers', 'Custom AI Development Services')
$html = $html.Replace('hiredevelopers.com', 'aidevelopers.ca')
$html = $html.Replace('HireDevelopers.com', 'AI Developers.ca')
$html = $html.Replace('HireDevelopers', 'AI Developers.ca')

# Meta
$html = $html.Replace(
  'Hire Java developers for enterprise applications, banking systems, APIs, backend platforms and large-scale software development.',
  'Custom AI development services in Canada. Acesoft builds secure, scalable AI systems for enterprises and startups.'
)
$html = $html.Replace(
  '<link rel="canonical" href="https://www.aidevelopers.ca/custom-ai-development-services.html">',
  '<link rel="canonical" href="https://www.aidevelopers.ca/custom-ai-development-services.html">'
)
if ($html -notmatch 'canonical') {
  $html = $html.Replace('</head>', "  <link rel=`"canonical`" href=`"https://www.aidevelopers.ca/custom-ai-development-services.html`" />`n</head>")
}

# CSS
$html = $html.Replace('hire-pillar-extensions.css', 'ai-service-extensions.css')
if ($html -notmatch 'seo-landing-shell\.css') {
  $html = $html.Replace(
    '<link href="css/footer-component.css" rel="stylesheet" />',
    "<link href=`"css/footer-component.css`" rel=`"stylesheet`" />`n  <link href=`"css/seo-landing-shell.css`" rel=`"stylesheet`" />`n  <link href=`"css/ai-service-extensions.css`" rel=`"stylesheet`" />"
  )
}

# Header
$header = [System.IO.File]::ReadAllText($headerPath, $utf8).Trim()
$html = [regex]::Replace($html, '(?s)<header class="main-header[^"]*">.*?</header>', $header, 1)

# Hero
$html = $html.Replace(
  '<div class="hero-eyebrow">Java · AI Developers.ca · Acesoft Inc</div>',
  '<div class="hero-eyebrow"><!--SVC:EYEBROW-->Custom AI · AI Developers.ca · Acesoft Inc<!--/SVC:EYEBROW--></div>'
)
$html = $html.Replace(
  '<div class="hero-eyebrow">Java · HireDevelopers.com · Acesoft Inc</div>',
  '<div class="hero-eyebrow"><!--SVC:EYEBROW-->Custom AI · AI Developers.ca · Acesoft Inc<!--/SVC:EYEBROW--></div>'
)
$html = [regex]::Replace($html, '(?s)<h1>\s*Hire <em>Java Developers</em>.*?</h1>',
  '<h1><!--SVC:H1-->Custom <em>AI Development Services</em><br>Built for Enterprise &amp; Growth<!--/SVC:H1-->', 1)
$html = [regex]::Replace($html, '(?s)<p class="hero-lead">\s*Hire Java developers.*?</p>',
  '<p class="hero-lead"><!--SVC:INTRO-->Acesoft designs and delivers custom AI solutions aligned with your domain, data estate, and compliance requirements-from discovery through production.<!--/SVC:INTRO--></p>', 1)

# Hero tags
$tags = @(
  '<span class="hero-tag">Custom AI</span>',
  '<span class="hero-tag">Enterprise ready</span>',
  '<span class="hero-tag">Canada &amp; USA</span>',
  '<span class="hero-tag">Secure delivery</span>'
) -join "`n          "
if ($html -match '<div class="hero-tags">') {
  $html = [regex]::Replace($html, '(?s)<div class="hero-tags">.*?</div>', "<div class=`"hero-tags`">`n          $tags`n        </div>", 1)
}

# Overview
$html = $html.Replace('<div class="s-label">Hire Java developers</div>', '<div class="s-label">Custom AI development</div>')
$html = $html.Replace(
  '<p class="answer-lead"><strong>Why hire Java developers for enterprise systems?</strong> AI Developers.ca matches vetted java developers through Acesoft-with Canadian-led delivery, clear scoping, and shortlists often within 24 hours after discovery.</p>',
  '<!--SVC:ANSWER--><p class="answer-lead"><strong>Why custom AI development?</strong> Off-the-shelf tools rarely fit regulated workflows, proprietary data, or product roadmaps. Acesoft builds AI that integrates with your stack and measurable KPIs.<!--/SVC:ANSWER-->'
)
$html = $html.Replace(
  '<p class="answer-lead"><strong>Why hire Java developers for enterprise systems?</strong> HireDevelopers.com matches vetted java developers through Acesoft-with Canadian-led delivery, clear scoping, and shortlists often within 24 hours after discovery.</p>',
  '<!--SVC:ANSWER--><p class="answer-lead"><strong>Why custom AI development?</strong> Off-the-shelf tools rarely fit regulated workflows, proprietary data, or product roadmaps. Acesoft builds AI that integrates with your stack and measurable KPIs.<!--/SVC:ANSWER-->'
)
$html = $html.Replace('<h2>Java talent for regulated, large-scale software</h2>', '<h2>Custom AI solutions for enterprise and growth-stage teams</h2>')
$html = $html.Replace('<li>Spring Boot, microservices, and enterprise integrations.</li>', '<li>Use-case discovery and ROI-focused roadmap.</li>')
$html = $html.Replace('<li>Banking, fintech, and line-of-business platforms.</li>', '<li>Secure architecture with governance and access controls.</li>')
$html = $html.Replace('<li>API design, security, and performance at scale.</li>', '<li>Integration with CRM, ERP, and internal tools.</li>')
$html = $html.Replace('<li>Structured vetting before you interview candidates.</li>', '<li>Continuous evaluation and model improvement.</li>')

# Capabilities
$html = $html.Replace('<div class="s-label" style="justify-content:center">Java project focus</div>', '<div class="s-label" style="justify-content:center"><!--SVC:FOCUS-->Custom AI capacity for product, data, and platform teams<!--/SVC:FOCUS--></div>')
$html = $html.Replace('<p>Practical java capacity for product teams-not generic bench staffing.</p>', '<p>End-to-end delivery from discovery through production MLOps.</p>')
$html = $html.Replace('<h5>Enterprise apps</h5>', '<h5>Solution design</h5>')
$html = $html.Replace('<p>Mission-critical systems with clear governance.</p>', '<p>Architecture and delivery plans aligned to your stack.</p>')
$html = $html.Replace('<h5>API &amp; integration</h5>', '<h5>Production build</h5>')
$html = $html.Replace('<p>Connect legacy and modern services safely.</p>', '<p>AI modules, APIs, and integrations ready to ship.</p>')
$html = $html.Replace('<h5>Team scale-up</h5>', '<h5>Operate &amp; improve</h5>')
$html = $html.Replace('<p>Add senior anchors before growing the pod.</p>', '<p>MLOps, monitoring, and handover for your team.</p>')

# FAQ + CTA markers
$html = [regex]::Replace($html, '(?s)<div class="faq-item">\s*<h4>Do Java developers.*?</h4>\s*<p>.*?</p>\s*</div>',
  '<!--SVC:FAQ1--><div class="faq-item"><h4>How long does a custom AI project take?</h4><p>Timelines depend on scope; many pilots launch in 8-12 weeks with a clear path to production.</p></div><!--/SVC:FAQ1-->', 1)
$html = [regex]::Replace($html, '(?s)<div class="faq-item">\s*<h4>Can we start with one senior Java engineer.*?</h4>\s*<p>.*?</p>\s*</div>',
  '<!--SVC:FAQ2--><div class="faq-item"><h4>Do you integrate with our existing systems?</h4><p>Yes-we connect AI to CRMs, ERPs, data warehouses, and custom apps via secure APIs.</p></div><!--/SVC:FAQ2-->', 1)
$html = $html.Replace('<h4>Ready to hire java developers?</h4>', '<!--SVC:CTAT-->Ready to build custom AI?<!--/SVC:CTAT-->')
$html = $html.Replace('<p>Share your stack, timeline, and team shape-we respond with a scoped path and matched profiles when it is a fit.</p>', '<!--SVC:CTAP-->Share your use case and constraints-we will respond with a practical discovery and delivery plan.<!--/SVC:CTAP-->')

# Silo strip
if ($html -notmatch 'silo-strip') {
  $silo = @"
        <div class="silo-strip reveal">
          <div class="silo-label">More AI services</div>
          <div class="silo-links">
            <a href="ai-development-services.html">All AI development services</a>
            <a href="generative-ai-development.html">Generative AI</a>
            <a href="llm-development.html">LLM Development</a>
            <a href="enterprise-ai-development.html">Enterprise AI</a>
            <a href="ai-mvp-development.html">AI MVP</a>
          </div>
        </div>

"@
  $html = $html.Replace('<div class="cta-panel reveal">', ($silo + '        <div class="cta-panel reveal">'))
}

# Nav highlight
$html = $html.Replace('class="acesoft-nav-current-link">AI Staffing', '">AI Staffing')
$html = $html.Replace('<li><a href="ai-development-services.html">AI Development</a></li>',
  '<li><a href="ai-development-services.html" class="acesoft-nav-current-link">AI Development</a></li>')

# Footer
$footer = [System.IO.File]::ReadAllText($footerPath, $utf8).Trim()
$footerBlock = "<div id=`"footer-root`">`n$footer`n</div>"
$html = [regex]::Replace($html, '(?s)<footer class="main-footer[^"]*">.*?</footer>', $footerBlock, 1)

# Drop hire-only scripts
$html = $html.Replace('<script src="js/hire-analytics.js" defer></script>', '')
$html = $html.Replace('<script src="js/hire-nav-dropdown.js" defer></script>', '')

[System.IO.File]::WriteAllText($dest, $html, $utf8)
Write-Host "Restored template: custom-ai-development-services.html ($((Get-Item $dest).Length) bytes)"
