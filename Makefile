# Makefile for Backgetters Super Repo
# Unified command interface for all components

.PHONY: help status start stop logs

# Default target
help:
	@echo "🚀 Backgetters Super Repo - Command Reference"
	@echo ""
	@echo "Core Operations:"
	@echo "  make status              - Show all component status"
	@echo "  make start               - Start all core services"
	@echo "  make stop                - Stop all services"
	@echo "  make logs                - View unified logs"
	@echo ""
	@echo "Component Control:"
	@echo "  make mission-control-up  - Start dashboard"
	@echo "  make deer-flow-up        - Start SuperAgent harness"
	@echo "  make mcp-up              - Start all MCP servers"
	@echo "  make agency-deploy       - Deploy agency agents"
	@echo "  make trading-up          - Start trading bots (paper mode)"
	@echo ""
	@echo "Development:"
	@echo "  make install             - Install all dependencies"
	@echo "  make update              - Update all repos"
	@echo "  make test                - Run test suite"
	@echo ""
	@echo "Utilities:"
	@echo "  make clean               - Clean temporary files"
	@echo "  make backup              - Backup all data"

# Status checks
status:
	@echo "📊 Backgetters Super Repo Status"
	@echo "================================"
	@echo ""
	@echo "Core Components:"
	@ls -la core/ 2>/dev/null | grep "^l" | awk '{print "  ✅ " $$9 " -> " $$11}'
	@echo ""
	@echo "MCP Servers:"
	@ls -la mcp-servers/ 2>/dev/null | grep "^l" | awk '{print "  ✅ " $$9 " -> " $$11}'
	@echo ""
	@echo "Agency:"
	@ls -la agency/ 2>/dev/null | grep "^l" | awk '{print "  ✅ " $$9 " -> " $$11}'
	@echo ""
	@echo "Trading:"
	@ls -la trading/ 2>/dev/null | grep "^l" | awk '{print "  ✅ " $$9 " -> " $$11}'
	@echo ""
	@echo "Skills Available:"
	@find skills/ -name "*.md" 2>/dev/null | wc -l | xargs echo "  📚 Skill files:"

# Start all services
start:
	docker-compose -f workflows/orchestration.yml up -d

# Stop all services
stop:
	docker-compose -f workflows/orchestration.yml down

# View logs
logs:
	docker-compose -f workflows/orchestration.yml logs -f

# Individual components
mission-control-up:
	docker-compose -f workflows/orchestration.yml up -d mission-control
	@echo "🌐 Mission Control available at http://localhost:3000"

deer-flow-up:
	docker-compose -f workflows/orchestration.yml up -d deer-flow

mcp-up:
	docker-compose -f workflows/orchestration.yml up -d apitap graphthulhu copilot-api
	@echo "🔌 MCP Servers:"
	@echo "  apitap: http://localhost:8080"
	@echo "  graphthulhu: http://localhost:8081"
	@echo "  copilot-api: http://localhost:8082"

agency-deploy:
	docker-compose -f workflows/orchestration.yml up -d agency-agents
	@echo "🤖 Agency agents deployed"

trading-up:
	docker-compose -f workflows/orchestration.yml up -d polymarket-bot bloomberg-terminal
	@echo "📈 Trading bots started (paper mode)"

# Development
install:
	@echo "📦 Installing dependencies..."
	@cd core/deer-flow && npm install 2>/dev/null || pip install -r requirements.txt 2>/dev/null || true
	@cd mcp-servers/apitap && npm install 2>/dev/null || true
	@cd mcp-servers/graphthulhu && npm install 2>/dev/null || true

update:
	@echo "🔄 Updating all repos..."
	@for dir in core/* mcp-servers/* agency/* trading/* data/*; do \
		if [ -L "$$dir" ]; then \
			cd "$$dir" && git pull 2>/dev/null && cd - > /dev/null; \
		fi \
	done

test:
	@echo "🧪 Running tests..."
	@# Add test commands here

# Utilities
clean:
	@echo "🧹 Cleaning temporary files..."
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name ".DS_Store" -delete 2>/dev/null || true

backup:
	@echo "💾 Creating backup..."
	@tar -czf backup-$(shell date +%Y%m%d-%H%M%S).tar.gz workflows/ README.md activate.sh
	@echo "✅ Backup created"
