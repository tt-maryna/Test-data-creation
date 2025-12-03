# Security Configuration Guide

## Setup Instructions

### Configure `stage-env.json`

The `stage-env.json` file needs to be updated with your actual credentials:
- `url`: API endpoint URL
- `account`: Your TimeTac account name
- `version`: API version
- `username`: Your API username
- `password`: Your API password
- `client_id`: Client identifier
- `client_secret`: Your OAuth client secret

**Important**: The `stage-env.json` file is in `.gitignore`, so your credentials will not be pushed to the repository.

## Best Practices

✅ Update `stage-env.json` with your own credentials  
✅ Your credentials are safe - the file is ignored by git  
❌ Never remove `stage-env.json` from `.gitignore`
