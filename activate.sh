#!/bin/bash
# Backgetters Super Repo Activation Script
# Source this file: source activate.sh

echo "🚀 Activating Backgetters Super Repo..."

# Set super repo root
export BACKGETTERS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Add all tool binaries to PATH
export PATH="$BACKGETTERS_ROOT/core/deer-flow/bin:$PATH" 2>/dev/null
export PATH="$BACKGETTERS_ROOT/core/claude-flow/bin:$PATH" 2>/dev/null
export PATH="$BACKGETTERS_ROOT/mcp-servers/apitap/bin:$PATH" 2>/dev/null
export PATH="$BACKGETTERS_ROOT/mcp-servers/graphthulhu/bin:$PATH" 2>/dev/null
export PATH="$BACKGETTERS_ROOT/devtools/claude-code-safety-net/bin:$PATH" 2>/dev/null

# Set environment variables
export DEER_FLOW_HOME="$BACKGETTERS_ROOT/core/deer-flow"
export CLAUDE_FLOW_HOME="$BACKGETTERS_ROOT/core/claude-flow"
export MISSION_CONTROL_HOME="$BACKGETTERS_ROOT/core/mission-control"
export AGENCY_HOME="$BACKGETTERS_ROOT/agency/agency-agents"
export APITAP_HOME="$BACKGETTERS_ROOT/mcp-servers/apitap"
export GRAPHTHULHU_HOME="$BACKGETTERS_ROOT/mcp-servers/graphthulhu"

# Skill collections
export ANTI_GRAVITY_SKILLS="$BACKGETTERS_ROOT/skills/antigravity-awesome-skills"
export AWESOME_AGENT_SKILLS="$BACKGETTERS_ROOT/skills/awesome-agent-skills"

# Trading
export POLYMARKET_BOT_HOME="$BACKGETTERS_ROOT/trading/Polymarket-betting-bot"
export BLOOMBERG_HOME="$BACKGETTERS_ROOT/trading/bloomberg-terminal"

# Data
export SCRAPLING_HOME="$BACKGETTERS_ROOT/data/Scrapling"

# Productivity
export CLAWWORK_HOME="$BACKGETTERS_ROOT/productivity/ClawWork"

echo "✅ Super Repo Activated!"
echo ""
echo "📊 Available Commands:"
echo "  super-status     - Show all component status"
echo "  super-start      - Start all core services"
echo "  super-stop       - Stop all services"
echo "  super-logs       - View unified logs"
echo "  agency-deploy    - Deploy agency agents"
echo "  trading-start    - Start trading bots"
echo "  mcp-start        - Start MCP servers"
echo ""
echo "🔧 Quick Access:"
echo "  cd \$DEER_FLOW_HOME"
echo "  cd \$AGENCY_HOME"
echo "  cd \$CLAWWORK_HOME"
