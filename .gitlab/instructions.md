# Time Tracking API - Context for GitHub Copilot

## Overview
This document provides context about a Time Tracking API based on the Postman collection `test.postman_collection.json`. Use this information to understand the API structure, endpoints, and parameters when generating code or providing suggestions.

## TestProject Structure

The TestProject is organized as follows:

```
TestProject/
├── .gitlab/
│   ├── instructions.md                # Instructions for generating each test data file
│   ├── API_CONTEXT.md                 # API documentation and context
│   ├── users_instruction.md           # Instructions for generating users.json
│   └── timetrackings_instruction.md   # Instructions for generating timetrackings.json
├── test_data/
│   ├── departments.json               # Test data for departments endpoint
│   ├── tasks.json                     # Test data for tasks endpoint
│   ├── timetrackings.json            # Test data for timetrackings endpoint
│   └── users.json                     # Test data for users endpoint
├── stage-env.json                     # Global environment variables for collection
├── test_collection.json               # Postman collection with API requests
├── timetac-dev-ca.crt                # Timetac certificate for secure Newman execution
└── create_test_data.sh               # Bash script for automated request execution
```

### Folder and File Descriptions:

#### `.gitlab/` Directory
- **Purpose**: Contains all instructions and documentation for test data generation
- **Key Files**: 
  - `instructions.md` - comprehensive guide for generating each test data file
  - `API_CONTEXT.md` - API documentation and context
  - `users_instruction.md` - instructions for generating users.json
  - `timetrackings_instruction.md` - instructions for generating timetrackings.json

#### `test_data/` Directory  
- **Purpose**: Contains JSON test data files for each API endpoint
- **Structure**: One file per endpoint/request from the collection
- **Files**:
  - `departments.json` - Department creation data
  - `tasks.json` - Task creation data
  - `timetrackings.json` - Time tracking entries data
  - `users.json` - User creation data

#### Core Configuration Files
- **`stage-env.json`**: Global environment variables used throughout the collection
- **`test_collection.json`**: Main Postman collection containing all API requests and smart logic
- **`timetac-dev-ca.crt`**: SSL certificate required for secure Newman command execution

#### Automation Scripts
- **`create_test_data.sh`**: Bash script for automated execution of multiple requests using Newman CLI

### Usage Workflow:
1. **Configure Environment**: Set variables in `stage-env.json`
2. **Prepare Data**: Create/modify JSON files in `test_data/` directory
3. **Execute Requests**: Run `./create_test_data.sh [endpoint]` for automated testing
4. **Monitor Results**: Check logs and responses for validation

This structure enables efficient API testing with organized data files, comprehensive documentation, and automated execution capabilities.

## Base URL Structure
- Base URL: `{{url}}/{{account}}/{{version}}/` or `{{url}}/{{account}}/userapi/{{version}}/`
- Variables:
  - `{{url}}`: Base API URL
  - `{{account}}`: Account identifier
  - `{{version}}`: API version
- Authentication: Bearer token in Authorization header (`Bearer {{access_token}}`)

## API Endpoints

### 1. Read Time Trackings
**GET** `{{url}}/{{account}}/{{version}}/timetrackings/read/`
**GET** `{{url}}/{{account}}/userapi/{{version}}/timetrackings/read/`

Query Parameters:
- `_fetch_deleted` (optional): Include deleted records (value: "1")
- `nestedEntities` (optional): JSON string for nested data (e.g., `{"changeTimeTrackingRequests":[{}]}`)

### 2. Read Current Active Time Tracking
**GET** `{{url}}/{{account}}/userapi/{{version}}/timetrackings/current/`

No parameters required.

### 3. Create Time Tracking
**POST** `{{url}}/{{account}}/{{version}}/timeTrackings/create/`

Required Body Parameters:
- `user_id`: User identifier
- `task_id`: Task identifier  
- `start_time`: Start timestamp (format: "YYYY-MM-DD HH:MM:SS")
- `end_time`: End timestamp (format: "YYYY-MM-DD HH:MM:SS")
- `start_time_timezone`: Timezone (e.g., "Europe/Vienna")
- `end_time_timezone`: Timezone (e.g., "Europe/Vienna")

Optional Body Parameters:
- `nestedEntities`: JSON string for checkpoint trackings
- `max_hours_alert`: Maximum hours alert
- `is_billable`: Billable status
- `notes`: Additional notes
- `t_iv_1` through `t_iv_6`: Task custom fields
- `u_iv_1` through `u_iv_6`: User custom fields
- `approved_by_admin`: Admin approval status
- `geo_start_lat`, `geo_start_long`, `geo_start_accuracy`: Start location
- `geo_end_lat`, `geo_end_long`, `geo_end_accuracy`: End location
- `client_unique_id`: Client unique identifier
- `start_type_id`, `end_type_id`: Start/end type identifiers
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