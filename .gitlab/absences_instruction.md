# Absences Endpoint - Test Data Generation Instructions

## Overview
The Absences endpoint allows creating absence records for users (vacation days, sick leave, home office, etc.).

## Endpoint Details
- **Method**: POST
- **URL**: `{{url}}/{{account}}/{{version}}/absences/create/`
- **Authentication**: Bearer token required

## Request Parameters

### Required Fields

| Field | Type | Description | Rules |
|-------|------|-------------|-------|
| `user_id` | string | User identifier | Must be valid user ID |
| `type_id` | string | Absence type | `1` = Vacation, `3` = Other types |
| `subtype_id` | string | Absence subtype | Depends on `type_id` (see below) |
| `from_date` | string | Start date | Format: `YYYY-MM-DD`, cannot be later than `to_date` |
| `to_date` | string | End date | Format: `YYYY-MM-DD`, cannot be earlier than `from_date` |
| `duration` | string | Duration in days | See calculation rules below |
| `replacement_user_id` | string | Replacement user | Always `0` (no replacement) |

## Absence Types and Subtypes

### Type ID = 1 (Vacation)
- **subtype_id**: Must be `0`
- **Description**: Vacation day off / Paid time off

### Type ID = 3 (Other Absences)
- **subtype_id = 11**: Sick leave
- **subtype_id = 12**: Home office

## Duration Calculation Rules

### Single Day Absence (from_date = to_date)
Duration can be:
- `0.5` - Half day absence
- `1` - Full day absence

**Example**:
```json
{
  "from_date": "2025-09-22",
  "to_date": "2025-09-22",
  "duration": "1"
}
```

### Multi-Day Absence (from_date ≠ to_date)
Duration equals the number of days between `from_date` and `to_date` (inclusive).

**Calculation**: `duration = number of days from from_date to to_date (inclusive)`

**Example 1** - 2 days:
```json
{
  "from_date": "2025-09-22",
  "to_date": "2025-09-23",
  "duration": "2"
}
```

**Example 2** - 3 days:
```json
{
  "from_date": "2025-10-15",
  "to_date": "2025-10-17",
  "duration": "3"
}
```

## Test Data File Structure

File location: `test_data/absences.json`

### Example Test Data

```json
[
  {
    "user_id": "1",
    "type_id": "1",
    "subtype_id": "0",
    "from_date": "2025-09-22",
    "to_date": "2025-09-22",
    "duration": "1",
    "replacement_user_id": "0"
  },
  {
    "user_id": "1",
    "type_id": "3",
    "subtype_id": "11",
    "from_date": "2025-10-15",
    "to_date": "2025-10-17",
    "duration": "3",
    "replacement_user_id": "0"
  }
]
```

## Common Absence Scenarios

### 1. Full Day Vacation
```json
{
  "user_id": "1",
  "type_id": "1",
  "subtype_id": "0",
  "from_date": "2025-12-24",
  "to_date": "2025-12-24",
  "duration": "1",
  "replacement_user_id": "0"
}
```

### 2. Half Day Vacation
```json
{
  "user_id": "1",
  "type_id": "1",
  "subtype_id": "0",
  "from_date": "2025-11-15",
  "to_date": "2025-11-15",
  "duration": "0.5",
  "replacement_user_id": "0"
}
```

### 3. Multi-Day Vacation
```json
{
  "user_id": "1",
  "type_id": "1",
  "subtype_id": "0",
  "from_date": "2025-12-23",
  "to_date": "2025-12-31",
  "duration": "9",
  "replacement_user_id": "0"
}
```

### 4. Sick Leave
```json
{
  "user_id": "1",
  "type_id": "3",
  "subtype_id": "11",
  "from_date": "2025-11-10",
  "to_date": "2025-11-12",
  "duration": "3",
  "replacement_user_id": "0"
}
```

### 5. Home Office Day
```json
{
  "user_id": "1",
  "type_id": "3",
  "subtype_id": "12",
  "from_date": "2025-11-20",
  "to_date": "2025-11-20",
  "duration": "1",
  "replacement_user_id": "0"
}
```

## Validation Rules

### Date Validation
- ✅ `from_date` must be in format `YYYY-MM-DD`
- ✅ `to_date` must be in format `YYYY-MM-DD`
- ✅ `from_date` cannot be later than `to_date`
- ✅ Both dates should be valid calendar dates

### Type/Subtype Validation
- ✅ If `type_id = 1`, then `subtype_id` must be `0`
- ✅ If `type_id = 3`, then `subtype_id` must be `11` or `12`

### Duration Validation
- ✅ For single day (`from_date = to_date`): duration can be `0.5` or `1`
- ✅ For multiple days: duration must equal the number of days (inclusive)
- ✅ Duration calculation: `(to_date - from_date) + 1 day`

### Other Validation
- ✅ `replacement_user_id` is always `0`
- ✅ `user_id` must reference an existing user

## Usage with Newman CLI

Execute the absences creation with:

```bash
newman run test_collection.json \
  --environment stage-env.json \
  --folder absences \
  --iteration-data test_data/absences.json \
  --ssl-client-cert timetac-dev-ca.crt \
  --verbose
```

Or use the provided script:
```bash
./create_test_data.sh absences
```

## Tips for Test Data Generation

1. **Vacation Planning**: Space out vacation days throughout the year
2. **Realistic Sick Leave**: Typically 1-5 consecutive days
3. **Home Office**: Often single days, distributed throughout weeks
4. **Half Days**: Use `duration: 0.5` for appointments or partial absences
5. **Date Ranges**: Ensure dates don't overlap with existing absences for the same user
6. **Holiday Periods**: Consider creating vacation records around public holidays

## Error Handling

Common errors and solutions:

| Error | Cause | Solution |
|-------|-------|----------|
| Invalid date format | Date not in YYYY-MM-DD format | Use proper format: `2025-09-22` |
| Invalid date range | `from_date` > `to_date` | Ensure `from_date` ≤ `to_date` |
| Invalid subtype | Wrong `subtype_id` for given `type_id` | Check type/subtype combinations |
| Invalid duration | Duration doesn't match date range | Calculate: `(to_date - from_date) + 1` |
| User not found | Invalid `user_id` | Ensure user exists in system |

## Next Steps

After creating absences:
1. Verify absences were created successfully in API response
2. Check for any validation errors
3. Ensure dates don't conflict with existing timetrackings
4. Review absence balance for users
