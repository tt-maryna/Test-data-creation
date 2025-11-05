# Projects.json Generation Instructions

## Overview
The `projects.json` file contains test data for creating projects via API. This file is used with the Postman collection to automatically create multiple projects in the system.

## File Structure
The file should contain a JSON array of project objects. Each project object represents one project to be created.

## Required Fields

### Mandatory Fields (Always Required)
- `name`: Project name (string, should be descriptive and unique)

### Optional Fields (Automatically Assigned if Missing)
- `status`: Project status (string/number, defaults to "2" if not provided)

### Automatically Assigned Fields
- `mother_id`: Parent organization ID (automatically set to `"1"` for all projects)

## Field Details and Constraints

### Project Name (`name`)
- Must be a descriptive string identifying the project
- Should be unique within the organization
- **Examples**: 
  - `"Website Redesign"`
  - `"Mobile App Development"`
  - `"Database Migration"`
  - `"Customer Portal"`
  - `"Marketing Campaign"`
- **Best Practices**:
  - Use clear, business-friendly names
  - Keep names concise but descriptive
  - Avoid special characters that might cause API issues
  - Use title case formatting

### Mother ID (`mother_id`)
- **Automatically assigned**: Always set to `"1"` (root organization)
- **Not configurable**: This field is hardcoded in the collection
- **Purpose**: Links projects to the main organization structure

### Project Status (`status`)
- **Values**: String or number format
- **Default**: Automatically set to `"2"` (ACTIVE) if not provided
- **Available Status Values**:
  - `"1"` or `1` = PLANNING: Project is in planning phase
  - `"2"` or `2` = ACTIVE: Project is actively being worked on (default)
  - `"3"` or `3` = INACTIVE: Project is temporarily paused
  - `"4"` or `4` = CLOSED: Project is completed or terminated
- **Smart Assignment Logic**:
  - Field not included → defaults to `"2"` (ACTIVE)
  - Field included with value → uses specified status
  - Field included but empty → defaults to `"2"` (ACTIVE)
- **Examples**:
  ```json
  // Uses default status 2 (ACTIVE)
  {
    "name": "Website Redesign"
  }
  
  // Explicitly sets planning status
  {
    "name": "Mobile App Development",
    "status": "1"
  }
  
  // Explicitly sets closed status
  {
    "name": "Legacy Migration",
    "status": "4"
  }
  ```

## Example Projects.json File

```json
[
  {
    "name": "Website Redesign",
    "status": "2"
  },
  {
    "name": "Mobile App Development",
    "status": "1"
  },
  {
    "name": "Database Migration"
  }
]
```

### Example Explanation:
- **Project 1**: Website project with ACTIVE status (2)
- **Project 2**: Mobile app project with PLANNING status (1)
- **Project 3**: Database project using default ACTIVE status (2)
- **All projects**: Automatically assigned to organization ID 1
- **Status Logic**: Smart assignment with fallback to default ACTIVE status

## Project Naming Conventions

### Recommended Categories
1. **Development Projects**:
   - "Website Redesign"
   - "Mobile App Development"
   - "API Integration"
   - "Database Optimization"

2. **Business Projects**:
   - "Customer Portal"
   - "Marketing Campaign"
   - "Sales Platform"
   - "Analytics Dashboard"

3. **Infrastructure Projects**:
   - "Database Migration"
   - "Security Upgrade"
   - "System Integration"
   - "Performance Optimization"

4. **Internal Projects**:
   - "Employee Training"
   - "Process Improvement"
   - "Tool Implementation"
   - "Documentation Update"

### Naming Best Practices
- **Be specific**: "Website Redesign" instead of "Web Project"
- **Use action words**: "Migration", "Development", "Implementation"
- **Include scope**: "Customer Portal" vs "Admin Portal"
- **Avoid abbreviations**: Write out full terms for clarity
- **Stay professional**: Use business-appropriate terminology

## API Endpoint Details

### Request Method
- **HTTP Method**: POST
- **Endpoint**: `{{url}}/{{account}}/{{version}}/projects/create/`
- **Content-Type**: `application/x-www-form-urlencoded`

### Request Headers
- **Authorization**: `Bearer {{access_token}}` (automatically managed)
- **Content-Type**: `application/x-www-form-urlencoded`
- **Cookie**: `SECRETTOKEN=...` (automatically included)

### Request Body Parameters
- **name**: Project name from the data file (`{{name}}`)
- **mother_id**: Fixed value `"1"` (hardcoded in collection)
- **status**: Project status from the data file (`{{status}}`) or default "2" if not provided

## Usage Examples

### Running Projects Creation
```bash
# Create projects using the script
./create_test_data.sh projects

# Create projects along with other entities
./create_test_data.sh departments projects users
```

### Sample Data Structure
Create your `projects.json` with different project types and statuses:

```json
[
  {
    "name": "E-commerce Platform",
    "status": "2"
  },
  {
    "name": "Customer Support System",
    "status": "1"
  },
  {
    "name": "Internal Training Portal",
    "status": "2"
  },
  {
    "name": "Data Analytics Dashboard"
  },
  {
    "name": "Mobile Application",
    "status": "3"
  },
  {
    "name": "Security Infrastructure Upgrade",
    "status": "1"
  },
  {
    "name": "Marketing Automation Tool",
    "status": "2"
  },
  {
    "name": "Legacy System Migration",
    "status": "4"
  }
]
```

### Status Distribution Example:
- **PLANNING (1)**: Customer Support, Security Upgrade
- **ACTIVE (2)**: E-commerce, Training Portal, Marketing Tool
- **INACTIVE (3)**: Mobile Application  
- **CLOSED (4)**: Legacy Migration
- **Default (2)**: Data Analytics Dashboard (no status specified)

## Common Use Cases

### Standard Business Projects
- Customer-facing applications
- Internal tools and systems
- Marketing and sales initiatives
- Infrastructure improvements

### Development Projects
- Software development initiatives
- System integrations
- Database projects
- API development

### Operational Projects
- Process improvements
- Training programs
- Documentation projects
- Maintenance and upgrades

## Troubleshooting

### Common Issues
1. **Duplicate project names**: Ensure each project name is unique
2. **Special characters**: Avoid characters that might cause URL encoding issues
3. **Empty names**: All projects must have a non-empty name field
4. **Long names**: Keep project names reasonable in length (under 100 characters)
5. **Invalid status values**: Use only 1, 2, 3, or 4 for status field
6. **Wrong status format**: Status values should be strings ("1", "2", "3", "4")

### Validation Tips
- Test with a small dataset first
- Verify project names are business-appropriate
- Check for typos and formatting consistency
- Validate status values are within allowed range (1-4)
- Ensure JSON syntax is valid

### Status Value Examples
```json
// ✅ Valid status values
{"name": "Project 1", "status": "1"}  // PLANNING
{"name": "Project 2", "status": "2"}  // ACTIVE  
{"name": "Project 3", "status": "3"}  // INACTIVE
{"name": "Project 4", "status": "4"}  // CLOSED
{"name": "Project 5"}                 // Uses default 2 (ACTIVE)

// ❌ Invalid status values
{"name": "Project 1", "status": "5"}  // Invalid: outside range
{"name": "Project 2", "status": "0"}  // Invalid: outside range
{"name": "Project 3", "status": "active"}  // Invalid: not numeric
```

## Integration Notes

### Dependencies
- **No prerequisites**: Projects can be created independently
- **Organization structure**: All projects link to organization ID 1
- **Access control**: Projects inherit organization-level permissions

### Related Entities
- Projects can later be associated with tasks
- Users can be assigned to projects through tasks
- Time tracking entries reference projects via tasks

### API Response
- Successful creation returns project details including auto-generated project ID
- Failed requests return error details for debugging
- All responses are logged in the output file for review