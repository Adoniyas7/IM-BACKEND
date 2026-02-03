#!/bin/bash

# Render Deployment Setup Helper Script
# This script helps you gather and verify all necessary information for Render deployment

echo "🚀 Render Deployment Setup Helper"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if master key exists
echo "1️⃣ Checking Rails Master Key..."
if [ -f "config/master.key" ]; then
    MASTER_KEY=$(cat config/master.key)
    echo -e "${GREEN}✓ Master key found${NC}"
    echo "   Copy this to Render as RAILS_MASTER_KEY:"
    echo -e "   ${YELLOW}${MASTER_KEY}${NC}"
else
    echo -e "${RED}✗ Master key not found!${NC}"
    echo "   Generate it with: EDITOR=nano rails credentials:edit"
fi
echo ""

# Check if git repository is set up
echo "2️⃣ Checking Git Repository..."
if git remote -v | grep -q "github.com"; then
    REPO_URL=$(git remote get-url origin)
    echo -e "${GREEN}✓ GitHub repository configured${NC}"
    echo "   Repository: ${REPO_URL}"
else
    echo -e "${RED}✗ GitHub repository not found!${NC}"
    echo "   Set it up with: git remote add origin <your-github-repo-url>"
fi
echo ""

# Check if required files exist
echo "3️⃣ Checking Required Files..."
FILES=("Dockerfile" "render.yaml" ".github/workflows/deploy.yml" "Gemfile" "config/database.yml")
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ ${file} exists${NC}"
    else
        echo -e "${RED}✗ ${file} missing!${NC}"
    fi
done
echo ""

# Check Ruby version
echo "4️⃣ Checking Ruby Version..."
if command -v ruby &> /dev/null; then
    RUBY_VERSION=$(ruby -v)
    echo -e "${GREEN}✓ Ruby installed: ${RUBY_VERSION}${NC}"
else
    echo -e "${YELLOW}⚠ Ruby not found in PATH${NC}"
fi
echo ""

# Generate SECRET_KEY_BASE if needed
echo "5️⃣ Generating SECRET_KEY_BASE (for Render)..."
if command -v rails &> /dev/null; then
    SECRET_KEY=$(rails secret)
    echo -e "${GREEN}✓ Generated SECRET_KEY_BASE${NC}"
    echo "   Copy this to Render as SECRET_KEY_BASE (optional, but recommended):"
    echo -e "   ${YELLOW}${SECRET_KEY}${NC}"
else
    echo -e "${YELLOW}⚠ Rails not available, skipping SECRET_KEY_BASE generation${NC}"
fi
echo ""

# Environment variables checklist
echo "6️⃣ Environment Variables Needed in Render:"
echo "   Required:"
echo "   - RAILS_MASTER_KEY (from step 1)"
echo "   - DATABASE_URL (provided by Render database)"
echo ""
echo "   Recommended:"
echo "   - RAILS_ENV=production"
echo "   - RAILS_LOG_TO_STDOUT=enabled"
echo "   - RAILS_SERVE_STATIC_FILES=enabled"
echo "   - WEB_CONCURRENCY=2"
echo "   - RAILS_MAX_THREADS=5"
echo ""
echo "   Application-specific:"
echo "   - FRONTEND_URLS (your frontend URLs)"
echo "   - HOST_URL (your Render service URL)"
echo "   - MAILTRAP_USERNAME"
echo "   - MAILTRAP_PASSWORD"
echo ""

# GitHub Secrets needed
echo "7️⃣ GitHub Secrets Needed:"
echo "   Go to: GitHub Repo → Settings → Secrets and variables → Actions"
echo ""
echo "   Add these secrets:"
echo "   - RENDER_API_KEY (get from Render dashboard → Account Settings → API Keys)"
echo "   - RENDER_SERVICE_ID (get from Render service URL: srv-xxxxx)"
echo ""

# Next steps
echo "8️⃣ Next Steps:"
echo "   1. Create Render account at https://render.com"
echo "   2. Create PostgreSQL database in Render (free tier)"
echo "   3. Create Web Service in Render (free tier, Docker runtime)"
echo "   4. Add environment variables in Render dashboard"
echo "   5. Add GitHub secrets (step 7)"
echo "   6. Push to GitHub main branch to trigger deployment"
echo ""
echo "📚 For detailed instructions, see: DEPLOYMENT_GUIDE.md"
echo ""

# Offer to open the deployment guide
read -p "Would you like to open the deployment guide? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open DEPLOYMENT_GUIDE.md
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open DEPLOYMENT_GUIDE.md
    else
        echo "Please open DEPLOYMENT_GUIDE.md manually"
    fi
fi

echo ""
echo -e "${GREEN}Setup check complete! 🎉${NC}"
