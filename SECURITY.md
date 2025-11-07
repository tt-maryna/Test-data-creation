# Security Configuration Guide

## Protecting Sensitive Credentials

This project requires API credentials that should **NEVER** be committed to the public repository.

## Setup Instructions

### 1. Copy the example environment file
```bash
cp .env.example .env
```

### 2. Edit `.env` with your actual credentials
```bash
# Edit the .env file and replace placeholder values
nano .env  # or use your preferred editor
```

### 3. Configure `stage-env.json`
The `stage-env.json` file contains placeholder values. Replace them with your actual credentials:
- `account`: Your TimeTac account name
- `username`: Your API username
- `password`: Your API password
- `client_secret`: Your OAuth client secret

**Important**: The `stage-env.json` file is ignored by git (see `.gitignore`), so your actual credentials won't be pushed to the repository.

### 4. Files Ignored by Git (`.gitignore`)
The following files contain sensitive data and are automatically ignored:
- `.env` - Environment variables
- `stage-env.json` - Postman environment with credentials
- `*.env.local` - Local environment overrides
- `output.txt` - API response logs that may contain sensitive data
- `temp_extracted_ids.json` - Temporary files with API data

## Alternative: Use Environment Variables with Newman

Instead of storing credentials in `stage-env.json`, you can pass them via command line:

```bash
newman run test_collection.json \
  --env-var "username=$TIMETAC_USERNAME" \
  --env-var "password=$TIMETAC_PASSWORD" \
  --env-var "client_secret=$TIMETAC_CLIENT_SECRET" \
  --env-var "account=$TIMETAC_ACCOUNT"
```

## For Team Members

1. Contact the repository owner for the actual credential values
2. Never commit the real `stage-env.json` file
3. Never commit `.env` files
4. Use the placeholder files (`.env.example`, `stage-env.json` template) as reference

## Checking Before Commit

Always verify you're not committing secrets:
```bash
git status
git diff
```

If you accidentally committed secrets:
```bash
# Remove from latest commit
git reset HEAD~1

# Or remove sensitive file from git history (use with caution)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch stage-env.json" \
  --prune-empty --tag-name-filter cat -- --all
```

## Best Practices

1. ✅ Use placeholder values in tracked files
2. ✅ Add sensitive files to `.gitignore`
3. ✅ Use environment variables for CI/CD
4. ✅ Create `.example` files to show structure
5. ❌ Never commit real credentials
6. ❌ Never share credentials in chat/email
7. ❌ Never hardcode secrets in code
