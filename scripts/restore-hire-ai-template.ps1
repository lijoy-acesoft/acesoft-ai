# Rebuild hire-ai-developers.html staffing landing template (with SVC markers)
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false
$basePath = Join-Path $root 'custom-ai-development-services.html'
$src = Join-Path (Split-Path $root -Parent) 'hiredevelopers\hire-ai-developers.html'
$dest = Join-Path $root 'hire-ai-developers.html'
$headerPath = Join-Path $root 'includes\site-header-staffing.html'

if (-not (Test-Path $basePath)) { throw "Run restore-seo-landing-template.ps1 first" }

$html = [System.IO.File]::ReadAllText($src, $utf8)
$html = $html.Replace('hiredevelopers.com', 'aidevelopers.ca')
$html = $html.Replace('HireDevelopers.com', 'AI Developers.ca')
$html = $html.Replace('hire-pillar-extensions.css', 'ai-service-extensions.css')
if ($html -notmatch 'seo-landing-shell') {
  $html = $html.Replace('css/footer-component.css" rel="stylesheet" />', "css/footer-component.css`" rel=`"stylesheet`" />`n  <link href=`"css/seo-landing-shell.css`" rel=`"stylesheet`" />`n  <link href=`"css/ai-service-extensions.css`" rel=`"stylesheet`" />")
}

$header = [System.IO.File]::ReadAllText($headerPath, $utf8).Trim()
$html = [regex]::Replace($html, '(?s)<header class="main-header[^"]*">.*?</header>', $header, 1)

$html = $html.Replace(
  '<div class="hero-eyebrow">AI Developers.ca · US &amp; Canada · Acesoft Inc</div>',
  '<div class="hero-eyebrow"><!--SVC:EYEBROW-->Hire AI · AI Developers.ca · Acesoft Inc<!--/SVC:EYEBROW--></div>'
)
$html = $html.Replace(
  '<div class="hero-eyebrow">HireDevelopers.com · US &amp; Canada · Acesoft Inc</div>',
  '<div class="hero-eyebrow"><!--SVC:EYEBROW-->Hire AI · AI Developers.ca · Acesoft Inc<!--/SVC:EYEBROW--></div>'
)
$html = [regex]::Replace($html, '(?s)<h1>\s*Hire <em>AI Developers</em>.*?</h1>',
  '<h1><!--SVC:H1-->Hire <em>AI Developers</em><br>Who Ship in Production<!--/SVC:H1-->', 1)
$html = [regex]::Replace($html, '(?s)<p class="hero-lead">\s*Hire AI developers.*?</p>',
  '<p class="hero-lead"><!--SVC:INTRO-->Hire AI developers in Canada and the USA. Vetted ML engineers, LLM specialists, and MLOps experts through Acesoft-with flexible engagement and production-grade delivery.<!--/SVC:INTRO--></p>', 1)

$tags = @(
  '<span class="hero-tag">Hire AI talent</span>',
  '<span class="hero-tag">Vetted engineers</span>',
  '<span class="hero-tag">Canada and USA</span>',
  '<span class="hero-tag">Flexible engagement</span>'
) -join "`n          "
$html = [regex]::Replace($html, '(?s)<div class="hero-tags">.*?</div>', "<div class=`"hero-tags`">`n          $tags`n        </div>", 1)

$html = $html.Replace('<div class="s-label">Hire AI developers (US &amp; Canada)</div>', '<div class="s-label">Hire AI developers</div>')
$html = [regex]::Replace($html, '(?s)<p class="answer-lead"><strong>How much does it cost.*?</strong>.*?</p>',
  '<!--SVC:ANSWER--><p class="answer-lead"><strong>Why hire AI developers through Acesoft?</strong> You get vetted ML and LLM engineers who integrate with your stack, time zones, and security requirements-not generic resumes.<!--/SVC:ANSWER-->', 1)
$html = $html.Replace('<h2>Vetted AI talent for North American delivery</h2>', '<h2>AI engineers for product, data, and platform teams</h2>')
$html = [regex]::Replace($html, '(?s)<ul class="tick-list">.*?</ul>',
  @'
<ul class="tick-list">
                <li>Python, LLM, and MLOps engineers vetted for your stack.</li>
                <li>Flexible engagement: contract, dedicated, or team extension.</li>
                <li>Time-zone alignment for US and Canada collaboration.</li>
                <li>Structured onboarding and performance reviews.</li>
          </ul>
'@, 1)

# Cap cards (staffing labels)
$html = $html.Replace('<h5>Role matching</h5>', '<h5>Role matching</h5>')
if ($html -notmatch 'Role matching') {
  $html = [regex]::Replace($html, '<h5>[^<]+</h5>\s*<p>[^<]+</p>', '<h5>Role matching</h5><p>Profiles aligned to LLM, ML, data, and platform needs.</p>', 1)
  $html = [regex]::Replace($html, '<h5>[^<]+</h5>\s*<p>[^<]+</p>', '<h5>Fast onboarding</h5><p>Engineers integrated into your tools and ceremonies.</p>', 1)
  $html = [regex]::Replace($html, '<h5>[^<]+</h5>\s*<p>[^<]+</p>', '<h5>Scale up or down</h5><p>Add capacity as roadmap priorities shift.</p>', 1)
}

$html = [regex]::Replace($html, '(?s)<div class="faq-block reveal">.*?</div>\s*</div>\s*</section>',
  @'
<div class="faq-block reveal">
          <h3>Common questions</h3>
          <!--SVC:FAQ1--><div class="faq-item"><h4>How fast can you provide candidates?</h4><p>Many clients receive shortlisted profiles within a few business days after discovery.</p></div><!--/SVC:FAQ1-->
          <!--SVC:FAQ2--><div class="faq-item"><h4>Can engineers work in our time zone?</h4><p>Yes-we align overlap with US and Canada business hours and your collaboration tools.</p></div><!--/SVC:FAQ2-->
        </div>

        <div class="silo-strip reveal">
          <div class="silo-label">More AI staffing</div>
          <div class="silo-links">
            <a href="ai-staffing.html">All AI staffing services</a>
            <a href="dedicated-ai-development-team.html">Dedicated AI Team</a>
            <a href="ai-staff-augmentation-services.html">Staff Augmentation</a>
            <a href="offshore-ai-development-center.html">Offshore AI Center</a>
            <a href="page-contact.html">Contact</a>
          </div>
        </div>

        <div class="cta-panel reveal">
          <div class="cta-text">
            <h4><!--SVC:CTAT-->Ready to hire AI developers?<!--/SVC:CTAT--></h4>
            <p><!--SVC:CTAP-->Share roles, seniority, and timeline-we respond with matched profiles when it is a fit.<!--/SVC:CTAP--></p>
          </div>
          <div class="cta-btn-wrap">
            <a href="page-contact.html" class="btn-cta">Get started</a>
          </div>
        </div>
      </div>
    </section>
'@, 1)

$html = $html.Replace('class="acesoft-nav-current-link">AI Development', '">AI Development')
$html = $html.Replace('<li><a href="ai-staffing.html">AI Staffing</a></li>', '<li class="current"><a href="ai-staffing.html">AI Staffing</a></li>')

$footer = [System.IO.File]::ReadAllText((Join-Path $root 'footer.html'), $utf8).Trim()
$html = [regex]::Replace($html, '(?s)<footer class="main-footer[^"]*">.*?</footer>', "<div id=`"footer-root`">`n$footer`n</div>", 1)
$html = $html.Replace('<script src="js/hire-analytics.js" defer></script>', '')
$html = $html.Replace('<script src="js/hire-nav-dropdown.js" defer></script>', '')

[System.IO.File]::WriteAllText($dest, $html, $utf8)
Write-Host "Restored hire-ai-developers.html ($((Get-Item $dest).Length) bytes)"
