# Users.json Generation Instructions

## Overview
The `users.json` file contains test data for creating users via API. This file is used with the Postman collection to automatically create multiple users with intelligent field assignment logic.

## File Structure
The file should contain a JSON array of user objects. Each user object represents one user to be created.

## Required Fields

### Mandatory Fields (Always Required)
- `email_address`: User's email address (string, must be unique)
- `username`: Username for login (string, must be unique)
- `lastname`: User's last name (string)
- `firstname`: User's first name (string)
- `language_id`: Language preference (string/number)
  - `"1"` = English
  - `"2"` = German
  - `"3"` = Spanish

### Optional Fields with Smart Assignment Logic
- `department_id`: Department assignment (string/number)
- `timesheet_template_id`: Work schedule assignment (string/number)

## Smart Assignment Logic

### Department ID (`department_id`)
1. **Field provided with value** → Uses the specified department ID
   ```json
   "department_id": "77"
   ```

2. **Field not included** → Randomly selects from available departments that is got from departments/read endpoint in pre-script
   ```json
   {
     "email_address": "user@example.com",
     "username": "user@example.com"
     // department_id field is missing
   }
   ```

3. **Field included but empty** → Uses default value `1` that is in DB No department
   ```json
   "department_id": ""
   ```

### Timesheet Template ID (`timesheet_template_id`)
1. **Field provided with value** → Uses the specified workschedule ID
   ```json
   "timesheet_template_id": "4"
   ```

2. **Field not included** → Randomly selects from available workschedules that is got from workschedules/read endpoint in pre-script
   ```json
   {
     "email_address": "user@example.com",
     "username": "user@example.com"
     // timesheet_template_id field is missing
   }
   ```

3. **Field included but empty** → Uses default value `1` that is in DB No Workschedule
   ```json
   "timesheet_template_id": ""
   ```

## Example Users.json File

```json
[
  {
    "email_address": "sarah.johnson@timetac.com",
    "username": "sarah.johnson@timetac.com",
    "department_id": "1",
    "lastname": "Johnson",
    "firstname": "Sarah",
    "language_id": "1",
    "timesheet_template_id": "4"
  },
  {
    "email_address": "michael.davis@timetac.com",
    "username": "michael.davis@timetac.com",
    "lastname": "Davis",
    "firstname": "Michael",
    "language_id": "2"
  },
  {
    "email_address": "lisa.white@timetac.com",
    "username": "lisa.white@timetac.com",
    "department_id": "",
    "lastname": "White",
    "firstname": "Lisa",
    "language_id": "1",
    "timesheet_template_id": ""
  }
]
```

### Example Explanation:
- **Sarah Johnson**: Uses provided department ID `1` and timesheet template ID `4`
- **Michael Davis**: Gets random department and workschedule (fields not included)
- **Lisa White**: Gets default value `1` for both fields (fields included but empty)

## Field Values and Constraints

### Email Address & Username
- Must be unique across all users
- Should follow email format for `email_address`
- Must be the same value for both fields
- should have timetac domain
- Example formats:
  - `firstname.lastname@timetac.com`

### Department ID
- Valid values are fetched dynamically from `/departments/read/`
- Common values: `1` (No Department), `77`, `78`, `79`
- Can be string or number format: `"1"` or `1`

### Timesheet Template ID  
- Valid values are fetched dynamically from `/workSchedules/read/`
- Common values: `1`, `4`, `8`, `9`, `10`, `11`, etc.
- Can be string or number format: `"4"` or `4`

### Language ID
- `"1"` = English
- `"2"` = German  
- `"3"` = Spanish
- Add more as needed based on system configuration

## Automatic Field Assignment

### Fixed Fields (Set Automatically)
These fields are automatically assigned by the collection and don't need to be in the JSON:
- `password`: Always set to `"12345aC!"`
- `internal_user_group`: Always set to `"2"`

### Available Departments and Workschedules
The collection automatically fetches available options before user creation:
- **Departments**: Retrieved from API call to `/departments/read/?active=true`
- **Workschedules**: Retrieved from API call to `/workSchedules/read/?active=true`

## Usage Instructions

1. **Create the file**: Save as `users.json` in the project root
2. **Validate JSON**: Ensure proper JSON syntax (use JSON validator if needed)
3. **Run the collection**: Execute with `./create_test_data.sh users`
4. **Check logs**: Review output for assignment logic and any errors

## Tips for Bulk Generation

### For Testing Different Scenarios:
```json
[
  {
    "email_address": "explicit.user@timetac.com",
    "username": "explicit.user@timetac.com", 
    "department_id": "77",
    "lastname": "Explicit",
    "firstname": "User",
    "language_id": "1",
    "timesheet_template_id": "4"
  },
  {
    "email_address": "random.user@timetac.com",
    "username": "random.user@timetac.com",
    "lastname": "Random", 
    "firstname": "User",
    "language_id": "1"
  },
  {
    "email_address": "default.user@timetac.com",
    "username": "default.user@timetac.com",
    "department_id": "",
    "lastname": "Default",
    "firstname": "User", 
    "language_id": "1",
    "timesheet_template_id": ""
  }
]
```

### For Mass User Creation:
- Use consistent naming patterns
- Increment usernames/emails systematically
- Mix assignment strategies for comprehensive testing
- Consider using scripts to generate large datasets

## Troubleshooting

### Common Issues:
1. **Duplicate usernames/emails**: Each must be unique
2. **Invalid JSON syntax**: Use JSON linter to validate
3. **Invalid department/workschedule IDs**: Check available values in logs
4. **Missing required fields**: Ensure all mandatory fields are present

### Validation:
- The collection will log which assignment logic is used for each user
- Check the verbose output for detailed field assignment information
- Failed creations will show specific error messages

## Integration with Collection

The `users.json` file works with the Postman collection's pre-request scripts that:
1. Fetch available departments and workschedules
2. Apply the smart assignment logic
3. Set appropriate values for each user creation request
4. Log the assignment decisions for debugging

This ensures that users are created with valid, appropriate field values based on the current system state.