# Quick Start: Deploy to Render

## 1. Get Your Master Key
```bash
cat config/master.key
```
Save this - you'll need it for Render!

## 2. Push to GitHub
```bash
git add .
git commit -m "Add Render deployment configuration"
git push origin main
```

## 3. Create Render Account
- Go to [render.com](https://render.com)
- Sign up with GitHub

## 4. Create PostgreSQL Database
1. Click **New +** → **PostgreSQL**
2. Name: `im-back-db`
3. Region: Oregon
4. Plan: **Free**
5. Click **Create Database**
6. Copy the **Internal Database URL**

## 5. Create Web Service
1. Click **New +** → **Web Service**
2. Connect your GitHub repo
3. Name: `im-back-api`
4. Runtime: **Docker**
5. Plan: **Free**

## 6. Add Environment Variables in Render
- `RAILS_MASTER_KEY` = (from step 1)
- `DATABASE_URL` = (from step 4)
- `RAILS_ENV` = `production`
- `RAILS_LOG_TO_STDOUT` = `enabled`
- `RAILS_SERVE_STATIC_FILES` = `enabled`

## 7. Add GitHub Secrets
1. Get Render API key: Render → Account Settings → API Keys
2. Get Service ID: From service URL `srv-xxxxx`
3. GitHub repo → Settings → Secrets → Actions
4. Add:
   - `RENDER_API_KEY`
   - `RENDER_SERVICE_ID`

## 8. Deploy!
Push to main branch and watch the magic happen! ✨

---

**Need detailed instructions?** See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
