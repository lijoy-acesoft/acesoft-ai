$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false

$services = @(
  @{ slug="custom-ai-development-services"; title="Custom AI Development Services"; icon="fa-cogs"; cardDesc="Bespoke AI platforms, copilots, and intelligent features tailored to your business workflows and data."; meta="Custom AI development services in Canada. Acesoft builds secure, scalable AI systems for enterprises and startups."; intro="Acesoft designs and delivers custom AI solutions aligned with your domain, data estate, and compliance requirements. From discovery through production, we build AI that fits your product and operations."; benefits=@("Use-case discovery and ROI-focused roadmap","Secure architecture with governance and access controls","Integration with CRM, ERP, and internal tools","Continuous evaluation and model improvement"); deliverables=@("Solution architecture and delivery plan","Production-ready AI modules and APIs","Documentation and handover for your team","MLOps hooks for monitoring and retraining") },
  @{ slug="generative-ai-development"; title="Generative AI Development"; icon="fa-magic"; cardDesc="GPT-class applications, content engines, and generative workflows with guardrails and enterprise controls."; meta="Generative AI development company in Canada. Build secure GenAI apps, copilots, and content automation with Acesoft."; intro="We help organizations adopt generative AI responsibly with prompts, RAG pipelines, and application layers that deliver value while managing cost, quality, and risk."; benefits=@("Model selection aligned to use case and budget","Prompt engineering and evaluation frameworks","Content and workflow automation at scale","Policy guardrails and human review loops"); deliverables=@("GenAI application or feature release","Prompt libraries and evaluation suites","Integration with your data and auth","Operational playbooks for your team") },
  @{ slug="llm-development"; title="LLM Development"; icon="fa-comments"; cardDesc="Large language model apps, fine-tuning, RAG, and production LLM orchestration for enterprise products."; meta="LLM development services in Canada. Custom LLM apps, RAG, fine-tuning, and enterprise deployment by Acesoft."; intro="Our LLM engineering team builds production-grade language model experiences combining retrieval, tool use, and observability so assistants stay accurate and maintainable."; benefits=@("RAG and vector search implementation","Multi-model routing and fallback strategies","Latency and cost optimization","Hallucination reduction and quality metrics"); deliverables=@("LLM-powered product features","Vector index and ingestion pipelines","API and SDK integration layers","Monitoring dashboards and eval harnesses") },
  @{ slug="ai-agent-development"; title="AI Agent Development"; icon="fa-android"; cardDesc="Autonomous and semi-autonomous agents that execute multi-step tasks with tools, APIs, and human oversight."; meta="AI agent development in Canada. Build workflow agents, tool-using copilots, and enterprise automation with Acesoft."; intro="We design AI agents that plan, call tools, and complete business processes with clear boundaries, audit trails, and approval steps where risk requires human control."; benefits=@("Agent workflow design and orchestration","Secure tool and API integrations","Error handling and escalation paths","Testing for edge cases and failure modes"); deliverables=@("Deployed agent workflows","Tool connectors and permission model","Run logs and observability","Operator documentation") },
  @{ slug="ai-chatbot-development"; title="AI Chatbot Development"; icon="fa-comment"; cardDesc="Conversational AI for support, sales, and internal knowledge with branded UX and measurable outcomes."; meta="AI chatbot development company Canada. Enterprise chatbots, support bots, and knowledge assistants by Acesoft."; intro="We build chatbots that understand context, cite sources, and integrate with your knowledge base to improve deflection, response time, and customer satisfaction."; benefits=@("Conversation design and intent mapping","Knowledge base and RAG integration","Handoff to live agents when needed","Analytics on resolution and satisfaction"); deliverables=@("Branded chat widget or embedded UI","Admin console for content updates","CRM or ticketing integrations","Quality and usage reporting") },
  @{ slug="ai-automation-solutions"; title="AI Automation Solutions"; icon="fa-bolt"; cardDesc="Intelligent process automation combining rules, ML, and LLMs to reduce manual work across operations."; meta="AI automation solutions in Canada. Intelligent workflow automation and process AI by Acesoft."; intro="Combine traditional automation with AI to classify documents, extract data, route requests, and trigger actions."; benefits=@("Process mapping and automation ROI analysis","Document and email intelligence","Integration with existing BPM tools","Measurable time and cost savings"); deliverables=@("Automated workflow implementations","Exception handling and dashboards","SOP updates and training materials","Phase-2 expansion roadmap") },
  @{ slug="machine-learning-development"; title="Machine Learning Development"; icon="fa-line-chart"; cardDesc="Predictive models, forecasting, classification, and ML pipelines built for reliability at scale."; meta="Machine learning development services Canada. Custom ML models, pipelines, and MLOps by Acesoft."; intro="From feature engineering to model deployment, we deliver machine learning that performs in production with reproducible training and drift monitoring."; benefits=@("Problem framing and baseline models","Feature stores and training pipelines","Model validation and bias review","Deployment to cloud or on-prem"); deliverables=@("Trained models and inference APIs","Training and inference pipelines","Model cards and documentation","Monitoring and retraining plan") },
  @{ slug="ai-saas-product-development"; title="AI SaaS Product Development"; icon="fa-cloud"; cardDesc="End-to-end AI-native SaaS products with multi-tenant architecture, billing, and scalable AI backends."; meta="AI SaaS product development Canada. Build and launch AI-powered SaaS platforms with Acesoft."; intro="We partner with founders and product teams to ship AI SaaS from MVP through scale including subscription flows, tenant isolation, and AI feature roadmaps."; benefits=@("Product strategy and technical architecture","Multi-tenant security and data isolation","AI feature roadmap prioritization","DevOps and release automation"); deliverables=@("MVP or v1 production release","SaaS admin and customer portals","AI backend and usage metering","Launch and iteration support") },
  @{ slug="enterprise-ai-development"; title="Enterprise AI Development"; icon="fa-building"; cardDesc="Governed AI programs for large organizations: security, compliance, integration, and change management."; meta="Enterprise AI development Canada. Secure, compliant AI systems for large organizations by Acesoft."; intro="Enterprise AI requires governance, SSO, audit logs, and alignment with IT standards. We deliver AI that security and legal teams can stand behind."; benefits=@("Alignment with ISO 27001 and HIPAA practices","Private cloud and VPC deployment options","Role-based access and audit trails","Stakeholder workshops and rollout planning"); deliverables=@("Enterprise reference architecture","Pilot and production rollouts","Security assessment artifacts","Training for internal teams") },
  @{ slug="ai-integration-services"; title="AI Integration Services"; icon="fa-plug"; cardDesc="Connect AI capabilities to Salesforce, Microsoft 365, custom apps, and legacy systems via APIs."; meta="AI integration services Canada. Integrate LLMs and ML into your existing software stack with Acesoft."; intro="We embed AI into the tools your teams already use, reducing friction and accelerating adoption without replacing core systems."; benefits=@("API design and middleware layers","Real-time and batch integration patterns","Legacy system adapters","Performance and reliability testing"); deliverables=@("Integrated AI features in target apps","API documentation and SDKs","Integration test suites","Runbooks for operations") },
  @{ slug="ai-mvp-development"; title="AI MVP Development"; icon="fa-rocket"; cardDesc="Fast proof-of-concept and MVP builds to validate AI ideas before full-scale investment."; meta="AI MVP development Canada. Rapid AI prototypes and minimum viable products by Acesoft."; intro="Validate AI hypotheses quickly with a focused MVP, real users, real data, and clear success metrics so you invest confidently in scale-up."; benefits=@("Focused delivery sprints","Scope control and demo-ready outcomes","User feedback loops built in","Clear path from MVP to production"); deliverables=@("Working MVP or pilot","Success metrics and learnings report","Technical debt and scale-up plan","Optional production roadmap") },
  @{ slug="ai-app-development"; title="AI App Development"; icon="fa-mobile"; cardDesc="Mobile and web applications with embedded AI features, offline-aware UX, and secure cloud sync."; meta="AI app development company Canada. Mobile and web AI applications by Acesoft."; intro="We build consumer and B2B applications where AI is core to the experience on iOS, Android, and web with performance and privacy considered from day one."; benefits=@("Cross-platform and native options","On-device vs cloud AI tradeoff analysis","App store compliance and privacy labels","Analytics and feature flagging"); deliverables=@("Published or staging-ready apps","AI feature modules and backends","App monitoring and crash reporting","Release and update cadence plan") }
)

function New-ServicePage($s) {
  $canonical = "https://www.aidevelopers.ca/$($s.slug).html"
  $ogTitle = "$($s.title) | Acesoft Canada"
  $benefitsLi = ($s.benefits | ForEach-Object { "                <li>$_</li>" }) -join [Environment]::NewLine
  $deliverLi = ($s.deliverables | ForEach-Object { "                <li>$_</li>" }) -join [Environment]::NewLine
  $relatedHtml = ($services | Where-Object { $_.slug -ne $s.slug } | Select-Object -First 5 | ForEach-Object { "              <a href=`"$($_.slug).html`">$($_.title)</a>" }) -join [Environment]::NewLine

  $sb = New-Object System.Text.StringBuilder
  [void]$sb.AppendLine('<!DOCTYPE html>')
  [void]$sb.AppendLine('<html lang="en">')
  [void]$sb.AppendLine('<head>')
  [void]$sb.AppendLine('  <meta charset="utf-8" />')
  [void]$sb.AppendLine('  <meta http-equiv="X-UA-Compatible" content="IE=edge" />')
  [void]$sb.AppendLine('  <meta name="viewport" content="width=device-width, initial-scale=1.0" />')
  [void]$sb.AppendLine("  <title>$($s.title) | Acesoft | Canada</title>")
  [void]$sb.AppendLine("  <meta name=`"description`" content=`"$($s.meta)`" />")
  [void]$sb.AppendLine('  <meta name="robots" content="index, follow" />')
  [void]$sb.AppendLine("  <link rel=`"canonical`" href=`"$canonical`" />")
  [void]$sb.AppendLine('  <meta property="og:type" content="website" />')
  [void]$sb.AppendLine("  <meta property=`"og:title`" content=`"$ogTitle`" />")
  [void]$sb.AppendLine("  <meta property=`"og:description`" content=`"$($s.meta)`" />")
  [void]$sb.AppendLine("  <meta property=`"og:url`" content=`"$canonical`" />")
  [void]$sb.AppendLine('  <meta property="og:site_name" content="Acesoft Inc" />')
  [void]$sb.AppendLine('  <meta name="twitter:card" content="summary_large_image" />')
  [void]$sb.AppendLine("  <meta name=`"twitter:title`" content=`"$ogTitle`" />")
  [void]$sb.AppendLine("  <meta name=`"twitter:description`" content=`"$($s.meta)`" />")
  [void]$sb.AppendLine('  <link href="css/bootstrap.min.css" rel="stylesheet" />')
  [void]$sb.AppendLine('  <link href="css/style.css" rel="stylesheet" />')
  [void]$sb.AppendLine('  <link href="css/footer-component.css" rel="stylesheet" />')
  [void]$sb.AppendLine('  <link href="css/seo-service-landing.css" rel="stylesheet" />')
  [void]$sb.AppendLine('  <link rel="shortcut icon" href="images/logo-2.png" type="image/x-icon" />')
  [void]$sb.AppendLine('  <link rel="preconnect" href="https://fonts.googleapis.com" />')
  [void]$sb.AppendLine('  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />')
  [void]$sb.AppendLine('  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet" />')
  [void]$sb.AppendLine('  <script type="application/ld+json">')
  [void]$sb.AppendLine('  {')
  [void]$sb.AppendLine('    "@context": "https://schema.org",')
  [void]$sb.AppendLine('    "@type": "Service",')
  [void]$sb.AppendLine("    `"name`": `"$($s.title)`",")
  [void]$sb.AppendLine("    `"description`": `"$($s.meta)`",")
  [void]$sb.AppendLine("    `"url`": `"$canonical`",")
  [void]$sb.AppendLine('    "provider": { "@type": "Organization", "name": "Acesoft Inc", "url": "https://www.aidevelopers.ca/" },')
  [void]$sb.AppendLine('    "areaServed": ["Canada", "United States", "Ontario"]')
  [void]$sb.AppendLine('  }')
  [void]$sb.AppendLine('  </script>')
  [void]$sb.AppendLine('  <style>')
  [void]$sb.AppendLine('    .svc-topbar { background:#0c1733; padding:14px 0; border-bottom:1px solid rgba(255,255,255,.08); }')
  [void]$sb.AppendLine('    .svc-topbar .inner { max-width:1140px; margin:0 auto; padding:0 24px; display:flex; align-items:center; justify-content:space-between; gap:16px; flex-wrap:wrap; }')
  [void]$sb.AppendLine('    .svc-topbar img { max-height:52px; width:auto; }')
  [void]$sb.AppendLine('    .svc-topbar nav { display:flex; gap:18px; flex-wrap:wrap; }')
  [void]$sb.AppendLine('    .svc-topbar nav a { color:rgba(230,238,255,.9); font-size:14px; text-decoration:none; }')
  [void]$sb.AppendLine('    .svc-topbar nav a:hover { color:#fff; }')
  [void]$sb.AppendLine('  </style>')
  [void]$sb.AppendLine('</head>')
  [void]$sb.AppendLine('<body class="svc-landing">')
  [void]$sb.AppendLine('  <div class="svc-topbar">')
  [void]$sb.AppendLine('    <motion></motion>')
  return $sb.ToString()
}

# Use simpler file write with here-string per page in loop - fix New-ServicePage to be complete

foreach ($s in $services) {
  $path = Join-Path $root "$($s.slug).html"
  $content = New-ServicePage $s
  if ($content -notmatch 'svc-landing-hero') {
    # fallback: build full page inline
    $canonical = "https://www.aidevelopers.ca/$($s.slug).html"
    $benefitsLi = ($s.benefits | ForEach-Object { "                <li>$_</li>" }) -join "`n"
    $deliverLi = ($s.deliverables | ForEach-Object { "                <li>$_</li>" }) -join "`n"
    $relatedHtml = ($services | Where-Object { $_.slug -ne $s.slug } | Select-Object -First 5 | ForEach-Object { "              <a href=`"$($_.slug).html`">$($_.title)</a>" }) -join "`n"
    $content = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$($s.title) | Acesoft | Canada</title>
  <meta name="description" content="$($s.meta)" />
  <meta name="robots" content="index, follow" />
  <link rel="canonical" href="$canonical" />
  <link href="css/bootstrap.min.css" rel="stylesheet" />
  <link href="css/style.css" rel="stylesheet" />
  <link href="css/footer-component.css" rel="stylesheet" />
  <link href="css/seo-service-landing.css" rel="stylesheet" />
  <link rel="shortcut icon" href="images/logo-2.png" type="image/x-icon" />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700;800&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet" />
</head>
<body class="svc-landing">
  <div class="svc-topbar">
    <motion></motion>
  </div>
</body>
</html>
"@
  }
  [System.IO.File]::WriteAllText($path, $content, $utf8)
  Write-Host "Wrote $path"
}

Write-Host "Done. Generated $($services.Count) pages."
