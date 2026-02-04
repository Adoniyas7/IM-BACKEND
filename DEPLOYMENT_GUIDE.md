# Deploy Rails App to Render with GitHub Actions CI/CD

This guide walks you through deploying your Rails application to Render.com's free tier using GitHub Actions for continuous deployment.

## Prerequisites

- GitHub account
- Render.com account (free)
- Git repository hosted on GitHub
- Rails application ready to deploy

---

## Step 1: Prepare Your Application

### 1.1 Fix Database Configuration

Your `config/database.yml` already supports environment variables, but for Render, we need to support the `DATABASE_URL` format.

Add this to the top of your `config/database.yml`:

```yaml
production:
  <<: *default
  url: <%= ENV['DATABASE_URL'] %>
```

This will override the individual database settings when `DATABASE_URL` is provided (Render's default).

### 1.2 Ensure Environment Variables are Gitignored

✅ Your `.gitignore` already ignores `.env*` files - good!

### 1.3 Update Dockerfile (if needed)

Your Dockerfile looks good! Just ensure the startup command uses the PORT environment variable that Render provides.

---

## Step 2: Set Up Render Account

### 2.1 Create Render Account
1. Go to [https://render.com](https://render.com)
2. Sign up with your GitHub account (recommended for easier integration)
3. Verify your email address

### 2.2 Connect GitHub Repository
1. In Render dashboard, go to **Account Settings** → **GitHub**
2. Click **Connect GitHub Account**
3. Authorize Render to access your repositories
4. Select the repository `IM-BACK`

---

## Step 3: Create PostgreSQL Database

### 3.1 Create Database Service
1. From Render dashboard, click **New +** → **PostgreSQL**
2. Fill in the details:
   - **Name**: `im-back-db`
   - **Database**: `im_back_production`
   - **User**: `im_back_user`
   - **Region**: `Oregon (US West)` (free tier)
   - **Plan**: **Free**
3. Click **Create Database**
4. Wait for database to be provisioned (2-3 minutes)

### 3.2 Note Database Details
After creation, you'll see:
- **Internal Database URL**: Used by your app
- **External Database URL**: For external connections
- Save these for reference

---

## Step 4: Create Web Service

### 4.1 Create New Web Service
1. Click **New +** → **Web Service**
2. Select **Deploy an existing image from a registry** → **Build and deploy from a Git repository**
3. Connect your `IM-BACK` repository
4. Configure service:
   - **Name**: `im-back-api`
   - **Region**: `Oregon (US West)`
   - **Branch**: `main`
   - **Runtime**: **Docker**
   - **Instance Type**: **Free**

### 4.2 Configure Build Settings
- **Dockerfile Path**: `./Dockerfile`
- **Docker Context**: `.`
- **Docker Command**: Leave empty (uses Dockerfile's CMD)

### 4.3 Set Environment Variables
Click **Add Environment Variable** for each:

| Key | Value | Secret? |
|-----|-------|---------|
| `RAILS_ENV` | `production` | No |
| `RAILS_LOG_TO_STDOUT` | `enabled` | No |
| `RAILS_SERVE_STATIC_FILES` | `enabled` | No |
| `WEB_CONCURRENCY` | `2` | No |
| `RAILS_MAX_THREADS` | `5` | No |
| `DATABASE_URL` | *From database* (see below) | Yes |
| `RAILS_MASTER_KEY` | *Your master key* (see below) | Yes |
| `FRONTEND_URLS` | Your frontend URLs | No |
| `HOST_URL` | Your Render service URL | No |
| `MAILTRAP_USERNAME` | Your Mailtrap username | Yes |
| `MAILTRAP_PASSWORD` | Your Mailtrap password | Yes |

**Getting DATABASE_URL:**
- Go to your `im-back-db` database in Render
- Copy the **Internal Database URL**
- Paste it as the `DATABASE_URL` value

**Getting RAILS_MASTER_KEY:**
```bash
# On your local machine, run:
cat config/master.key
```
Copy the output and paste it into Render.

### 4.4 Set Health Check
- **Health Check Path**: `/` or create a `/health` endpoint

### 4.5 Create Web Service
Click **Create Web Service**

---

## Step 5: Configure GitHub Actions

### 5.1 Get Render API Key
1. In Render dashboard, click your profile → **Account Settings**
2. Scroll to **API Keys** section
3. Click **Create API Key**
4. Name it: `github-actions-deploy`
5. Copy the generated key

### 5.2 Get Service ID
1. Go to your `im-back-api` service in Render
2. Look at the URL: `https://dashboard.render.com/web/srv-XXXXXXXXXXXXX`
3. The `srv-XXXXXXXXXXXXX` part is your **Service ID**

### 5.3 Add GitHub Secrets
1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add these secrets:

| Name | Value |
|------|-------|
| `RENDER_API_KEY` | Your Render API key from Step 5.1 |
| `RENDER_SERVICE_ID` | Your Service ID from Step 5.2 |

---

## Step 6: Initial Database Setup

### 6.1 Run Database Migrations
After the first deployment completes:

1. Go to your web service in Render dashboard
2. Click **Shell** tab
3. Run:
```bash
bundle exec rails db:migrate
bundle exec rails db:seed  # If you have seed data
```

Alternatively, you can add this to your Render build command in the dashboard:
```bash
bundle exec rails db:migrate
```

---

## Step 7: Deploy and Test

### 7.1 Push to GitHub
```bash
git add .
git commit -m "Add Render deployment configuration"
git push origin main
```

### 7.2 Create and Merge Pull Request
For automatic deployment:
```bash
# Create a feature branch
git checkout -b add-deployment-config

# Push to GitHub
git push origin add-deployment-config

# Go to GitHub and create a Pull Request to main
# Tests will run automatically
# When tests pass, merge the PR
# Deployment will trigger automatically!
```

Or push directly to main (not recommended for production):
```bash
git push origin main
```

### 7.3 Monitor Deployment
1. Go to **GitHub** → **Actions** tab
2. Watch the workflow run:
   - ✅ Tests run on PR creation
   - ✅ Security scan (Brakeman)
   - ✅ Code style check (Rubocop)
   - ✅ After PR merge → Deploy to Render triggered

3. Go to **Render dashboard** → **Events** tab
4. Watch the build and deployment logs

### 7.4 Access Your Application
Once deployed:
1. Your app URL: `https://im-back-api.onrender.com` (or similar)
2. Test endpoints:
   ```bash
   curl https://im-back-api.onrender.com/
   ```

---

## Step 8: Set Up Custom Domain (Optional)

### 8.1 Add Custom Domain
1. In Render service dashboard, click **Settings**
2. Scroll to **Custom Domains**
3. Click **Add Custom Domain**
4. Enter your domain (e.g., `api.yourdomain.com`)
5. Follow DNS configuration instructions

---

## Common Issues and Solutions

### Issue 1: Database Connection Errors
**Solution:**
- Verify `DATABASE_URL` is set correctly in Render
- Check database is in same region as web service
- Ensure database is running (check Render dashboard)

### Issue 2: Master Key Missing
**Error:** `Missing encryption key to decrypt file with`

**Solution:**
```bash
# Generate new credentials if needed
EDITOR=nano rails credentials:edit
# Copy the key from config/master.key
# Add it to Render environment variables
```

### Issue 3: Asset Compilation Fails
**Solution:**
Add to environment variables:
- `RAILS_SERVE_STATIC_FILES=enabled`
- `SECRET_KEY_BASE` (generate with: `rails secret`)

### Issue 4: Port Binding Issues
**Solution:**
Render automatically sets the `PORT` environment variable. Ensure your `config/puma.rb` uses:
```ruby
port ENV.fetch("PORT", 3000)
```
✅ Your config already has this!

### Issue 5: Free Tier Limitations
**Note:** Render's free tier:
- Spins down after 15 minutes of inactivity
- First request after spin-down takes ~30-60 seconds
- 750 hours/month free
- Shared CPU/RAM resources

**Solution:**
- Use a service like UptimeRobot to ping your app every 14 minutes (keeps it awake)
- Or upgrade to paid tier for always-on service

---

## Maintenance and Updates

### Triggering Manual Deployment
```bash
# From GitHub Actions tab
# Click "Deploy to Render" workflow
# Click "Run workflow" button
# Select branch: main
# Click "Run workflow"
```

Or merge a pull request to main branch.

### Viewing Logs
```bash
# In Render dashboard
Go to Service → Logs tab
```

### Database Backups (Free Tier)
**Note:** Free tier doesn't include automatic backups

**Manual Backup:**
1. Render dashboard → Database → Shell
2. Run:
```bash
pg_dump $DATABASE_URL > backup.sql
```

Or use external tools to schedule backups.

### Rolling Back Deployment
1. Render dashboard → Service → Events
2. Find previous successful deployment
3. Click **Rollback** button

---

## Environment-Specific Configuration

### Development
```bash
# .env.development
DB_USERNAME=postgres
DB_PASSWORD=pa55w07d
DB_HOST=localhost
DB_PORT=5432
```

### Production (Render)
All set via Render dashboard environment variables

---

## Security Checklist

- [ ] `.env` files are gitignored
- [ ] `RAILS_MASTER_KEY` is in Render (not in code)
- [ ] Database credentials are environment variables
- [ ] API keys are stored as GitHub secrets
- [ ] CORS is configured for your frontend URLs
- [ ] SSL/HTTPS is enabled (Render does this automatically)

---

## Monitoring and Alerts

### Set Up Notifications
1. Render dashboard → Service → Settings
2. Scroll to **Deploy Notifications**
3. Add email or Slack webhook

### GitHub Actions Notifications
- Already included in the workflow
- Check Actions tab for build status
- Failed builds will show in GitHub UI

---

## Next Steps

1. **Set up monitoring**: Add application monitoring (e.g., Sentry, Rollbar)
2. **Configure CI/CD branch rules**: Add staging environment
3. **Database backups**: Set up automated backup solution
4. **Performance monitoring**: Add APM tool (New Relic, Scout)
5. **Custom domain**: Configure your own domain
6. **CDN**: Add Cloudflare for caching and DDoS protection

---

## Useful Commands

```bash
# View Render logs locally
render logs --service im-back-api

# Install Render CLI
brew install render

# Connect to production database (use external URL)
psql <EXTERNAL_DATABASE_URL>

# Run Rails console on Render
# Go to Render dashboard → Shell tab
bundle exec rails console
```

---

## Resources

- [Render Documentation](https://render.com/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Rails Deployment Guide](https://guides.rubyonrails.org/deployment.html)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---

## Support

If you encounter issues:
1. Check Render logs: Service → Logs
2. Check GitHub Actions logs: Actions tab
3. Render Community: [community.render.com](https://community.render.com)
4. Render Support: support@render.com

---

**Last Updated:** February 2026
