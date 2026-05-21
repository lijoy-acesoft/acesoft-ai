$root = Split-Path -Parent $PSScriptRoot
$template = Join-Path $root 'hire-ai-developers.html'
if (-not (Test-Path $template)) {
  Copy-Item (Join-Path $root 'custom-ai-development-services.html') $template
}
$base = Get-Content $template -Raw -Encoding UTF8
$utf8 = New-Object System.Text.UTF8Encoding $false

function Set-Marker([string]$html, [string]$name, [string]$value) {
  $pattern = "(?s)<!--SVC:$name-->.*?<!--/SVC:$name-->"
  $replacement = "<!--SVC:$name-->$value<!--/SVC:$name-->"
  return [regex]::Replace($html, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $replacement })
}

$pages = @(
  @{ slug='dedicated-ai-development-team'; title='Dedicated AI Development Team'; short='Dedicated Team'; meta='Dedicated AI development team in Canada. Full AI pods for your product roadmap with Acesoft.'; intro='Get a dedicated AI development team focused on your backlog, architecture, and releases-with stable composition and clear accountability.'; h1='Dedicated <em>AI Development Team</em><br>Focused on Your Roadmap'; answer='<strong>Why a dedicated AI team?</strong> A stable pod learns your domain, stack, and standards-delivering faster with less context switching than rotating contractors.'; h2='A full AI pod aligned to your product goals'; b1='Team composition tailored to LLM, ML, or platform needs'; b2='Sprint cadence aligned to your product org'; b3='Canadian-led governance and communication'; b4='Long-term partnership with measurable KPIs'; focus='Product teams needing sustained AI delivery capacity.'; cap1t='Team design'; cap1p='Roles, seniority mix, and coverage model.'; cap2t='Delivery rhythm'; cap2p='Sprints, demos, and release alignment.'; cap3t='Governance'; cap3p='Security, access, and reporting.'; faq1q='How large can a dedicated team be?'; faq1a='We typically start with 3-8 engineers and scale based on roadmap and budget.'; faq2q='Can the team work in our tools?'; faq2a='Yes-Jira, GitHub, Slack, and your CI/CD are standard.'; ctat='Ready for a dedicated AI team?'; ctap='Share your roadmap and team shape-we will propose a pod structure.'; tags=@('Dedicated team','AI pod','Canada and USA','Long-term delivery') },
  @{ slug='ai-staff-augmentation-services'; title='AI Staff Augmentation Services'; short='Staff Augmentation'; meta='AI staff augmentation services Canada. Add AI engineers to your team quickly with Acesoft.'; intro='Augment your engineering org with AI specialists who join your ceremonies, tools, and culture-while Acesoft handles recruiting and employment.'; h1='AI <em>Staff Augmentation</em><br>Extend Your Team Fast'; answer='<strong>What is AI staff augmentation?</strong> You keep product ownership; we supply vetted AI engineers who embed in your workflows for a defined period or scope.'; h2='Flexible AI capacity without long hiring cycles'; b1='Rapid placement of ML, LLM, and data engineers'; b2='Engineers join your standups and code reviews'; b3='Scale hours up or down with notice'; b4='Replacement support if fit is not right'; focus='Teams that need extra hands on an active initiative.'; cap1t='Quick start'; cap1p='Profiles often within days of scoping.'; cap2t='Embedded work'; cap2p='Your repos, tickets, and standards.'; cap3t='Flexible terms'; cap3p='Monthly or milestone-based engagements.'; faq1q='How is this different from outsourcing?'; faq1a='You direct day-to-day work; we supply talent and employment overhead.'; faq2q='Minimum engagement length?'; faq2a='Many clients start with 3-6 months; shorter pilots are possible.'; ctat='Ready to augment your team?'; ctap='Tell us the skills and duration you need-we will share matching profiles.'; tags=@('Staff augmentation','Embed engineers','Canada and USA','Flexible scale') },
  @{ slug='offshore-ai-development-center'; title='Offshore AI Development Center'; short='Offshore AI Center'; meta='Offshore AI development center services. Scale AI delivery with governed offshore teams by Acesoft.'; intro='Establish an offshore AI development center with mature processes, security controls, and leadership-so you scale delivery without losing visibility.'; h1='Offshore <em>AI Development Center</em><br>Scale with Governance'; answer='<strong>Why an offshore AI center vs ad-hoc hiring?</strong> You get repeatable delivery, HR, facilities, and security baselines-not one-off contractor arrangements.'; h2='Offshore AI capacity with enterprise-grade oversight'; b1='Dedicated facility and leadership structure'; b2='ISO-aligned security and access practices'; b3='Multi-team scale for product and platform work'; b4='Cost efficiency with transparent reporting'; focus='Organizations scaling AI programs over multiple quarters.'; cap1t='Center setup'; cap1p='Teams, leads, and operating model.'; cap2t='Security'; cap2p='Access control, VPN, and audit support.'; cap3t='Scale'; cap3p='Add squads as demand grows.'; faq1q='Where are teams located?'; faq1a='We deliver from established offshore locations with Canada-led account management.'; faq2q='Can we visit or audit the center?'; faq2a='Yes-client visits and security reviews can be arranged.'; ctat='Ready to explore an AI center?'; ctap='Share scale targets and compliance needs-we will outline a center plan.'; tags=@('Offshore center','Scale delivery','ISO aligned','Cost efficiency') },
  @{ slug='ai-outsourcing-company'; title='AI Outsourcing Company'; short='AI Outsourcing'; meta='AI outsourcing company Canada. End-to-end AI project delivery and managed teams by Acesoft.'; intro='Partner with an AI outsourcing company that owns delivery outcomes-from discovery through production-while you focus on product strategy and customers.'; h1='AI <em>Outsourcing Company</em><br>End-to-End Delivery'; answer='<strong>When does AI outsourcing make sense?</strong> When you want a defined outcome with a partner accountable for delivery, not just individual contributors.'; h2='Outsourced AI programs with clear accountability'; b1='Fixed-scope or dedicated team models'; b2='Discovery, build, and handover options'; b3='SLAs on quality, timeline, and communication'; b4='Canadian account leadership'; focus='Leaders who want a partner to run AI delivery.'; cap1t='Engagement model'; cap1p='Scope, milestones, and acceptance criteria.'; cap2t='Delivery'; cap2p='Build, test, deploy, and document.'; cap3t='Transfer'; cap3p='Handover and optional ongoing support.'; faq1q='Do you outsource only AI or full stack?'; faq1a='We often deliver full-stack AI products including APIs, UI, and MLOps.'; faq2q='How is IP handled?'; faq2a='Work-for-hire and IP assignment are defined in the master agreement.'; ctat='Ready to outsource AI delivery?'; ctap='Describe the outcome you need-we will propose an outsourcing plan.'; tags=@('AI outsourcing','Managed delivery','Canada led','Full stack') },
  @{ slug='remote-ai-engineers-for-hire'; title='Remote AI Engineers for Hire'; short='Remote AI Engineers'; meta='Remote AI engineers for hire in Canada and USA. Hire remote ML and LLM talent with Acesoft.'; intro='Hire remote AI engineers who collaborate effectively across time zones with strong written communication and proven remote delivery experience.'; h1='Remote <em>AI Engineers</em><br>for Hire'; answer='<strong>Why hire remote AI engineers?</strong> Access broader talent pools while keeping collaboration windows aligned to North American business hours.'; h2='Remote AI talent built for distributed teams'; b1='US and Canada-friendly time zones'; b2='Strong async communication practices'; b3='Secure access via VPN and SSO'; b4='Overlap hours for pairing and reviews'; focus='Distributed product teams hiring remote AI specialists.'; cap1t='Remote-ready'; cap1p='Engineers experienced in distributed delivery.'; cap2t='Collaboration'; cap2p='Overlap scheduling and clear documentation.'; cap3t='Security'; cap3p='Managed devices and access policies.'; faq1q='What overlap do you guarantee?'; faq1a='Typically 4-6 hours overlap with Eastern time; we confirm per role.'; faq2q='Can engineers use our VPN?'; faq2a='Yes-client VPN, SSO, and equipment policies are supported.'; ctat='Ready to hire remote AI engineers?'; ctap='List roles and timezone needs-we will share remote-ready profiles.'; tags=@('Remote engineers','US Canada TZ','Distributed teams','Secure access') }
)

# Fix New-FaqItem - I accidentally left motion
function New-FaqItemFixed([string]$q, [string]$a) {
  return "<div class=`"faq-item`"><h4>$q</h4><p>$a</p></div>"
}

foreach ($p in $pages) {
  $html = $base
  $html = $html.Replace('hire-ai-developers', $p.slug)
  $html = $html.Replace('Hire AI Developers', $p.title)
  $html = $html.Replace('Hire AI developers in Canada and the USA. Vetted ML engineers, LLM specialists, and MLOps experts through Acesoft.', $p.meta)
  $html = Set-Marker $html 'EYEBROW' ($p.short + ' | AI Developers.ca | Acesoft Inc')
  $html = Set-Marker $html 'H1' $p.h1
  $html = Set-Marker $html 'INTRO' $p.intro
  $html = Set-Marker $html 'ANSWER' $p.answer
  $html = $html.Replace('AI engineers for product, data, and platform teams', $p.h2)
  $html = $html.Replace('Python, LLM, and MLOps engineers vetted for your stack.', ($p.b1 + '.'))
  $html = $html.Replace('Flexible engagement: contract, dedicated, or team extension.', ($p.b2 + '.'))
  $html = $html.Replace('Time-zone alignment for US and Canada collaboration.', ($p.b3 + '.'))
  $html = $html.Replace('Structured onboarding and performance reviews.', ($p.b4 + '.'))
  $html = Set-Marker $html 'FOCUS' $p.focus
  $html = $html.Replace('<h5>Role matching</h5>', ('<h5>' + $p.cap1t + '</h5>'))
  $html = $html.Replace('Profiles aligned to LLM, ML, data, and platform needs.', $p.cap1p)
  $html = $html.Replace('<h5>Fast onboarding</h5>', ('<h5>' + $p.cap2t + '</h5>'))
  $html = $html.Replace('Engineers integrated into your tools and ceremonies.', $p.cap2p)
  $html = $html.Replace('<h5>Scale up or down</h5>', ('<h5>' + $p.cap3t + '</h5>'))
  $html = $html.Replace('Add capacity as roadmap priorities shift.', $p.cap3p)
  $html = Set-Marker $html 'FAQ1' (New-FaqItemFixed $p.faq1q $p.faq1a)
  $html = Set-Marker $html 'FAQ2' (New-FaqItemFixed $p.faq2q $p.faq2a)
  $html = Set-Marker $html 'CTAT' $p.ctat
  $html = Set-Marker $html 'CTAP' $p.ctap
  $html = $html.Replace('Hire AI developers', ($p.short + ' services'))
  $tagHtml = ($p.tags | ForEach-Object { "<span class=`"hero-tag`">$_</span>" }) -join "`n          "
  $html = $html.Replace('<span class="hero-tag">Hire AI talent</span>
          <span class="hero-tag">Vetted engineers</span>
          <span class="hero-tag">Canada and USA</span>
          <span class="hero-tag">Flexible engagement</span>', $tagHtml)
  $html = $html -replace '(?s)<motion></motion>\s*<motion></motion>', '<div class="silo-label">More AI staffing</div>'
  $html = $html.Replace('ai-development-services.html">All AI development services', 'ai-staffing.html">All AI staffing services')
  $html = $html.Replace('<li class="current"><a href="ai-development-services.html">AI Development</a></li>
                <li><a href="ai-staffing.html">AI Staffing</a></li>', '<li><a href="ai-development-services.html">AI Development</a></li>
                <li class="current"><a href="ai-staffing.html">AI Staffing</a></li>')
  $out = Join-Path $root ($p.slug + '.html')
  [System.IO.File]::WriteAllText($out, $html, $utf8)
  Write-Host "Wrote $out"
}
Write-Host 'Done'
