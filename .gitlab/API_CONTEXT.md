# Timetac API - Context for GitHub Copilot

## Overview
This document provides context about the Time Tracking API based on the Postman collection `test_collection.json`. This collection is designed for automated testing and bulk data creation with smart field assignment logic and comprehensive authentication handling.

## Collection Information
- **Name**: "Run collection with data file"
- **Version**: Postman Collection v2.1.0
- **Purpose**: Automated testing and bulk data operations with data file support
- **Authentication**: OAuth2 password grant with automatic token management

## Base URL Structure
- Base URL: `{{url}}/{{account}}/{{version}}/`
- Environment Variables:
  - `{{url}}`: Base API URL
  - `{{account}}`: Account identifier
  - `{{version}}`: API version
  - `{{username}}`: OAuth username
  - `{{password}}`: OAuth password
  - `{{client_id}}`: OAuth client ID
  - `{{client_secret}}`: OAuth client secret

## Authentication System
The collection includes automatic OAuth2 token management:
- **Token Endpoint**: `{{url}}/{{account}}/auth/oauth2/token`
- **Grant Type**: password
- **Auto-refresh**: Token is automatically obtained if not present
- **Headers**: `Authorization: Bearer {{access_token}}`

## API Endpoints by Category

### 1. Time Tracking Operations

#### Create Time Tracking
**POST** `{{url}}/{{account}}/{{version}}/timeTrackings/create/`

**Headers:**
- `Authorization: Bearer {{access_token}}`
- `Content-Type: application/x-www-form-urlencoded`

**Required Body Parameters:**
- `user_id`: User identifier (string)
- `task_id`: Task identifier (string)
- `start_time`: Start timestamp (format: "YYYY-MM-DD HH:MM:SS")
- `end_time`: End timestamp (format: "YYYY-MM-DD HH:MM:SS")
- `start_time_timezone`: Start timezone (auto-assigned "Europe/Vienna" if missing)
- `end_time_timezone`: End timezone (auto-assigned "Europe/Vienna" if missing)

**Smart Timezone Assignment:**
- Missing fields: Automatically defaults to "Europe/Vienna"
- Present fields: Uses provided values
- Logging: All assignment decisions are logged

### 2. Department Operations

#### Create Department
**POST** `{{url}}/{{account}}/{{version}}/departments/create/`

**Headers:**
- `Authorization: Bearer {{access_token}}`

**Required Body Parameters:**
- `department_name`: Department name (string)
- `mother_id`: Parent department ID (string)

**Optional Body Parameters:**
- `supervisor_id`: Supervisor user ID (disabled by default)
- `supervisor_assistant_id`: Assistant supervisor ID (disabled by default)

### 3. Task Operations

#### Create Task
**POST** `{{url}}/{{account}}/{{version}}/tasks/create/`

**Headers:**
- `Authorization: Bearer {{access_token}}`
- `Content-Type: application/x-www-form-urlencoded`

**Required Body Parameters:**
- `mother_id`: Parent task ID (string)
- `name`: Task name (string)
- `is_billable`: Billable status (string)
- `is_paid_non_working`: Paid non-working status (string)
- `is_nonworking`: Non-working status (string)
- `task_type`: Task type identifier (string)

### 4. User Operations

#### Read Departments (for User Creation)
**GET** `{{url}}/{{account}}/{{version}}/departments/read/?active=true`

**Headers:**
- `Authorization: Bearer {{access_token}}`

**Query Parameters:**
- `active`: Filter for active departments (value: "true")

**Purpose:** Fetches available department IDs for smart assignment in user creation

#### Read Work Schedules (for User Creation)
**GET** `{{url}}/{{account}}/{{version}}/workSchedules/read/?active=true`

**Headers:**
- `Authorization: Bearer {{access_token}}`

**Query Parameters:**
- `active`: Filter for active work schedules (value: "true")

**Purpose:** Fetches available work schedule IDs for smart assignment in user creation

#### Create User
**POST** `{{url}}/{{account}}/{{version}}/users/create/`

**Headers:**
- `Authorization: Bearer {{access_token}}`
- `Content-Type: application/x-www-form-urlencoded`

**Required Body Parameters:**
- `email_address`: User email (string)
- `username`: Username (string)
- `lastname`: Last name (string)
- `firstname`: First name (string)
- `password`: User password (default: "12345aC!")
- `language_id`: Language identifier (string)
- `internal_user_group`: User group (default: "2")

**Smart Assignment Parameters:**
- `department_id`: Auto-assigned from available departments or defaults to "1"
- `timesheet_template_id`: Auto-assigned from available work schedules or defaults to "1"

## Smart Assignment Logic

### Department ID Assignment (Users)
1. **Field Missing**: Randomly selects from available departments
2. **Field Empty**: Uses default value "1"
3. **Field Provided**: Uses specified value
4. **Fallback**: Default to "1" if no departments available

### Timesheet Template ID Assignment (Users)
1. **Field Missing**: Randomly selects from available work schedules
2. **Field Empty**: Uses default value "1" 
3. **Field Provided**: Uses specified value
4. **Fallback**: Default to "1" if no work schedules available

### Timezone Assignment (Time Trackings)
1. **Field Missing**: Automatically sets to "Europe/Vienna"
2. **Field Provided**: Uses specified timezone
3. **Logging**: All assignments are logged for debugging

## Data File Integration

### Supported Formats
- **Primary**: JSON files (users.json, timetrackings.json, etc.)
- **Alternative**: CSV files
- **Variables**: Collection consumes data file variables using `{{variable_name}}`

### Example Data Files

#### users.json Structure:
```json
[
  {
    "email_address": "anna.mueller@example.com",
    "username": "anna.mueller",
    "lastname": "Mueller", 
    "firstname": "Anna",
    "language_id": "1",
    "department_id": "2",
    "timesheet_template_id": ""
  }
]
```

#### timetrackings.json Structure:
```json
[
  {
    "user_id": "1",
    "task_id": "4",
    "start_time": "2025-06-02 08:15:00",
    "end_time": "2025-06-02 10:30:00"
  }
]
```

## Collection Structure

### Folder Organization:
1. **timetrackings** - Time tracking operations with timezone logic
2. **departments** - Department management
3. **tasks** - Task management  
4. **users** - User management with smart field assignment

### Pre-request Scripts:
- **Collection Level**: Automatic OAuth2 token acquisition
- **Folder Level**: Smart field assignment logic (timetrackings, users)
- **Request Level**: Individual request preprocessing

### Test Scripts:
- **Response Validation**: Status code verification
- **Data Storage**: Captures available IDs for smart assignment
- **Logging**: Comprehensive response logging

## Usage Patterns

### Running with Data Files:
1. Prepare JSON data file (users.json, timetrackings.json, etc.)
2. Use Collection Runner in Postman
3. Select data file during collection run
4. Monitor console logs for assignment decisions

### Shell Script Integration:
```bash
./create_test_data.sh users        # Run users folder with users.json
./create_test_data.sh timetrackings # Run timetrackings folder with timetrackings.json
./create_test_data.sh departments   # Run departments folder with departments.json
./create_test_data.sh tasks         # Run tasks folder with tasks.json
```

### Newman CLI Support:
- Supports SSL certificate configuration
- Verbose logging enabled
- Environment file integration
- Data file specification

## Error Handling

### Authentication:
- Automatic token refresh on failure
- Comprehensive error logging
- Fallback mechanisms

### Smart Assignment:
- Graceful degradation to defaults
- Error logging for assignment decisions
- Validation of field presence vs emptiness

### Request Failures:
- Detailed response logging
- Status code validation
- Error context preservation

## Environment Variables Required:
- `url`: Base API URL
- `account`: Account identifier  
- `version`: API version
- `username`: OAuth username
- `password`: OAuth password
- `client_id`: OAuth client ID
- `client_secret`: OAuth client secret

## Best Practices:
1. **Data Files**: Use consistent field naming and JSON structure
2. **Logging**: Monitor console output for assignment decisions
3. **Testing**: Validate data file structure before collection runs
4. **Environment**: Ensure all required environment variables are set
5. **SSL**: Configure certificates for HTTPS endpoints when needed

This collection provides a robust foundation for automated API testing with intelligent field assignment, comprehensive error handling, and flexible data file integration.
- `_write_permission_type`: Write permission type
- `_insert_into_conflicting`: Handle conflicting entries
- `_is_offline_live_tracking`: Offline tracking flag
- `_request_user_comment`: Request user comment

### 4. Update Time Tracking
**PUT** `{{url}}/{{account}}/{{version}}/timetrackings/update/`

Required Body Parameters:
- `id`: Time tracking ID

Optional Body Parameters (same as create, plus):
- `status`: Status code
- `_entity_to_create`: Entity creation flag

### 5. Start Time Tracking
**POST** `{{url}}/{{account}}/{{version}}/timeTrackings/start/`

Required Body Parameters:
- `user_id`: User identifier
- `task_id`: Task identifier
- `start_type_id`: Start type identifier
- `start_time_timezone`: Timezone

### 6. Stop Time Tracking
**PUT** `{{url}}/{{account}}/{{version}}/timeTrackings/stop/`

Required Body Parameters:
- `end_time_timezone`: Timezone
- `user_id`: User identifier
- `end_time`: End timestamp
- `geo_end_lat`: End latitude
- `geo_end_long`: End longitude
- `geo_end_accuracy`: GPS accuracy

### 7. Toggle Time Tracking
**POST** `{{url}}/{{account}}/userapi/{{version}}/timetrackings/toggle/`

Required Body Parameters:
- `timezone`: Timezone
- `user_id`: User identifier

### 8. Split Time Tracking
**POST** `{{url}}/{{account}}/{{version}}/timetrackings/split/`

Required Body Parameters:
- `id`: Time tracking ID to split
- `time`: Split timestamp
- `timezone`: Timezone

### 9. Approve Time Tracking
**PUT** `{{url}}/{{account}}/userapi/{{version}}/timeTrackings/approve/`

Required Body Parameters:
- `id`: Time tracking ID

Optional Body Parameters:
- `_granted_user_comment`: Admin comment

### 10. Reject Time Tracking
**PUT** `{{url}}/{{account}}/{{version}}/timeTrackings/reject/`

Required Body Parameters:
- `id`: Time tracking ID

Optional Body Parameters:
- `_granted_user_comment`: Admin comment

### 11. Cancel Time Tracking
**PUT** `{{url}}/{{account}}/{{version}}/timeTrackings/cancel/`

Required Body Parameters:
- `id`: Time tracking ID

Optional Body Parameters:
- `_granted_user_comment`: Admin comment

### 12. Delete Time Tracking
**DELETE** `{{url}}/{{account}}/userapi/{{version}}/timeTrackings/delete/{id}`

Path Parameters:
- `{id}`: Time tracking ID to delete

## Common Patterns

### Authentication
All requests require Bearer token authentication:
```
Authorization: Bearer {{access_token}}
```

### Content Types
- GET requests: No body
- POST/PUT requests: `application/x-www-form-urlencoded`

### Timezone Format
Use standard timezone identifiers like "Europe/Vienna"

### Timestamp Format
Use format: "YYYY-MM-DD HH:MM:SS" (e.g., "2025-10-16 08:35:00")

### Custom Fields
- Task custom fields: `t_iv_1` through `t_iv_6`
- User custom fields: `u_iv_1` through `u_iv_6`

### Geolocation Fields
- Start location: `geo_start_lat`, `geo_start_long`, `geo_start_accuracy`
- End location: `geo_end_lat`, `geo_end_long`, `geo_end_accuracy`
- General location: `geo_lat`, `geo_long`, `geo_accuracy`

### Special Parameters
- `_fetch_deleted`: Include deleted records
- `_write_permission_type`: Permission handling
- `_insert_into_conflicting`: Conflict resolution
- `_is_offline_live_tracking`: Offline mode
- `_request_user_comment`: Request comments
- `_granted_user_comment`: Admin comments
- `_entity_to_create`: Entity creation

## Usage Examples

### Creating a time tracking entry:
```javascript
const timeTracking = {
  user_id: "1",
  task_id: "4", 
  start_time: "2025-10-16 08:35:00",
  end_time: "2025-10-16 09:35:00",
  start_time_timezone: "Europe/Vienna",
  end_time_timezone: "Europe/Vienna"
};
```

### Starting time tracking:
```javascript
const startTracking = {
  user_id: "39",
  task_id: "4",
  start_type_id: "1",
  start_time_timezone: "Europe/Vienna"
};
```

### Stopping time tracking:
```javascript
const stopTracking = {
  end_time_timezone: "Europe/Vienna",
  user_id: "39", 
  end_time: "2025-07-01 08:34:00",
  geo_end_lat: "1000",
  geo_end_long: "1000",
  geo_end_accuracy: "100"
};
```

This API follows RESTful conventions with specialized endpoints for time tracking operations like start/stop/toggle functionality commonly needed in time tracking applications.