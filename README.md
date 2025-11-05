# Time Tracking API Test Data Generator

A comprehensive test data generation system for TimeTac API endpoints using Newman (Postman CLI) with smart data relationships and automated ID extraction.

## 🚀 Quick Start

```bash
# Run projects first, then tasks (with auto-assignment)
./create_test_data.sh projects tasks

# Run specific endpoints
./create_test_data.sh users departments

# Run all endpoints in sequence
./create_test_data.sh departments users projects tasks timetrackings
```

## 📁 Project Structure

```
TestProject/
├── 📋 create_test_data.sh         # Main execution script
├── 📊 test_collection.json        # Postman collection with API endpoints
├── 🔧 stage-env.json              # Environment variables and API configuration
├── 📄 output.txt                  # Execution logs and API responses
├── 🔐 timetac-dev-ca.crt          # SSL certificate for secure connections
├── test_data/                     # Test data files (JSON)
│   ├── departments.json           # Department creation data
│   ├── users.json                 # User creation data  
│   ├── projects.json              # Project creation data
│   ├── tasks.json                 # Task creation data
│   └── timetrackings.json         # Time tracking entries data
└── .gitlab/                       # Documentation and instructions
    ├── instructions.md            # General project documentation
    ├── API_CONTEXT.md             # Complete API reference
    ├── departments_instruction.md # Department data format guide
    ├── users_instruction.md       # User data format guide
    ├── projects_instruction.md    # Project data format guide
    ├── tasks_instruction.md       # Task data format guide
    └── timetrackings_instruction.md # Time tracking data format guide
```

## ✨ Key Features

### 🔗 Smart Data Relationships
- **Auto-Assignment**: Tasks automatically inherit project IDs from previously created projects
- **Fallback Defaults**: Graceful fallback to default IDs when extraction fails
- **Cross-Reference**: Users auto-assign to departments, tasks to projects

### 📊 ID Extraction & Assignment
- **Dynamic Extraction**: Project IDs extracted from API responses in real-time
- **Output Parsing**: Intelligent parsing of `output.txt` for newly created entity IDs
- **Smart Logic**: Only newly created IDs are used, not existing parent/reference IDs

### 🛠 Flexible Execution
- **Modular**: Run any combination of endpoints in any order
- **Verbose Logging**: Detailed execution logs with timestamps
- **Error Handling**: Graceful failure handling with informative messages

## 📖 Usage Examples

### Basic Usage
```bash
# Create projects and then tasks (tasks will auto-assign to new projects)
./create_test_data.sh projects tasks

# Create users and assign them to departments  
./create_test_data.sh departments users

# Single endpoint execution
./create_test_data.sh users
```

### Advanced Workflows
```bash
# Full workflow: departments → users → projects → tasks → timetrackings
./create_test_data.sh departments users projects tasks timetrackings

# Test smart assignment without projects (tasks use fallback mother_id=3)
./create_test_data.sh tasks

# Create projects for later task assignment
./create_test_data.sh projects
# ... later ...
./create_test_data.sh tasks  # Will auto-assign to previously created projects
```

## 🔧 Configuration

### Environment Variables (`stage-env.json`)
- **API_BASE_URL**: TimeTac API base endpoint
- **AUTH_CREDENTIALS**: Login credentials for API authentication
- **SSL_CERT**: Certificate path for secure connections

### Data Files (`test_data/*.json`)
Each JSON file contains an array of objects with the required fields for that endpoint:

- **departments.json**: `name`, `color`, `short_name`
- **users.json**: `firstname`, `lastname`, `email`, `department_id` (auto-assigned)
- **projects.json**: `name`, `mother_id`, `status` (with smart defaults)
- **tasks.json**: `name`, `mother_id` (auto-assigned), `is_billable`, `task_type`
- **timetrackings.json**: `user_id`, `task_id`, `start_time`, `end_time`

## 🧠 Smart Assignment Logic

### Tasks → Projects
```javascript
// If mother_id not specified in tasks.json:
if (!mother_id_provided) {
    // 1. Try to use extracted project IDs from output.txt
    if (extracted_project_ids.length > 0) {
        mother_id = random_selection(extracted_project_ids);
    } else {
        // 2. Fallback to default
        mother_id = 3; // General Tasks project
    }
}
```

### Users → Departments  
```javascript
// If department_id not specified in users.json:
if (!department_id_provided) {
    // 1. Try to use extracted department IDs
    if (extracted_department_ids.length > 0) {
        department_id = random_selection(extracted_department_ids);
    } else {
        // 2. Fallback to default
        department_id = 1; // Default department
    }
}
```

## 📚 Documentation

### Instruction Files
Each endpoint has detailed instruction documentation in `.gitlab/` directory:

- **Field Requirements**: Mandatory vs optional fields
- **Data Types**: Expected formats and validation rules  
- **Examples**: Sample data structures and use cases
- **Best Practices**: Naming conventions and data relationships

### API Context
Complete API documentation available in `.gitlab/API_CONTEXT.md` including:
- Endpoint specifications
- Authentication requirements
- Request/response formats
- Error handling

## 🔍 Troubleshooting

### Common Issues

**No Project IDs Extracted**
```bash
# Check output.txt for project creation responses
grep -E '"ResourceName":"projects"' output.txt

# Verify projects were created successfully
grep -A 5 "projects/create" output.txt
```

**SSL Certificate Issues**
```bash
# Ensure certificate file exists and is readable
ls -la timetac-dev-ca.crt

# Check NODE_EXTRA_CA_CERTS environment variable
echo $NODE_EXTRA_CA_CERTS
```

**Authentication Failures**
```bash
# Verify credentials in stage-env.json
# Check token expiration in output.txt
grep "access_token" output.txt
```

### Debug Mode
```bash
# Run with verbose Newman output
NEWMAN_VERBOSE=true ./create_test_data.sh projects tasks
```

## 🤝 Contributing

When adding new endpoints or modifying existing ones:

1. **Update Collection**: Add/modify requests in `test_collection.json`
2. **Create Data File**: Add corresponding JSON file in `test_data/`
3. **Write Instructions**: Create detailed instruction file in `.gitlab/`
4. **Update Script**: Add folder mapping in `create_test_data.sh`
5. **Test Workflow**: Verify smart assignment and error handling

## 📝 License

This project is part of TimeTac API testing infrastructure.