# Timetrackings.json Generation Instructions

## Overview
The `timetrackings.json` file contains test data for creating time tracking entries via API. This file is used with the Postman collection to automatically create multiple timetracking records with realistic working patterns.

## File Structure
The file should contain a JSON array of timetracking objects. Each timetracking object represents one time entry to be created.

## Required Fields

### Mandatory Fields (Always Required)
- `user_id`: ID of the user who performed the work (string/number)
- `task_id`: ID of the task being tracked (string/number)
- `start_time`: When the work period started (string, format: "YYYY-MM-DD HH:MM:SS")
- `end_time`: When the work period ended (string, format: "YYYY-MM-DD HH:MM:SS")

### Optional Fields (Automatically Assigned if Missing)
- `start_time_timezone`: Timezone for start time (defaults to "Europe/Vienna" if not provided)
- `end_time_timezone`: Timezone for end time (defaults to "Europe/Vienna" if not provided)

## Field Details and Constraints

### User ID (`user_id`)
- Must reference an existing user in the system
- Common test values: `"1"`, `"38"`, `"39"`, etc.
- Must be string format: `"1"`

### Task ID (`task_id`)
- Must reference an existing task in the system
- Common values:
  - `"4"` = Regular work task
  - `"9"` = Break/pause task
- Must be string format: `"4"`

### Time Format
- **Format**: `"YYYY-MM-DD HH:MM:SS"`
- **Examples**: 
  - `"2025-06-02 08:15:00"`
  - `"2025-06-02 17:30:00"`
- **Rules**:
  - End time must be after start time
  - Times should be realistic (business hours)
  - No overlapping entries for the same user

### Timezone (Optional)
- **Default**: Automatically set to `"Europe/Vienna"` if not provided
- **Custom**: You can specify different timezones if needed
- **Examples**: 
  - Not specified → defaults to `"Europe/Vienna"`
  - `"Europe/Berlin"` → uses specified timezone
- **Consistency**: Both start and end timezone will use the same default if neither is specified

## Example Timetrackings.json File

```json
[
  {
    "user_id": "1",
    "task_id": "4",
    "start_time": "2025-06-02 08:15:00",
    "end_time": "2025-06-02 10:30:00"
  },
  {
    "user_id": "1",
    "task_id": "9",
    "start_time": "2025-06-02 10:30:00",
    "end_time": "2025-06-02 11:15:00"
  },
  {
    "user_id": "1",
    "task_id": "4",
    "start_time": "2025-06-02 11:15:00",
    "end_time": "2025-06-02 17:30:00"
  }
]
```

### Example Explanation:
- **Entry 1**: Morning work session (2h 15min)
- **Entry 2**: Break time (45min)
- **Entry 3**: Afternoon work session (6h 15min)
- **Total**: Full work day with realistic break pattern
- **Timezones**: Automatically assigned to "Europe/Vienna" since not specified

## Smart Timezone Assignment

The collection includes intelligent timezone handling:
- **Missing timezone fields**: Automatically defaults to "Europe/Vienna"
- **Provided timezone fields**: Uses your specified values
- **Mixed scenarios**: You can specify one timezone and let the other default
- **Logging**: All assignment decisions are logged for debugging

### Timezone Examples:

#### Simple Format (Recommended):
```json
{
  "user_id": "1",
  "task_id": "4",
  "start_time": "2025-06-02 08:15:00",
  "end_time": "2025-06-02 10:30:00"
}
```
*Result: Both timezones automatically set to "Europe/Vienna"*

#### Custom Timezone:
```json
{
  "user_id": "1", 
  "task_id": "4",
  "start_time": "2025-06-02 08:15:00",
  "end_time": "2025-06-02 10:30:00",
  "start_time_timezone": "Europe/Berlin",
  "end_time_timezone": "Europe/Berlin"
}
```
*Result: Uses specified Berlin timezone*

#### Mixed Format:
```json
{
  "user_id": "1",
  "task_id": "4", 
  "start_time": "2025-06-02 08:15:00",
  "end_time": "2025-06-02 10:30:00",
  "start_time_timezone": "UTC"
}
```
*Result: start_time_timezone = "UTC", end_time_timezone = "Europe/Vienna" (default)*

## Realistic Work Patterns

### Typical Daily Structure
1. **Morning Work Block**: 1-3 hours (30 min - 3 hours per task)
2. **Break**: 10-30 minutes  
3. **Mid-day Work Block**: 1-3 hours
4. **Break** (optional): 10-30 minutes
5. **Afternoon Work Block**: 1-3 hours
6. **Total**: 8 hours work + 30-60 minutes breaks

### Task Assignment Rules
- **Flexible Task Switching**: You can switch between different work tasks throughout the day as needed
- **Use Available Task IDs**: Switch between any available work task IDs based on project requirements
- **Break Tasks Separate**: Only use break/pause tasks (task_id "9") for actual breaks
- **Break Duration Rules**:
  - Total break time: 30-60 minutes per day
  - Can be divided into 2-3 separate breaks
  - Each break must be at least 10 minutes
  - Cannot start the day with a break
  - Cannot end the day with a break
- **Work Task Duration Rules**:
  - Each work task session: 30 minutes to 3 hours
  - Multiple work sessions allowed per day
- **Weekly Hour Limit**: Total working time (excluding breaks) should not exceed 40 hours per week
- **Daily Limit**: Typically 8 hours of work time per day (excluding breaks)

### Example Daily Pattern:
```json
[
  {
    "user_id": "1",
    "task_id": "4",
    "start_time": "2025-06-02 08:00:00",
    "end_time": "2025-06-02 10:30:00"
  },
  {
    "user_id": "1",
    "task_id": "9",
    "start_time": "2025-06-02 10:30:00",
    "end_time": "2025-06-02 10:45:00"
  },
  {
    "user_id": "1",
    "task_id": "5",
    "start_time": "2025-06-02 10:45:00",
    "end_time": "2025-06-02 13:00:00"
  },
  {
    "user_id": "1",
    "task_id": "9",
    "start_time": "2025-06-02 13:00:00",
    "end_time": "2025-06-02 13:30:00"
  },
  {
    "user_id": "1",
    "task_id": "4",
    "start_time": "2025-06-02 13:30:00",
    "end_time": "2025-06-02 16:45:00"
  }
]
```

*Note: Work tasks are 2.5h, 2.25h, and 3.25h (within 30min-3h range). Two breaks total 45 minutes (within 30-60min range). Day starts and ends with work tasks.*

## Date Planning Guidelines

### Working Days Only
- **Include**: Monday through Friday
- **Exclude**: 
  - Weekends (Saturday, Sunday)
  - Public holidays (use https://www.timeanddate.com/holidays/ depends on country)
  - Company holidays

### Monthly Planning Example (June 2025):
```
June 2025 Working Days:
✅ Jun 2-6 (Mon-Fri)
❌ Jun 7-8 (Weekend)
❌ Jun 9 (Whit Monday - Public Holiday)
✅ Jun 10-13 (Tue-Fri)
❌ Jun 14-15 (Weekend)
✅ Jun 16-18 (Mon-Wed)
❌ Jun 19 (Corpus Christi - Public Holiday)
✅ Jun 20 (Fri)
❌ Jun 21-22 (Weekend)
✅ Jun 23-27 (Mon-Fri)
❌ Jun 28-29 (Weekend)
✅ Jun 30 (Mon)
```

## Multiple Users and Tasks

### Multiple Users Example:
```json
[
  {
    "user_id": "1",
    "task_id": "4",
    "start_time": "2025-06-02 08:00:00",
    "end_time": "2025-06-02 12:00:00"
  },
  {
    "user_id": "2",
    "task_id": "4",
    "start_time": "2025-06-02 09:00:00",
    "end_time": "2025-06-02 13:00:00"
  }
]
```

### Multiple Tasks Example:
```json
[
  {
    "user_id": "1",
    "task_id": "5",
    "start_time": "2025-06-02 08:00:00",
    "end_time": "2025-06-02 10:00:00"
  },
  {
    "user_id": "1",
    "task_id": "9",
    "start_time": "2025-06-02 10:00:00",
    "end_time": "2025-06-02 10:15:00"
  },
  {
    "user_id": "1",
    "task_id": "7",
    "start_time": "2025-06-02 10:15:00",
    "end_time": "2025-06-02 12:45:00"
  },
  {
    "user_id": "1",
    "task_id": "9",
    "start_time": "2025-06-02 12:45:00",
    "end_time": "2025-06-02 13:15:00"
  },
  {
    "user_id": "1",
    "task_id": "4",
    "start_time": "2025-06-02 13:15:00",
    "end_time": "2025-06-02 16:30:00"
  }
]
```

*Note: Three different work tasks (5, 7, 4) with durations of 2h, 2.5h, and 3.25h respectively. Two breaks of 15min and 30min (total 45min). Starts and ends with work tasks.*

## Generation Tips

### For Testing Scenarios:
1. **Single User, Single Day**: 3-5 entries (8 hours work + breaks)
2. **Single User, Full Week**: 15-25 entries (40 hours work + breaks across 5 days)
3. **Single User, Full Month**: 60-80 entries (160 hours work + breaks across ~20 working days)
4. **Multiple Users**: Multiply by number of users

### Weekly Planning (40-Hour Limit):
- **Monday**: 8 hours work + breaks
- **Tuesday**: 8 hours work + breaks  
- **Wednesday**: 8 hours work + breaks
- **Thursday**: 8 hours work + breaks
- **Friday**: 8 hours work + breaks
- **Total**: 40 hours work time (breaks not counted toward limit)

### Task Continuity Guidelines:
- **Flexible Task Assignment**: Use any available work task IDs throughout the day
- **Multi-Task Support**: Switch between different work tasks as needed for different projects
- **Task ID Variety**: Utilize all provided task IDs based on work requirements
- **Work Task Duration**: Each work session must be 30 minutes to 3 hours
- **Break Rules**: 
  - Total daily breaks: 30-60 minutes
  - Individual breaks: minimum 10 minutes each
  - 2-3 breaks maximum per day
  - Must start day with work task
  - Must end day with work task
- **Break Tasks Only**: Task "9" should only be used for actual breaks/lunch

### Realistic Timing Variations:
- **Start times**: 7:00-9:30 AM (must start with work task)
- **End times**: 4:00-7:00 PM (must end with work task)
- **Break durations**: 10-30 minutes per break, 30-60 minutes total
- **Work task durations**: 30 minutes to 3 hours each
- **Number of breaks**: 2-3 breaks per day maximum

### Common Patterns:
```json
// Two breaks pattern (50 min total breaks)
{"user_id": "1", "task_id": "4", "start_time": "2025-06-02 08:00:00", "end_time": "2025-06-02 10:30:00"},
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 10:30:00", "end_time": "2025-06-02 10:50:00"},
{"user_id": "1", "task_id": "5", "start_time": "2025-06-02 10:50:00", "end_time": "2025-06-02 13:20:00"},
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 13:20:00", "end_time": "2025-06-02 13:50:00"},
{"user_id": "1", "task_id": "7", "start_time": "2025-06-02 13:50:00", "end_time": "2025-06-02 17:00:00"}

// Three breaks pattern (45 min total breaks)
{"user_id": "1", "task_id": "4", "start_time": "2025-06-02 09:00:00", "end_time": "2025-06-02 11:00:00"},
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 11:00:00", "end_time": "2025-06-02 11:15:00"},
{"user_id": "1", "task_id": "5", "start_time": "2025-06-02 11:15:00", "end_time": "2025-06-02 13:45:00"},
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 13:45:00", "end_time": "2025-06-02 14:00:00"},
{"user_id": "1", "task_id": "6", "start_time": "2025-06-02 14:00:00", "end_time": "2025-06-02 16:00:00"},
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 16:00:00", "end_time": "2025-06-02 16:15:00"},
{"user_id": "1", "task_id": "4", "start_time": "2025-06-02 16:15:00", "end_time": "2025-06-02 18:00:00"}

// Single break pattern (60 min total break)
{"user_id": "1", "task_id": "4", "start_time": "2025-06-02 08:00:00", "end_time": "2025-06-02 12:00:00"},
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 12:00:00", "end_time": "2025-06-02 13:00:00"},
{"user_id": "1", "task_id": "5", "start_time": "2025-06-02 13:00:00", "end_time": "2025-06-02 17:00:00"}
```

## Usage Instructions

1. **Create the file**: Save as `timetrackings.json` in the project root
2. **Validate JSON**: Ensure proper JSON syntax
3. **Check dates**: Verify no weekends or holidays included
4. **Verify logic**: Ensure no time overlaps for same user
5. **Run the collection**: Execute with `./create_test_data.sh timetrackings`
6. **Check logs**: Review output for any errors

## Validation Rules

### Time Logic:
- End time > Start time ✅
- No overlapping entries for same user ✅
- Realistic work hours (8 hours/day max) ✅
- Weekly limit: 40 hours work time (excluding breaks) ✅
- Work task duration: 30 minutes to 3 hours each ✅
- Break duration: 10-30 minutes each, 30-60 minutes total ✅
- Day structure: Must start and end with work tasks ✅
- Task flexibility: Can switch between available work task IDs ✅
- Proper date format ✅

### Data Integrity:
- Valid user_id (must exist in system) ✅
- Valid task_id (must exist in system) ✅
- Consistent timezone usage ✅
- Working days only ✅

## Troubleshooting

### Common Issues:
1. **Invalid time format**: Use "YYYY-MM-DD HH:MM:SS"
2. **Overlapping times**: Check same user doesn't have concurrent entries
3. **Weekend/holiday dates**: Use only business days
4. **Invalid user/task IDs**: Ensure IDs exist in system
5. **Time logic errors**: End time must be after start time
6. **Exceeding 40-hour limit**: Total work time per week should not exceed 40 hours
7. **Invalid task combinations**: Ensure work task IDs are valid and break tasks are used appropriately
8. **Invalid work task duration**: Work tasks must be between 30 minutes and 3 hours
9. **Invalid break duration**: Breaks must be 10-30 minutes each, 30-60 minutes total per day
10. **Invalid day structure**: Day must start and end with work tasks, not breaks

### Error Examples:
```json
// ❌ Wrong format
{"start_time": "2025-06-02T08:00:00Z"}

// ✅ Correct format  
{"start_time": "2025-06-02 08:00:00"}

// ❌ End before start
{"start_time": "2025-06-02 10:00:00", "end_time": "2025-06-02 09:00:00"}

// ✅ Logical order
{"start_time": "2025-06-02 09:00:00", "end_time": "2025-06-02 10:00:00"}

// ✅ Timezone will be auto-assigned
{"start_time": "2025-06-02 09:00:00", "end_time": "2025-06-02 10:00:00"}

// ✅ Custom timezone specified
{"start_time": "2025-06-02 09:00:00", "end_time": "2025-06-02 10:00:00", "start_time_timezone": "UTC", "end_time_timezone": "UTC"}

// ❌ Exceeding daily work limit
{"start_time": "2025-06-02 08:00:00", "end_time": "2025-06-02 20:00:00"} // 12 hours is too much

// ✅ Realistic daily work limit
{"start_time": "2025-06-02 09:00:00", "end_time": "2025-06-02 17:00:00"} // 8 hours including break

// ❌ Using break task for work
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 09:00:00", "end_time": "2025-06-02 13:00:00"} // Bad: task 9 is for breaks only

// ❌ Starting day with break
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 08:00:00", "end_time": "2025-06-02 08:30:00"} // Bad: cannot start with break

// ❌ Ending day with break  
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 16:30:00", "end_time": "2025-06-02 17:00:00"} // Bad: cannot end with break

// ❌ Work task too short
{"user_id": "1", "task_id": "4", "start_time": "2025-06-02 09:00:00", "end_time": "2025-06-02 09:15:00"} // Bad: only 15 minutes

// ❌ Work task too long
{"user_id": "1", "task_id": "4", "start_time": "2025-06-02 09:00:00", "end_time": "2025-06-02 13:30:00"} // Bad: 4.5 hours

// ❌ Break too short
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 12:00:00", "end_time": "2025-06-02 12:05:00"} // Bad: only 5 minutes

// ❌ Too much break time
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 12:00:00", "end_time": "2025-06-02 13:30:00"} // Bad: 90 minutes

// ✅ Flexible task switching throughout day
{"user_id": "1", "task_id": "4", "start_time": "2025-06-02 09:00:00", "end_time": "2025-06-02 11:00:00"},
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 11:00:00", "end_time": "2025-06-02 11:15:00"},
{"user_id": "1", "task_id": "5", "start_time": "2025-06-02 11:15:00", "end_time": "2025-06-02 13:45:00"},
{"user_id": "1", "task_id": "9", "start_time": "2025-06-02 13:45:00", "end_time": "2025-06-02 14:15:00"},
{"user_id": "1", "task_id": "7", "start_time": "2025-06-02 14:15:00", "end_time": "2025-06-02 17:00:00"} // Good: proper structure and durations
```

## Bulk Generation Strategies

### Script-Based Generation:
1. Define working days for the month
2. Create standard daily pattern template
3. Apply variations (start time, break duration)
4. Loop through users and dates
5. Output to JSON format

### Manual Generation:
1. Start with single day template
2. Copy and modify dates
3. Adjust timing variations
4. Add realistic breaks
5. Validate final result

## Integration with Collection

The `timetrackings.json` file works directly with the Postman collection's timetracking endpoints:
- Uses existing authentication system
- **Smart timezone assignment**: Automatically sets "Europe/Vienna" as default timezone when not specified
- Validates against API constraints  
- Provides detailed logging for each entry including timezone assignment decisions
- Reports success/failure for bulk operations

This ensures that timetracking entries are created with valid, realistic data that reflects actual working patterns, while the smart timezone logic simplifies data file creation by removing the need to specify timezones for Austrian business operations.