# Tasks.json Generation Instructions

## Overview
The `tasks.json` file contains test data for creating tasks via API. This file is used with the Postman collection to automatically create multiple tasks that can be assigned to projects and used for time tracking.

## File Structure
The file should contain a JSON array of task objects. Each task object represents one task to be created.

## Required Fields

### Mandatory Fields (Always Required)
- `mother_id`: Parent project or entity ID (string/number)
- `name`: Task name (string, should be descriptive and clear)
- `is_billable`: Whether the task is billable to clients (string: "true" or "false")
- `is_paid_non_working`: Whether non-working time is paid (string: "true" or "false")
- `is_nonworking`: Whether this is a non-working task (string: "true" or "false")
- `task_type`: Type of task based on billing rules (string)

## Field Details and Constraints

### Mother ID (`mother_id`)
- Must reference an existing project or parent entity in the system
- **Project IDs**: Use project IDs when creating project-specific tasks
- **Examples**: `"35"`, `"36"`, `"37"`, `"38"`, `"39"`
- **Format**: Must be string format: `"35"`
- **Purpose**: Links tasks to specific projects for organization and reporting

#### 🔗 Smart Assignment Feature
When `mother_id` is not specified in the task data, the system uses intelligent assignment:

1. **Dynamic Assignment**: Automatically uses project IDs extracted from `output.txt` 
   - Extracts IDs from recently created projects in the same script run
   - Randomly selects from available extracted project IDs
   - **Example**: If projects 84, 85, 86 were just created, tasks will randomly assign to one of these

2. **Fallback Default**: When no extracted project IDs are available
   - Uses `mother_id = 3` (General Tasks project) as default
   - Ensures tasks always have a valid parent project

3. **Explicit Override**: When `mother_id` is provided in task data
   - Uses the exact value specified, no smart assignment
   - **Example**: `"mother_id": "5"` will always use project ID 5

#### Smart Assignment Examples
```json
// Task with explicit mother_id (no auto-assignment)
{
  "name": "Fixed Project Task",
  "mother_id": "3",
  "is_billable": "true",
  ...
}

// Task without mother_id (will auto-assign from extracted IDs or use default)
{
  "name": "Dynamic Assignment Task",
  "is_billable": "true",
  ...
  // mother_id will be automatically assigned
}
```

### Task Name (`name`)
- Must be a descriptive string identifying the task
- Should clearly indicate the type of work to be performed
- **Best Practices**:
  - Use clear, professional terminology
  - Be specific about the work type
  - Keep names concise but descriptive
  - Use title case formatting
- **Examples**:
  - `"Frontend Development"`
  - `"Backend API Development"`
  - `"Testing & QA"`
  - `"UI/UX Design"`
  - `"Database Migration"`

### Billable Status (`is_billable`)
- **Values**: `"true"` or `"false"` (string format)
- **"true"**: Task time can be billed to clients
- **"false"**: Task time is internal/non-billable
- **Exclusivity Rule**: Only ONE of `is_billable`, `is_paid_non_working`, or `is_nonworking` can be `"true"`

### Paid Non-Working (`is_paid_non_working`)
- **Values**: `"true"` or `"false"` (string format)
- **"true"**: Non-working time on this task is compensated (e.g., paid sick leave, vacation)
- **"false"**: Not a paid non-working task
- **Exclusivity Rule**: Only ONE of `is_billable`, `is_paid_non_working`, or `is_nonworking` can be `"true"`

### Non-Working Flag (`is_nonworking`)
- **Values**: `"true"` or `"false"` (string format)
- **"true"**: Task represents non-productive time (breaks, unpaid time off)
- **"false"**: Not a non-working task
- **Exclusivity Rule**: Only ONE of `is_billable`, `is_paid_non_working`, or `is_nonworking` can be `"true"`

### Task Type (`task_type`)
- **Rule**: Must match whichever field is set to `"true"`
- **Possible Values**:
  - `"is_billable"`: When `is_billable: "true"`
  - `"is_paid_non_working"`: When `is_paid_non_working: "true"`
  - `"is_nonworking"`: When `is_nonworking: "true"`
- **Examples**:
  ```json
  // Billable work task
  {
    "is_billable": "true",
    "is_paid_non_working": "false", 
    "is_nonworking": "false",
    "task_type": "is_billable"
  }
  
  // Paid non-working task (vacation, sick leave)
  {
    "is_billable": "false",
    "is_paid_non_working": "true",
    "is_nonworking": "false", 
    "task_type": "is_paid_non_working"
  }
  
  // Non-working task (breaks, unpaid time)
  {
    "is_billable": "false",
    "is_paid_non_working": "false",
    "is_nonworking": "true",
    "task_type": "is_nonworking"
  }
  ```

## Example Tasks.json File

```json
[
  {
    "mother_id": "35",
    "name": "Frontend Development",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  },
  {
    "mother_id": "35",
    "name": "Backend API Development",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  },
  {
    "mother_id": "35",
    "name": "Testing & QA",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  }
]
```

### Example Explanation:
- **Project 35**: Three development-related tasks
- **All billable**: Client work that can be charged
- **Standard settings**: Typical productive work configuration
- **Clear names**: Easy to identify work type

## Task Categories and Naming Conventions

### Development Tasks
- **Frontend Development**: UI/UX implementation, client-side coding
- **Backend API Development**: Server-side logic, database integration
- **Testing & QA**: Quality assurance, bug testing, validation
- **Database Development**: Schema design, optimization, migration
- **Integration Development**: Third-party API integration, system connections

### Design Tasks
- **UI/UX Design**: User interface and experience design
- **Graphic Design**: Visual assets, branding materials
- **Prototype Development**: Mockups, wireframes, proof of concepts
- **Design Review**: Design validation, feedback incorporation

### Project Management Tasks
- **Project Planning**: Timeline creation, resource allocation
- **Requirements Analysis**: Stakeholder interviews, documentation
- **Project Coordination**: Team communication, progress tracking
- **Client Communication**: Meetings, updates, feedback sessions

### Documentation Tasks
- **Technical Documentation**: API docs, system architecture
- **User Documentation**: Manuals, help guides, training materials
- **Process Documentation**: Workflows, procedures, standards

### Infrastructure Tasks
- **System Setup**: Environment configuration, deployment
- **Performance Optimization**: Speed improvements, resource optimization
- **Security Implementation**: Security measures, compliance
- **Maintenance**: Updates, patches, routine maintenance

## Multiple Projects Support

### Generating Tasks for Multiple Projects
When creating tasks for several projects:
- **Specify Project IDs**: Provide the exact project IDs (mother_id)
- **Tasks per Project**: Typically 3-5 tasks per project
- **Task Variety**: Use different task types for realistic project structure
- **Consistent Formatting**: All tasks follow the same field structure

### Multi-Project Example:
```json
[
  {
    "mother_id": "35",
    "name": "Frontend Development",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  },
  {
    "mother_id": "36",
    "name": "Mobile App Development",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  },
  {
    "mother_id": "37",
    "name": "Database Migration",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  }
]
```

## Task Generation Guidelines

### Standard Project Task Set
For a typical project, include these task types:
1. **Planning Task**: Requirements, analysis, design
2. **Development Task**: Core implementation work
3. **Testing Task**: Quality assurance, validation
4. **Documentation Task**: User guides, technical docs
5. **Deployment Task**: Release, deployment, go-live

### Task Naming Best Practices
- **Be Specific**: "Frontend Development" vs "Development"
- **Use Action Words**: "Development", "Testing", "Analysis"
- **Include Scope**: "Database Migration" vs "Migration"
- **Professional Terms**: Business-appropriate language
- **Consistent Format**: Similar structure across tasks

### Billing Configuration Guidelines
- **Client Projects**: Set `is_billable: "true"` for external work
- **Internal Projects**: Consider `is_billable: "false"` for internal work
- **Standard Settings**: Most tasks use:
  - `is_paid_non_working: "false"`
  - `is_nonworking: "false"`
  - `task_type: "is_billable"`

## API Endpoint Details

### Request Method
- **HTTP Method**: POST
- **Endpoint**: `{{url}}/{{account}}/{{version}}/tasks/create/`
- **Content-Type**: `application/x-www-form-urlencoded`

### Request Headers
- **Authorization**: `Bearer {{access_token}}` (automatically managed)
- **Content-Type**: `application/x-www-form-urlencoded`

### Request Body Parameters
- **mother_id**: Project ID from the data file (`{{mother_id}}`)
- **name**: Task name from the data file (`{{name}}`)
- **is_billable**: Billable flag (`{{is_billable}}`)
- **is_paid_non_working**: Paid non-working flag (`{{is_paid_non_working}}`)
- **is_nonworking**: Non-working flag (`{{is_nonworking}}`)
- **task_type**: Task type (`{{task_type}}`)

## Usage Examples

### Running Task Creation
```bash
# Create tasks using the script
./create_test_data.sh tasks

# Create tasks along with projects
./create_test_data.sh projects tasks

# Full workflow: projects, then tasks, then timetrackings
./create_test_data.sh projects tasks timetrackings
```

### Sample Request Formats
When requesting task data generation:

#### Single Project:
- "Generate 3 tasks for project ID 35"
- "Create development tasks for project 36"

#### Multiple Projects:
- "Generate 3 tasks each for projects 35, 36, 37, 38, 39"
- "Create tasks for project IDs 40, 41, 42 with typical development workflow"

## Common Task Templates

### Software Development Project
```json
[
  {
    "mother_id": "PROJECT_ID",
    "name": "Requirements Analysis",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  },
  {
    "mother_id": "PROJECT_ID",
    "name": "Frontend Development",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  },
  {
    "mother_id": "PROJECT_ID",
    "name": "Backend Development",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  },
  {
    "mother_id": "PROJECT_ID",
    "name": "Testing & QA",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  }
]
```

### Marketing Campaign Project
```json
[
  {
    "mother_id": "PROJECT_ID",
    "name": "Campaign Strategy",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  },
  {
    "mother_id": "PROJECT_ID",
    "name": "Content Creation",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  },
  {
    "mother_id": "PROJECT_ID",
    "name": "Campaign Analytics",
    "is_billable": "true",
    "is_paid_non_working": "false",
    "is_nonworking": "false",
    "task_type": "is_billable"
  }
]
```

## Integration with Other Entities

### Dependencies
- **Projects First**: Projects must exist before creating tasks
- **Project IDs**: Use actual project IDs created in the system
- **Sequential Creation**: Run projects → tasks → timetrackings

### Related Data
- **Timetrackings**: Tasks can be referenced in timetracking entries
- **Users**: Users can log time against these tasks
- **Projects**: Tasks belong to projects and inherit project properties

### Workflow Integration
1. **Create Projects**: Use `./create_test_data.sh projects`
2. **Create Tasks**: Use `./create_test_data.sh tasks` (references project IDs)
3. **Create Users**: Use `./create_test_data.sh users` (if needed)
4. **Create Timetrackings**: Use `./create_test_data.sh timetrackings` (references task IDs)

## Troubleshooting

### Common Issues
1. **Invalid mother_id**: Ensure project exists before creating tasks
2. **Duplicate task names**: Make task names unique within projects
3. **Invalid field values**: Use exact string values ("true"/"false")
4. **Missing required fields**: All six fields are mandatory
5. **Exclusivity rule violation**: Only ONE of `is_billable`, `is_paid_non_working`, or `is_nonworking` can be `"true"`
6. **Task type mismatch**: `task_type` must match whichever field is set to `"true"`
7. **JSON syntax errors**: Validate JSON format before running

### Validation Tips
- **Test with small dataset**: Start with 1-2 tasks per project
- **Verify project IDs**: Ensure parent projects exist in system
- **Check field formats**: All boolean fields must be strings
- **Validate exclusivity**: Only one of the three boolean fields can be `"true"`
- **Verify task type**: Ensure `task_type` matches the field set to `"true"`
- **Validate JSON**: Use JSON validator before execution

### Error Examples
```json
// ❌ Wrong boolean format
{"is_billable": true}

// ✅ Correct string format
{"is_billable": "true"}

// ❌ Multiple fields set to true (violates exclusivity rule)
{
  "is_billable": "true",
  "is_paid_non_working": "true",
  "is_nonworking": "false",
  "task_type": "is_billable"
}

// ❌ Task type doesn't match the true field
{
  "is_billable": "false",
  "is_paid_non_working": "true",
  "is_nonworking": "false",
  "task_type": "is_billable"
}

// ❌ All fields are false (one must be true)
{
  "is_billable": "false",
  "is_paid_non_working": "false",
  "is_nonworking": "false",
  "task_type": "is_billable"
}

// ❌ Missing required field
{
  "mother_id": "35",
  "name": "Development"
  // Missing other required fields
}

// ✅ Complete task object (billable work)
{
  "mother_id": "35",
  "name": "Frontend Development",
  "is_billable": "true",
  "is_paid_non_working": "false",
  "is_nonworking": "false",
  "task_type": "is_billable"
}

// ✅ Complete task object (paid non-working)
{
  "mother_id": "35",
  "name": "Vacation",
  "is_billable": "false",
  "is_paid_non_working": "true",
  "is_nonworking": "false",
  "task_type": "is_paid_non_working"
}

// ✅ Complete task object (non-working)
{
  "mother_id": "35",
  "name": "Break",
  "is_billable": "false",
  "is_paid_non_working": "false",
  "is_nonworking": "true",
  "task_type": "is_nonworking"
}
```

## Best Practices

### File Organization
- **Logical Grouping**: Group tasks by project ID
- **Clear Naming**: Use descriptive task names
- **Consistent Structure**: Same field order for all tasks
- **Proper Formatting**: Clean JSON with proper indentation

### Data Quality
- **Realistic Tasks**: Use actual work activities
- **Appropriate Billing**: Match billing flags to task type
- **Professional Names**: Business-appropriate task names
- **Complete Information**: All required fields populated

### Integration Planning
- **Sequential Dependencies**: Create projects before tasks
- **ID Management**: Track created IDs for timetracking references
- **Testing Strategy**: Validate each step before proceeding
- **Documentation**: Keep track of created entities and their IDs

This instruction file provides comprehensive guidance for generating realistic, properly structured task data that integrates seamlessly with the project and timetracking workflow.