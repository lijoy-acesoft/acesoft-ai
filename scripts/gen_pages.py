# -*- coding: utf-8 -*-
import json
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

SERVICES = [
    {"slug": "custom-ai-development-services", "title": "Custom AI Development Services", "icon": "fa-cogs",
     "cardDesc": "Bespoke AI platforms, copilots, and intelligent features tailored to your business workflows and data.",
     "meta": "Custom AI development services in Canada. Acesoft builds secure, scalable AI systems for enterprises and startups.",
     "intro": "Acesoft designs and delivers custom AI solutions aligned with your domain, data estate, and compliance requirements. From discovery through production, we build AI that fits your product and operations.",
     "benefits": ["Use-case discovery and ROI-focused roadmap", "Secure architecture with governance and access controls", "Integration with CRM, ERP, and internal tools", "Continuous evaluation and model improvement"],
     "deliverables": ["Solution architecture and delivery plan", "Production-ready AI modules and APIs", "Documentation and handover for your team", "MLOps hooks for monitoring and retraining"]},
    {"slug": "generative-ai-development", "title": "Generative AI Development", "icon": "fa-magic",
     "cardDesc": "GPT-class applications, content engines, and generative workflows with guardrails and enterprise controls.",
     "meta": "Generative AI development company in Canada. Build secure GenAI apps, copilots, and content automation with Acesoft.",
     "intro": "We help organizations adopt generative AI responsibly with prompts, RAG pipelines, and application layers that deliver value while managing cost, quality, and risk.",
     "benefits": ["Model selection aligned to use case and budget", "Prompt engineering and evaluation frameworks", "Content and workflow automation at scale", "Policy guardrails and human review loops"],
     "deliverables": ["GenAI application or feature release", "Prompt libraries and evaluation suites", "Integration with your data and auth", "Operational playbooks for your team"]},
    {"slug": "llm-development", "title": "LLM Development", "icon": "fa-comments",
     "cardDesc": "Large language model apps, fine-tuning, RAG, and production LLM orchestration for enterprise products.",
     "meta": "LLM development services in Canada. Custom LLM apps, RAG, fine-tuning, and enterprise deployment by Acesoft.",
     "intro": "Our LLM engineering team builds production-grade language model experiences combining retrieval, tool use, and observability so assistants stay accurate and maintainable.",
     "benefits": ["RAG and vector search implementation", "Multi-model routing and fallback strategies", "Latency and cost optimization", "Hallucination reduction and quality metrics"],
     "deliverables": ["LLM-powered product features", "Vector index and ingestion pipelines", "API and SDK integration layers", "Monitoring dashboards and eval harnesses"]},
    {"slug": "ai-agent-development", "title": "AI Agent Development", "icon": "fa-android",
     "cardDesc": "Autonomous and semi-autonomous agents that execute multi-step tasks with tools, APIs, and human oversight.",
     "meta": "AI agent development in Canada. Build workflow agents, tool-using copilots, and enterprise automation with Acesoft.",
     "intro": "We design AI agents that plan, call tools, and complete business processes with clear boundaries, audit trails, and approval steps where risk requires human control.",
     "benefits": ["Agent workflow design and orchestration", "Secure tool and API integrations", "Error handling and escalation paths", "Testing for edge cases and failure modes"],
     "deliverables": ["Deployed agent workflows", "Tool connectors and permission model", "Run logs and observability", "Operator documentation"]},
    {"slug": "ai-chatbot-development", "title": "AI Chatbot Development", "icon": "fa-comment",
     "cardDesc": "Conversational AI for support, sales, and internal knowledge with branded UX and measurable outcomes.",
     "meta": "AI chatbot development company Canada. Enterprise chatbots, support bots, and knowledge assistants by Acesoft.",
     "intro": "We build chatbots that understand context, cite sources, and integrate with your knowledge base to improve deflection, response time, and customer satisfaction.",
     "benefits": ["Conversation design and intent mapping", "Knowledge base and RAG integration", "Handoff to live agents when needed", "Analytics on resolution and satisfaction"],
     "deliverables": ["Branded chat widget or embedded UI", "Admin console for content updates", "CRM or ticketing integrations", "Quality and usage reporting"]},
    {"slug": "ai-automation-solutions", "title": "AI Automation Solutions", "icon": "fa-bolt",
     "cardDesc": "Intelligent process automation combining rules, ML, and LLMs to reduce manual work across operations.",
     "meta": "AI automation solutions in Canada. Intelligent workflow automation and process AI by Acesoft.",
     "intro": "Combine traditional automation with AI to classify documents, extract data, route requests, and trigger actions.",
     "benefits": ["Process mapping and automation ROI analysis", "Document and email intelligence", "Integration with existing BPM tools", "Measurable time and cost savings"],
     "deliverables": ["Automated workflow implementations", "Exception handling and dashboards", "SOP updates and training materials", "Phase-2 expansion roadmap"]},
    {"slug": "machine-learning-development", "title": "Machine Learning Development", "icon": "fa-line-chart",
     "cardDesc": "Predictive models, forecasting, classification, and ML pipelines built for reliability at scale.",
     "meta": "Machine learning development services Canada. Custom ML models, pipelines, and MLOps by Acesoft.",
     "intro": "From feature engineering to model deployment, we deliver machine learning that performs in production with reproducible training and drift monitoring.",
     "benefits": ["Problem framing and baseline models", "Feature stores and training pipelines", "Model validation and bias review", "Deployment to cloud or on-prem"],
     "deliverables": ["Trained models and inference APIs", "Training and inference pipelines", "Model cards and documentation", "Monitoring and retraining plan"]},
    {"slug": "ai-saas-product-development", "title": "AI SaaS Product Development", "icon": "fa-cloud",
     "cardDesc": "End-to-end AI-native SaaS products with multi-tenant architecture, billing, and scalable AI backends.",
     "meta": "AI SaaS product development Canada. Build and launch AI-powered SaaS platforms with Acesoft.",
     "intro": "We partner with founders and product teams to ship AI SaaS from MVP through scale including subscription flows, tenant isolation, and AI feature roadmaps.",
     "benefits": ["Product strategy and technical architecture", "Multi-tenant security and data isolation", "AI feature roadmap prioritization", "DevOps and release automation"],
     "deliverables": ["MVP or v1 production release", "SaaS admin and customer portals", "AI backend and usage metering", "Launch and iteration support"]},
    {"slug": "enterprise-ai-development", "title": "Enterprise AI Development", "icon": "fa-building",
     "cardDesc": "Governed AI programs for large organizations: security, compliance, integration, and change management.",
     "meta": "Enterprise AI development Canada. Secure, compliant AI systems for large organizations by Acesoft.",
     "intro": "Enterprise AI requires governance, SSO, audit logs, and alignment with IT standards. We deliver AI that security and legal teams can stand behind.",
     "benefits": ["Alignment with ISO 27001 and HIPAA practices", "Private cloud and VPC deployment options", "Role-based access and audit trails", "Stakeholder workshops and rollout planning"],
     "deliverables": ["Enterprise reference architecture", "Pilot and production rollouts", "Security assessment artifacts", "Training for internal teams"]},
    {"slug": "ai-integration-services", "title": "AI Integration Services", "icon": "fa-plug",
     "cardDesc": "Connect AI capabilities to Salesforce, Microsoft 365, custom apps, and legacy systems via APIs.",
     "meta": "AI integration services Canada. Integrate LLMs and ML into your existing software stack with Acesoft.",
     "intro": "We embed AI into the tools your teams already use, reducing friction and accelerating adoption without replacing core systems.",
     "benefits": ["API design and middleware layers", "Real-time and batch integration patterns", "Legacy system adapters", "Performance and reliability testing"],
     "deliverables": ["Integrated AI features in target apps", "API documentation and SDKs", "Integration test suites", "Runbooks for operations"]},
    {"slug": "ai-mvp-development", "title": "AI MVP Development", "icon": "fa-rocket",
     "cardDesc": "Fast proof-of-concept and MVP builds to validate AI ideas before full-scale investment.",
     "meta": "AI MVP development Canada. Rapid AI prototypes and minimum viable products by Acesoft.",
     "intro": "Validate AI hypotheses quickly with a focused MVP, real users, real data, and clear success metrics so you invest confidently in scale-up.",
     "benefits": ["Focused delivery sprints", "Scope control and demo-ready outcomes", "User feedback loops built in", "Clear path from MVP to production"],
     "deliverables": ["Working MVP or pilot", "Success metrics and learnings report", "Technical debt and scale-up plan", "Optional production roadmap"]},
    {"slug": "ai-app-development", "title": "AI App Development", "icon": "fa-mobile",
     "cardDesc": "Mobile and web applications with embedded AI features, offline-aware UX, and secure cloud sync.",
     "meta": "AI app development company Canada. Mobile and web AI applications by Acesoft.",
     "intro": "We build consumer and B2B applications where AI is core to the experience on iOS, Android, and web with performance and privacy considered from day one.",
     "benefits": ["Cross-platform and native options", "On-device vs cloud AI tradeoff analysis", "App store compliance and privacy labels", "Analytics and feature flagging"],
     "deliverables": ["Published or staging-ready apps", "AI feature modules and backends", "App monitoring and crash reporting", "Release and update cadence plan"]},
]

FOOTER_HTML = """
    <footer class="main-footer">
      <motion></motion>
    </footer>
"""

# I'll write one complete page manually with Write tool for custom-ai-development-services.html then copy approach with shell

def main():
    for s in SERVICES:
        canonical = "https://www.aidevelopers.ca/" + s["slug"] + ".html"
        benefits = "\n".join("                <li>" + b + "</li>" for b in s["benefits"])
        deliverables = "\n".join("                <li>" + d + "</li>" for d in s["deliverables"])
        related_list = [x for x in SERVICES if x["slug"] != s["slug"]][:5]
        related_html = "\n".join('              <a href="' + r["slug"] + '.html">' + r["title"] + "</a>" for r in related_list)

        schema = {
            "@context": "https://schema.org",
            "@type": "Service",
            "name": s["title"],
            "description": s["meta"],
            "url": canonical,
            "provider": {"@type": "Organization", "name": "Acesoft Inc", "url": "https://www.aidevelopers.ca/"},
            "areaServed": ["Canada", "Ontario"],
        }

        html_lines = [
            "<!DOCTYPE html>",
            '<html lang="en">',
            "<head>",
            '  <meta charset="utf-8" />',
            '  <meta name="viewport" content="width=device-width, initial-scale=1.0" />',
            "  <title>" + s["title"] + " | Acesoft | Canada</title>",
            '  <meta name="description" content="' + s["meta"] + '" />',
            '  <meta name="robots" content="index, follow" />',
            '  <link rel="canonical" href="' + canonical + '" />',
            '  <meta property="og:title" content="' + s["title"] + ' | Acesoft Canada" />',
            '  <meta property="og:description" content="' + s["meta"] + '" />',
            '  <meta property="og:url" content="' + canonical + '" />',
            '  <link href="css/bootstrap.min.css" rel="stylesheet" />',
            '  <link href="css/style.css" rel="stylesheet" />',
            '  <link href="css/footer-component.css" rel="stylesheet" />',
            '  <link href="css/seo-service-landing.css" rel="stylesheet" />',
            '  <link rel="shortcut icon" href="images/logo-2.png" type="image/x-icon" />',
            '  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700;800&amp;family=DM+Sans:wght@400;500;600&amp;display=swap" rel="stylesheet" />',
            '  <script type="application/ld+json">',
            "  " + json.dumps(schema, indent=2).replace("\n", "\n  "),
            "  </script>",
            "  <style>",
            "    .svc-topbar { background:#0c1733; padding:14px 0; border-bottom:1px solid rgba(255,255,255,.08); }",
            "    .svc-topbar .inner { max-width:1140px; margin:0 auto; padding:0 24px; display:flex; align-items:center; justify-content:space-between; gap:16px; flex-wrap:wrap; }",
            "    .svc-topbar img { max-height:52px; width:auto; }",
            "    .svc-topbar nav { display:flex; gap:18px; flex-wrap:wrap; }",
            "    .svc-topbar nav a { color:rgba(230,238,255,.9); font-size:14px; text-decoration:none; }",
            "    .svc-topbar nav a:hover { color:#fff; }",
            "  </style>",
            "</head>",
            '<body class="svc-landing">',
            '  <motion></motion>',
        ]
        # Fix topbar line
        html_lines[-1] = '  <div class="svc-topbar"><div class="inner"><a href="index.html"><img src="images/logo-2.png" alt="Acesoft Inc" /></a><nav><a href="index.html">Home</a><a href="ai-development-services.html">AI Development</a><a href="ai-staffing.html">AI Staffing</a><a href="ai-consultation.html">AI Consultation</a><a href="page-contact.html">Contact</a></nav></div></div>'

        html_lines += [
            '  <section class="svc-landing-hero">',
            '    <div class="auto-container">',
            '      <p class="svc-breadcrumb"><a href="index.html">Home</a> / <a href="ai-development-services.html">AI Development Services</a> / ' + s["title"] + "</p>",
            "      <h1>" + s["title"] + "</h1>",
            '      <p class="lead">' + s["intro"] + "</p>",
            '      <a href="page-contact.html" class="svc-hero-cta">Discuss your project</a>',
            "    </div>",
            "  </section>",
            '  <section class="svc-landing-body">',
            '    <div class="auto-container">',
            '      <div class="svc-content-grid">',
            "        <div>",
            '          <motion></motion>',
        ]
        html_lines[-1] = '          <motion></motion>'
        html_lines[-1] = '          <div class="svc-panel"><h2>Key benefits</h2><ul>\n' + benefits + "\n            </ul></div>"
        html_lines.append('          <div class="svc-panel"><h2>What you get</h2><ul>\n' + deliverables + "\n            </ul></motion></motion>")
        html_lines[-1] = '          <div class="svc-panel"><h2>What you get</h2><ul>\n' + deliverables + "\n            </ul></div>"
        html_lines += [
            "        </div>",
            '        <aside class="svc-sidebar">',
            '          <div class="svc-sidebar-card">',
            "            <h3>Start your project</h3>",
            "            <p>Talk to our Canada-based AI team about scope, timeline, and delivery approach.</p>",
            '            <a href="page-contact.html">Get in Touch</a>',
            "          </div>",
            '          <div class="svc-panel svc-related-links">',
            "            <h2>Related services</h2>",
            related_html,
            "          </div>",
            "        </aside>",
            "      </div>",
            "    </div>",
            "  </section>",
            '  <footer class="main-footer">',
            '    <div class="widgets-section" style="padding:40px 0;background:#0c1733;color:#fff;text-align:center">',
            '      <p style="margin:0;font-size:14px">&copy; <span id="currentYear"></span> Acesoft Inc &middot; <a href="index.html" style="color:#a8d0ff">Home</a> &middot; <a href="page-contact.html" style="color:#a8d0ff">Contact</a></p>',
            "    </div>",
            "  </footer>",
            "  <script>document.getElementById('currentYear').innerText=new Date().getFullYear();</script>",
            "</body>",
            "</html>",
        ]

        path = os.path.join(ROOT, s["slug"] + ".html")
        with open(path, "w", encoding="utf-8", newline="\n") as f:
            f.write("\n".join(html_lines))
        print("Wrote", path)

    # Write hub cards JSON for reference
    hub_path = os.path.join(ROOT, "scripts", "services-hub.json")
    with open(hub_path, "w", encoding="utf-8") as f:
        json.dump(SERVICES, f, indent=2)
    print("Wrote", hub_path)


if __name__ == "__main__":
    main()
