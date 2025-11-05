# Departments.json Generation Instructions

## Overview
The `departments.json` file contains test data for creating departments via API. This file is used with the Postman collection to automatically create multiple departments that serve as organizational units for users and other entities.

## File Structure
The file should contain a JSON array of department objects. Each department object represents one department to be created.

## Required Fields

### Mandatory Fields (Always Required)
- `department_name`: The name of the department (string, descriptive and clear)
- `mother_id`: Parent department ID (string, usually "0" for top-level departments)

### Optional Fields (Can be omitted)
- `supervisor_id`: ID of the department supervisor/manager (currently disabled in collection)
- `supervisor_assistant_id`: ID of the supervisor's assistant (currently disabled in collection)

## Field Details and Constraints

### Department Name (`department_name`)
- Must be a descriptive string identifying the department
- Should clearly indicate the department's purpose or function
- **Best Practices**:
  - Use clear, professional terminology
  - Be specific about the department's role
  - Keep names concise but descriptive
  - Use title case formatting
  - Avoid abbreviations unless commonly understood
- **Examples**:
  - `"Data Analytics"`
  - `"Quality Assurance"`
  - `"Research & Development"`
  - `"Human Resources"`
  - `"Information Technology"`
  - `"Marketing & Communications"`
  - `"Customer Support"`
  - `"Finance & Accounting"`

### Mother ID (`mother_id`)
- **Purpose**: Defines the hierarchical relationship between departments
- **Format**: Must be string format
- **Common Values**:
  - `"0"`: Top-level department (most common for new departments)
  - `"1"`, `"2"`, etc.: Child department under existing parent department

#### Hierarchical Structure
```
mother_id = "0" → Top Level
├── mother_id = "1" → Sub-department under department 1
├── mother_id = "2" → Sub-department under department 2
└── mother_id = "3" → Sub-department under department 3
```

### Supervisor Fields (Optional)
Currently disabled in the collection but available for future use:
- `supervisor_id`: Reference to a user who manages this department
- `supervisor_assistant_id`: Reference to a user who assists the supervisor

## 🔗 Smart Assignment Integration

### Departments → Users Relationship
Departments created via this file will be automatically extracted and made available for smart assignment to users:

1. **After Department Creation**: Department IDs are extracted from API responses
2. **User Assignment**: Users can automatically assign to newly created departments
3. **Fallback**: If no departments are created, users default to `department_id = 1`

### Workflow Integration
```bash
# Recommended workflow for smart assignment
./create_test_data.sh departments users

# This creates departments first, then assigns users to the new departments
```

## Example Departments.json File

### Basic Example (Top-level Departments)
```json
[
  {
    "department_name": "Data Analytics",
    "mother_id": "0"
  },
  {
    "department_name": "Quality Assurance", 
    "mother_id": "0"
  },
  {
    "department_name": "Research & Development",
    "mother_id": "0"
  }
]
```

### Advanced Example (Mixed Hierarchy)
```json
[
  {
    "department_name": "Information Technology",
    "mother_id": "0"
  },
  {
    "department_name": "Software Development",
    "mother_id": "1"
  },
  {
    "department_name": "DevOps & Infrastructure", 
    "mother_id": "1"
  },
  {
    "department_name": "Marketing",
    "mother_id": "0"
  },
  {
    "department_name": "Digital Marketing",
    "mother_id": "4"
  }
]
```

### Real-world Department Examples
```json
[
  {
    "department_name": "Human Resources",
    "mother_id": "0"
  },
  {
    "department_name": "Talent Acquisition",
    "mother_id": "1"
  },
  {
    "department_name": "Employee Relations",
    "mother_id": "1"
  },
  {
    "department_name": "Finance & Accounting",
    "mother_id": "0"
  },
  {
    "department_name": "Accounts Payable",
    "mother_id": "4"
  },
  {
    "department_name": "Financial Planning",
    "mother_id": "4"
  },
  {
    "department_name": "Customer Success",
    "mother_id": "0"
  },
  {
    "department_name": "Technical Support",
    "mother_id": "7"
  },
  {
    "department_name": "Customer Onboarding",
    "mother_id": "7"
  }
]
```

## Department Naming Best Practices

### Professional Department Names
- **Technology**: `"Information Technology"`, `"Software Engineering"`, `"Data Science"`
- **Business**: `"Business Development"`, `"Strategic Planning"`, `"Operations"`
- **Support**: `"Customer Support"`, `"Technical Support"`, `"Help Desk"`
- **Creative**: `"Design & UX"`, `"Content Creation"`, `"Brand Marketing"`
- **Management**: `"Project Management"`, `"Product Management"`, `"Program Management"`

### Avoid These Naming Patterns
- ❌ Too generic: `"Team A"`, `"Group 1"`, `"Department"`
- ❌ Too technical: `"DEPT_001"`, `"ORG_UNIT_A"`
- ❌ Inconsistent casing: `"data analytics"`, `"QUALITY ASSURANCE"`

## Common Use Cases

### 1. Small Company Structure
```json
[
  {"department_name": "Engineering", "mother_id": "0"},
  {"department_name": "Sales & Marketing", "mother_id": "0"},
  {"department_name": "Operations", "mother_id": "0"}
]
```

### 2. Large Organization Structure
```json
[
  {"department_name": "Technology", "mother_id": "0"},
  {"department_name": "Frontend Development", "mother_id": "1"},
  {"department_name": "Backend Development", "mother_id": "1"},
  {"department_name": "Quality Assurance", "mother_id": "1"},
  {"department_name": "Business", "mother_id": "0"},
  {"department_name": "Sales", "mother_id": "5"},
  {"department_name": "Marketing", "mother_id": "5"}
]
```

### 3. Functional Department Structure
```json
[
  {"department_name": "Product Development", "mother_id": "0"},
  {"department_name": "Customer Relations", "mother_id": "0"},
  {"department_name": "Administrative Services", "mother_id": "0"}
]
```

## Validation Rules

### Field Validation
- ✅ `department_name`: Required, non-empty string, max ~100 characters
- ✅ `mother_id`: Required, must be string format (`"0"`, `"1"`, etc.)
- ✅ JSON structure: Must be valid JSON array format

### Business Logic Validation
- ✅ Department names should be unique within the same hierarchy level
- ✅ `mother_id` should reference existing departments (or "0" for top-level)
- ✅ Avoid circular references in department hierarchy

## Troubleshooting

### Common Issues
1. **Invalid JSON Format**: Ensure proper comma placement and quote marks
2. **Missing Required Fields**: Both `department_name` and `mother_id` are required
3. **Incorrect mother_id Format**: Must be string, not number (`"0"` not `0`)

### Debugging Commands
```bash
# Validate JSON format
cat test_data/departments.json | jq .

# Check created departments in output
grep -A 10 "departments/create" output.txt

# View extracted department IDs
grep "department IDs" output.txt
```

## Integration Notes

This departments data integrates with:
- **Users**: Users can auto-assign to newly created departments
- **Projects**: Departments may be linked to projects in organizational reporting
- **Time Tracking**: Department-based time tracking and reporting

For best results, create departments before users to enable smart assignment workflows.