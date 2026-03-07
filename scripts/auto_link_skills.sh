#!/bin/bash
# Auto-Symlink Script for Backgetters Super Repo
# Creates symlinks for all skills in appropriate categories

cd ~/clawd/super-repo
SKILLS_DIR="$HOME/.openclaw/skills"

echo "🔗 Auto-linking skills to super-repo..."

# Core Agent Frameworks
for skill in deer-flow claude-flow mission-control accomplish ouroboros paperclip agentchattr; do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "core/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "core/$skill"
        echo "  ✓ core/$skill"
    fi
done

# MCP Servers
for skill in apitap graphthulhu copilot-api mcp-server; do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "mcp-servers/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "mcp-servers/$skill"
        echo "  ✓ mcp-servers/$skill"
    fi
done

# Agency
for skill in agency-agents; do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "agency/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "agency/$skill"
        echo "  ✓ agency/$skill"
    fi
done

# Trading
for skill in Polymarket-betting-bot bloomberg-terminal PolymarketBTC15mAssistant; do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "trading/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "trading/$skill"
        echo "  ✓ trading/$skill"
    fi
done

# Data
for skill in Scrapling zvec convex-backend; do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "data/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "data/$skill"
        echo "  ✓ data/$skill"
    fi
done

# DevTools
for skill in claude-code-safety-net visual-explainer vibe-to-prod copilot-api; do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "devtools/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "devtools/$skill"
        echo "  ✓ devtools/$skill"
    fi
done

# Productivity
for skill in ClawWork moltdirectory; do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "productivity/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "productivity/$skill"
        echo "  ✓ productivity/$skill"
    fi
done

# Skills Collections
for skill in antigravity-awesome-skills awesome-agent-skills awesome-openclaw-usecases; do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "skills/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "skills/$skill"
        echo "  ✓ skills/$skill"
    fi
done

# Sales (afrexai + linkedin + apollo + hubspot)
for skill in $(ls "$SKILLS_DIR" | grep -E "^(afrexai-.*sales|afrexai-.*lead|afrexai-.*crm|linkedin|apollo|hubspot|zoho)"); do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "sales/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "sales/$skill"
        echo "  ✓ sales/$skill"
    fi
done

# Marketing (afrexai + social + content)
for skill in $(ls "$SKILLS_DIR" | grep -E "^(afrexai-.*market|afrexai-.*content|afrexai-.*email|afrexai-.*social|afrexai-.*ad|afrexai-.*brand|youtube|twitter|tiktok|instagram|reddit|wechat|content)"); do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "marketing/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "marketing/$skill"
        echo "  ✓ marketing/$skill"
    fi
done

# Finance (afrexai + trading + accounting)
for skill in $(ls "$SKILLS_DIR" | grep -E "^(afrexai-.*finance|afrexai-.*budget|afrexai-.*invoice|afrexai-.*account|afrexai-.*cash|afrexai-.*tax|afrexai-.*fund|afrexai-.*invest|afrexai-.*revenue|copilot-money|yahooquery|alpaca|binance|polygon|trading)"); do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "finance/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "finance/$skill"
        echo "  ✓ finance/$skill"
    fi
done

# DevOps (aws + azure + gcp + docker + k8s)
for skill in $(ls "$SKILLS_DIR" | grep -E "^(afrexai-.*devops|aws-|azure-|gcp-|google-|docker|kubernetes|terraform|github-actions|gitlab|jenkins|selenium|deploy)"); do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "devops/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "devops/$skill"
        echo "  ✓ devops/$skill"
    fi
done

# Security (afrexai + scanning + monitoring)
for skill in $(ls "$SKILLS_DIR" | grep -E "^(afrexai-.*security|afrexai-.*compliance|afrexai-.*audit|afrexai-.*privacy|afrexai-.*hipaa|afrexai-.*cyber|ggshield|security|scan)"); do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "security/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "security/$skill"
        echo "  ✓ security/$skill"
    fi
done

# HR (afrexai + hiring + people)
for skill in $(ls "$SKILLS_DIR" | grep -E "^(afrexai-.*hiring|afrexai-.*employee|afrexai-.*onboard|afrexai-.*offboard|afrexai-.*compensation|afrexai-.*hr)"); do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "hr/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "hr/$skill"
        echo "  ✓ hr/$skill"
    fi
done

# Operations (afrexai + business + management)
for skill in $(ls "$SKILLS_DIR" | grep -E "^(afrexai-.*ops|afrexai-.*workflow|afrexai-.*project|afrexai-.*meeting|afrexai-.*calendar|afrexai-.*task|afrexai-.*logistics|afrexai-.*supply|afrexai-.*inventory|afrexai-.*fleet)"); do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "operations/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "operations/$skill"
        echo "  ✓ operations/$skill"
    fi
done

# Legal (afrexai + contract + compliance)
for skill in $(ls "$SKILLS_DIR" | grep -E "^(afrexai-.*contract|afrexai-.*legal|afrexai-.*compliance|contract-)"); do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "legal/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "legal/$skill"
        echo "  ✓ legal/$skill"
    fi
done

# E-commerce (woocommerce + shopify + payments)
for skill in $(ls "$SKILLS_DIR" | grep -E "^(woocommerce|shopify|stripe|paypal|square|ecommerce)"); do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "e-commerce/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "e-commerce/$skill"
        echo "  ✓ e-commerce/$skill"
    fi
done

# Data Analysis (analytics + reporting + excel)
for skill in $(ls "$SKILLS_DIR" | grep -E "^(afrexai-.*data|afrexai-.*analy|afrexai-.*report|analytics|ga4|xlsx|csv|excel)"); do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "data/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "data/$skill"
        echo "  ✓ data/$skill"
    fi
done

# Productivity (notes + calendar + reminders)
for skill in $(ls "$SKILLS_DIR" | grep -E "^(apple-|bear-|notion|obsidian|todoist|calendar|reminder|notebook|task)"); do
    if [ -d "$SKILLS_DIR/$skill" ] && [ ! -L "productivity/$skill" ]; then
        ln -sf "$SKILLS_DIR/$skill" "productivity/$skill"
        echo "  ✓ productivity/$skill"
    fi
done

echo ""
echo "✅ Auto-link complete!"
echo "📊 Total skills linked: $(find . -type l | wc -l)"
