#!/usr/bin/env python3
"""
Amazo Skill Hub Scanner & Auto-Integrator
Daily automated scanning of clawhub.ai and local skills
Integrates new skills after safety review
"""

import os
import sys
import json
import hashlib
import subprocess
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Optional, Set
import re

class SkillScanner:
    """
    Automated skill discovery, review, and integration system.
    Runs daily via cron to keep super-repo up to date.
    """
    
    def __init__(self, repo_dir: str = "~/clawd/super-repo"):
        self.repo_dir = Path(repo_dir).expanduser()
        self.skills_dir = Path("~/.openclaw/skills").expanduser()
        self.log_dir = self.repo_dir / "logs"
        self.log_dir.mkdir(exist_ok=True)
        
        # Tracking files
        self.inventory_file = self.repo_dir / "inventory.json"
        self.blacklist_file = self.repo_dir / "blacklist.json"
        self.pending_file = self.repo_dir / "pending_review.json"
        
        # Load existing data
        self.inventory = self._load_json(self.inventory_file, {})
        self.blacklist = self._load_json(self.blacklist_file, [])
        self.pending = self._load_json(self.pending_file, [])
        
        # Red flags for malicious/redundant detection
        self.red_flags = [
            r'rm\s+-rf\s+/',
            r'>\s*/dev/null',
            r'curl.*\|.*bash',
            r'wget.*\|.*sh',
            r'eval\s*\(',
            r'exec\s*\(',
            r'system\s*\(',
            r'subprocess\.call\s*\([^)]*shell\s*=\s*True',
            r'os\.system',
            r'__import__\s*\(',
        ]
        
        # Redundant patterns (skills that duplicate existing functionality)
        self.redundant_patterns = {
            'email': ['email-crafter', 'email-marketing', 'email-triager'],
            'calendar': ['calendar-optimizer', 'calendar-scheduling'],
            'analytics': ['analytics-dashboard', 'analytics-reporter', 'ga4'],
        }
    
    def _load_json(self, path: Path, default):
        if path.exists():
            with open(path) as f:
                return json.load(f)
        return default
    
    def _save_json(self, path: Path, data):
        with open(path, 'w') as f:
            json.dump(data, f, indent=2)
    
    def log(self, message: str, level: str = "INFO"):
        """Log with timestamp"""
        timestamp = datetime.now().isoformat()
        log_entry = f"[{timestamp}] {level}: {message}"
        print(log_entry)
        
        # Append to daily log
        log_file = self.log_dir / f"scanner_{datetime.now().strftime('%Y%m%d')}.log"
        with open(log_file, 'a') as f:
            f.write(log_entry + "\n")
    
    def scan_local_skills(self) -> List[Dict]:
        """Scan ~/.openclaw/skills for new/unlinked skills"""
        self.log("Scanning local skills directory...")
        
        new_skills = []
        
        if not self.skills_dir.exists():
            self.log("Skills directory not found!", "ERROR")
            return new_skills
        
        for skill_path in self.skills_dir.iterdir():
            if not skill_path.is_dir():
                continue
            
            skill_name = skill_path.name
            
            # Skip if already in inventory
            if skill_name in self.inventory:
                continue
            
            # Skip if blacklisted
            if skill_name in self.blacklist:
                continue
            
            # Skip system directories
            if skill_name in ['active', 'archived']:
                continue
            
            # Analyze skill
            skill_info = self._analyze_skill(skill_path)
            new_skills.append(skill_info)
        
        self.log(f"Found {len(new_skills)} new skills")
        return new_skills
    
    def _analyze_skill(self, skill_path: Path) -> Dict:
        """Analyze a skill for categorization and safety"""
        skill_name = skill_path.name
        
        # Check for SKILL.md or README.md
        has_skill_md = (skill_path / "SKILL.md").exists()
        has_readme = (skill_path / "README.md").exists()
        
        # Read description
        description = ""
        if has_skill_md:
            content = (skill_path / "SKILL.md").read_text(errors='ignore')[:500]
            description = content.split('\n')[0].replace('#', '').strip()
        elif has_readme:
            content = (skill_path / "README.md").read_text(errors='ignore')[:500]
            description = content.split('\n')[0].replace('#', '').strip()
        
        # Determine category
        category = self._categorize_skill(skill_name, description)
        
        # Check for code files
        code_files = list(skill_path.rglob("*.py")) + list(skill_path.rglob("*.js")) + list(skill_path.rglob("*.ts"))
        
        return {
            'name': skill_name,
            'path': str(skill_path),
            'description': description,
            'category': category,
            'has_skill_md': has_skill_md,
            'has_readme': has_readme,
            'code_files': len(code_files),
            'discovered_at': datetime.now().isoformat(),
            'status': 'pending_review'
        }
    
    def _categorize_skill(self, name: str, description: str) -> str:
        """Categorize skill based on name and description"""
        text = (name + " " + description).lower()
        
        categories = {
            'core': ['agent', 'flow', 'orchestr', 'harness', 'accomplish', 'ouroboros'],
            'mcp-server': ['mcp', 'apitap', 'graphthulhu', 'copilot-api'],
            'trading': ['trade', 'market', 'crypto', 'bitcoin', 'polygon', 'alpaca', 'binance', 'polymarket'],
            'sales': ['sales', 'lead', 'crm', 'apollo', 'hubspot', 'linkedin', 'zoho'],
            'marketing': ['market', 'content', 'social', 'email', 'ad', 'brand', 'youtube', 'twitter', 'seo'],
            'finance': ['finance', 'budget', 'invoice', 'account', 'cash', 'tax', 'fund', 'invest', 'payment'],
            'devops': ['devops', 'aws', 'azure', 'gcp', 'docker', 'kubernetes', 'terraform', 'deploy', 'ci/cd'],
            'security': ['security', 'compliance', 'audit', 'privacy', 'hipaa', 'cyber', 'scan', 'shield'],
            'data': ['data', 'analy', 'scrap', 'csv', 'excel', 'ga4', 'report', 'database'],
            'hr': ['hiring', 'employee', 'onboard', 'offboard', 'hr', 'people', 'compensation'],
            'operations': ['ops', 'workflow', 'project', 'meeting', 'calendar', 'task', 'logistics', 'inventory'],
            'legal': ['contract', 'legal', 'compliance', 'agreement'],
            'e-commerce': ['shopify', 'woocommerce', 'stripe', 'paypal', 'ecommerce', 'square'],
            'productivity': ['notes', 'calendar', 'reminder', 'notion', 'obsidian', 'bear', 'todo'],
            'agency': ['agency', 'agent-', 'specialist'],
        }
        
        for category, keywords in categories.items():
            if any(kw in text for kw in keywords):
                return category
        
        return 'misc'
    
    def safety_review(self, skill: Dict) -> Dict:
        """
        Perform automated safety review on a skill.
        Returns review result with approval status.
        """
        self.log(f"Reviewing skill: {skill['name']}...")
        
        review = {
            'skill_name': skill['name'],
            'timestamp': datetime.now().isoformat(),
            'checks': {},
            'approved': False,
            'reasons': []
        }
        
        skill_path = Path(skill['path'])
        
        # Check 1: Has documentation
        has_docs = skill['has_skill_md'] or skill['has_readme']
        review['checks']['documentation'] = has_docs
        if not has_docs:
            review['reasons'].append("Missing SKILL.md or README.md")
        
        # Check 2: No malicious code patterns
        malicious_found = []
        for code_file in skill_path.rglob("*.py"):
            try:
                content = code_file.read_text(errors='ignore')
                for pattern in self.red_flags:
                    if re.search(pattern, content):
                        malicious_found.append(f"{code_file.name}: {pattern}")
            except:
                pass
        
        review['checks']['malicious_code'] = len(malicious_found) == 0
        if malicious_found:
            review['reasons'].append(f"Suspicious patterns found: {malicious_found[:3]}")
        
        # Check 3: Not redundant
        is_redundant = self._check_redundancy(skill)
        review['checks']['not_redundant'] = not is_redundant
        if is_redundant:
            review['reasons'].append("Similar skill already exists")
        
        # Check 4: Has actual functionality
        has_code = skill['code_files'] > 0 or skill['has_skill_md']
        review['checks']['has_functionality'] = has_code
        if not has_code:
            review['reasons'].append("No code or documentation found")
        
        # Determine approval
        review['approved'] = all(review['checks'].values())
        
        if review['approved']:
            self.log(f"  ✅ {skill['name']} approved")
        else:
            self.log(f"  ❌ {skill['name']} rejected: {', '.join(review['reasons'])}")
        
        return review
    
    def _check_redundancy(self, skill: Dict) -> bool:
        """Check if skill is redundant with existing skills"""
        skill_name = skill['name'].lower()
        
        for category, patterns in self.redundant_patterns.items():
            if any(pattern in skill_name for pattern in patterns):
                # Check if similar skill exists
                for existing in self.inventory.values():
                    if existing['category'] == skill['category']:
                        existing_name = existing['name'].lower()
                        if any(pattern in existing_name for pattern in patterns):
                            return True
        
        return False
    
    def integrate_skill(self, skill: Dict) -> bool:
        """
        Integrate approved skill into super-repo.
        Creates symlink in appropriate category.
        """
        skill_name = skill['name']
        category = skill['category']
        
        # Determine target directory
        target_dir = self.repo_dir / category
        if not target_dir.exists():
            target_dir = self.repo_dir / "misc"
        
        target_link = target_dir / skill_name
        
        try:
            # Create symlink
            if target_link.exists() or target_link.is_symlink():
                target_link.unlink()
            
            target_link.symlink_to(skill['path'])
            
            # Update inventory
            self.inventory[skill_name] = skill
            self.inventory[skill_name]['integrated_at'] = datetime.now().isoformat()
            self.inventory[skill_name]['status'] = 'integrated'
            self._save_json(self.inventory_file, self.inventory)
            
            self.log(f"  ✅ Integrated {skill_name} → {category}/")
            return True
            
        except Exception as e:
            self.log(f"  ❌ Failed to integrate {skill_name}: {e}", "ERROR")
            return False
    
    def run_daily_scan(self):
        """
        Main entry point: Run full daily scan and integration.
        """
        self.log("=" * 60)
        self.log("DAILY SKILL SCAN & INTEGRATION")
        self.log("=" * 60)
        
        # Step 1: Scan for new skills
        new_skills = self.scan_local_skills()
        
        if not new_skills:
            self.log("No new skills found.")
            return
        
        # Step 2: Safety review
        self.log(f"\n🔍 Reviewing {len(new_skills)} new skills...")
        approved = []
        rejected = []
        
        for skill in new_skills:
            review = self.safety_review(skill)
            
            if review['approved']:
                approved.append(skill)
            else:
                rejected.append((skill, review['reasons']))
                # Add to blacklist if malicious
                if not review['checks'].get('malicious_code', True):
                    self.blacklist.append(skill['name'])
        
        # Save blacklist
        self._save_json(self.blacklist_file, self.blacklist)
        
        # Step 3: Integrate approved skills
        if approved:
            self.log(f"\n🔧 Integrating {len(approved)} approved skills...")
            integrated = 0
            for skill in approved:
                if self.integrate_skill(skill):
                    integrated += 1
            
            self.log(f"\n✅ Integrated {integrated}/{len(approved)} skills")
        
        # Step 4: Report rejected skills
        if rejected:
            self.log(f"\n⚠️  Rejected {len(rejected)} skills:")
            for skill, reasons in rejected:
                self.log(f"  - {skill['name']}: {', '.join(reasons)}")
        
        # Step 5: Summary
        self.log("\n" + "=" * 60)
        self.log("SUMMARY")
        self.log("=" * 60)
        self.log(f"Total skills in inventory: {len(self.inventory)}")
        self.log(f"New skills found: {len(new_skills)}")
        self.log(f"Approved: {len(approved)}")
        self.log(f"Rejected: {len(rejected)}")
        self.log(f"Blacklisted: {len(self.blacklist)}")
        
        return {
            'found': len(new_skills),
            'approved': len(approved),
            'integrated': integrated if approved else 0,
            'rejected': len(rejected)
        }

class HubScanner:
    """
    Scanner for external skill hubs (clawhub.ai, etc.)
    Placeholder for future external registry integration.
    """
    
    def __init__(self):
        self.hub_url = "https://clawhub.ai"
        # TODO: Implement API integration when available
    
    def scan_remote(self) -> List[Dict]:
        """Scan remote hub for new skills"""
        # Placeholder - requires API access
        return []

def main():
    """Main entry point for cron execution"""
    scanner = SkillScanner()
    result = scanner.run_daily_scan()
    
    # Exit code indicates if new skills were found
    sys.exit(0 if result and result['found'] > 0 else 0)

if __name__ == "__main__":
    main()
