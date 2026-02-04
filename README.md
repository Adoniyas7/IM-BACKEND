# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# IM-BACK - Insurance Management API

A comprehensive Ruby on Rails API for insurance management, handling policies, claims, quotations, and more.

## 🚀 Quick Start

### Local Development

1. **Prerequisites**
   * Ruby 3.4.2
   * PostgreSQL 16+
   * Docker (optional)

2. **Setup**

   ```bash
   # Install dependencies
   bundle install

   # Setup database
   rails db:create db:migrate db:seed

   # Start server
   rails server
   ```

3. **Using Docker**

   ```bash
   docker-compose up
   ```

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run security scan
bundle exec brakeman

# Run code style check
bundle exec rubocop
```

## 📦 Deployment

### Deploy to Render (Free Tier)

**Quick Deploy:**

1. Run setup script: `./scripts/render_setup.sh`
2. Follow the prompts
3. See [QUICK_START.md](QUICK_START.md) for fast deployment

**Detailed Instructions:**

* **Full Guide**: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
* **Checklist**: [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)

### CI/CD with GitHub Actions

Automatic deployment on pull request merge to `main` branch:

* ✅ Runs tests on every PR
* ✅ Security scan (Brakeman)
* ✅ Code quality check (Rubocop)
* ✅ Deploys to Render when PR is merged

**Workflow:**

1. Create feature branch
2. Make changes and create PR
3. Tests run automatically
4. Merge PR → Auto-deploy! 🚀

## 🛠 Technology Stack

* **Framework**: Rails 8.0.1
* **Database**: PostgreSQL
* **Authentication**: JWT
* **Background Jobs**: Solid Queue
* **Caching**: Solid Cache
* **Real-time**: Solid Cable
* **Email**: Mailtrap (development)
* **Web Server**: Puma + Thruster

## 📚 API Documentation

### Authentication Endpoints

* `POST /auth/register` - Register new user

* `POST /auth/login` - Login
* `POST /auth/logout` - Logout
* `POST /auth/refresh` - Refresh token
* `POST /auth/forgot_password` - Password reset request
* `POST /auth/reset_password` - Reset password

### Resource Endpoints

* `/insurance_types` - Insurance type management

* `/vehicles` - Vehicle management
* `/quotation_requests` - Quote requests
* `/policies` - Insurance policies
* `/claims` - Claims management
* `/users` - User management
* `/insurers` - Insurer management
* `/insurance_products` - Product management

### Health Check

* `GET /health` - Application health status

* `GET /up` - Rails health check

## 🔐 Environment Variables

See [.env.production.example](.env.production.example) for all required environment variables.

**Required for Production:**

* `RAILS_MASTER_KEY`
* `DATABASE_URL`
* `RAILS_ENV`
* `SECRET_KEY_BASE`

## 📁 Project Structure

```
app/
├── controllers/    # API controllers
├── models/         # Data models
├── serializers/    # JSON serializers
├── policies/       # Authorization policies
├── services/       # Business logic
└── mailers/        # Email templates

config/
├── routes.rb       # API routes
├── database.yml    # Database config
└── initializers/   # App initialization

spec/
├── models/         # Model tests
├── requests/       # API tests
└── services/       # Service tests
```

## 🧪 Testing

```bash
# Run all specs
bundle exec rspec

# Run specific spec file
bundle exec rspec spec/models/user_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

## 🔒 Security

* JWT-based authentication
* Role-based access control (Pundit)
* Regular security scans (Brakeman)
* CORS configuration
* Environment-based secrets

## 📝 License

This project is proprietary.

## 👥 Contributors

* Development Team

## 🆘 Support

For deployment issues, see:

* [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Comprehensive deployment guide
* [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) - Pre-flight checklist
* [QUICK_START.md](QUICK_START.md) - Quick deployment steps

---

**Production URL**: <https://im-back-api.onrender.com> (update after deployment)
