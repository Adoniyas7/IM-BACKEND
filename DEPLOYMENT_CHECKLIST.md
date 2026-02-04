# Render Deployment Checklist

Use this checklist to ensure you have everything ready for deployment.

## Pre-Deployment Setup

### Local Environment

- [ ] Run `./scripts/render_setup.sh` to verify your setup
- [ ] Ensure `config/master.key` exists and is backed up
- [ ] All tests pass: `bundle exec rspec`
- [ ] Security scan passes: `bundle exec brakeman`
- [ ] Code style check passes: `bundle exec rubocop`
- [ ] Application runs locally: `rails server`

### Git and GitHub

- [ ] Code is committed to Git
- [ ] Repository is pushed to GitHub
- [ ] Repository is public or Render has access
- [ ] Main branch is up to date

## Render Account Setup

### Database (PostgreSQL)

- [ ] Created PostgreSQL database on Render
- [ ] Database name: `im-back-db`
- [ ] Region: Oregon (US West) for free tier
- [ ] Plan: Free
- [ ] Copied Internal Database URL

### Web Service

- [ ] Created Web Service on Render
- [ ] Service name: `im-back-api`
- [ ] Runtime: Docker
- [ ] Region: Oregon (same as database)
- [ ] Plan: Free
- [ ] Branch: main
- [ ] Dockerfile path: `./Dockerfile`

### Environment Variables in Render

Required:

- [ ] `RAILS_MASTER_KEY` (from `config/master.key`)
- [ ] `DATABASE_URL` (from database service)
- [ ] `RAILS_ENV=production`
- [ ] `RAILS_LOG_TO_STDOUT=enabled`
- [ ] `RAILS_SERVE_STATIC_FILES=enabled`

Recommended:

- [ ] `WEB_CONCURRENCY=2`
- [ ] `RAILS_MAX_THREADS=5`
- [ ] `SECRET_KEY_BASE` (generate with `rails secret`)

Application-specific:

- [ ] `FRONTEND_URLS` (your frontend URLs)
- [ ] `HOST_URL` (your Render service URL)
- [ ] `MAILTRAP_USERNAME`
- [ ] `MAILTRAP_PASSWORD`

### Build Settings

- [ ] Build command: `bundle install && bundle exec rails db:migrate`
- [ ] Start command: `bin/thruster` (or leave empty)
- [ ] Health check path: `/health`

## GitHub Actions Setup

### GitHub Secrets

- [ ] Created Render API Key in Render dashboard
- [ ] Added `RENDER_API_KEY` to GitHub secrets
- [ ] Copied Service ID from Render (srv-xxxxx)
- [ ] Added `RENDER_SERVICE_ID` to GitHub secrets

### Workflow File

- [ ] `.github/workflows/deploy.yml` exists
- [ ] Workflow has correct service ID reference
- [ ] Workflow has correct branch (main)

## Initial Deployment

### First Deploy

- [ ] Pushed code to main branch
- [ ] GitHub Actions workflow started
- [ ] Tests passed in CI
- [ ] Security scan passed
- [ ] Deployment triggered
- [ ] Render build started
- [ ] Render build completed successfully

### Database Setup

- [ ] Migrations ran successfully
- [ ] Seed data loaded (if applicable)
- [ ] Can connect to database from Render shell

### Verification

- [ ] Service is running: `https://im-back-api.onrender.com`
- [ ] Health check works: `https://im-back-api.onrender.com/health`
- [ ] Database connection works
- [ ] Can access API endpoints
- [ ] Authentication works
- [ ] CORS configured correctly

## Post-Deployment

### Monitoring

- [ ] Checked deployment logs for errors
- [ ] Set up deploy notifications (email/Slack)
- [ ] Tested all critical endpoints
- [ ] Verified email sending works

### Documentation

- [ ] Updated README with production URL
- [ ] Documented environment variables
- [ ] Team members know how to access logs
- [ ] Rollback procedure documented

### Security

- [ ] All secrets are in environment variables (not code)
- [ ] `.env` files are gitignored
- [ ] SSL/HTTPS is enabled (automatic with Render)
- [ ] CORS is properly configured
- [ ] Database is only accessible from Render services

## Optional Enhancements

### Performance

- [ ] Set up UptimeRobot to prevent spin-down (free tier)
- [ ] Configured CDN (Cloudflare)
- [ ] Optimized database queries
- [ ] Added caching where appropriate

### Monitoring & Alerts

- [ ] Set up application monitoring (Sentry, Rollbar)
- [ ] Set up uptime monitoring
- [ ] Configure error alerting
- [ ] Set up performance monitoring (APM)

### Additional Features

- [ ] Custom domain configured
- [ ] DNS records updated
- [ ] SSL certificate verified
- [ ] Staging environment created
- [ ] Database backup strategy implemented

## Troubleshooting

If deployment fails, check:

- [ ] Render build logs
- [ ] Render runtime logs
- [ ] GitHub Actions logs
- [ ] Environment variables are set correctly
- [ ] Database is accessible
- [ ] Master key is correct
- [ ] All migrations ran successfully

## Resources

- **Deployment Guide**: `DEPLOYMENT_GUIDE.md`
- **Quick Start**: `QUICK_START.md`
- **Setup Script**: `./scripts/render_setup.sh`
- **Render Dashboard**: <https://dashboard.render.com>
- **GitHub Actions**: <https://github.com/your-repo/actions>

---

**Notes:**

- Free tier has 750 hours/month limit
- Services spin down after 15 minutes of inactivity
- First request after spin-down takes ~30-60 seconds
- Database has 90-day retention on free tier
