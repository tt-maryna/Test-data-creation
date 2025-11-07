import json
import random
from datetime import datetime, timedelta

# Task IDs provided (excluding break task 9 which will be used separately)
work_task_ids = [4, 6, 7, 65, 76, 114, 116, 131, 136, 62, 77, 80, 83, 86, 108, 112, 126, 142,
                 71, 73, 79, 90, 91, 102, 109, 120, 133, 134, 139, 146, 150, 60, 74, 78, 84,
                 88, 100, 117, 119, 128, 130, 147, 158, 162, 72, 75, 96, 98, 103, 110, 111,
                 121, 123, 143, 144, 145, 149, 152, 161, 64, 81, 85, 89, 93, 99, 104, 125,
                 140, 63, 69, 70, 95, 105, 107, 113, 115, 156, 159, 66, 67, 68, 87, 97, 124,
                 127, 129, 141, 148, 154, 160, 94, 101, 106, 118, 122, 132, 135, 138, 61, 82,
                 92, 137, 151, 153, 155, 157]

# Austrian public holidays in 2025 (excluding weekends)
austrian_holidays_2025 = [
    datetime(2025, 1, 1),   # New Year's Day
    datetime(2025, 1, 6),   # Epiphany
    datetime(2025, 4, 21),  # Easter Monday
    datetime(2025, 5, 1),   # Labour Day
    datetime(2025, 5, 29),  # Ascension Day
    datetime(2025, 6, 9),   # Whit Monday
    datetime(2025, 6, 19),  # Corpus Christi
    datetime(2025, 8, 15),  # Assumption Day
    datetime(2025, 10, 26), # National Day
    datetime(2025, 11, 1),  # All Saints' Day
    datetime(2025, 12, 8),  # Immaculate Conception
    datetime(2025, 12, 25), # Christmas Day
    datetime(2025, 12, 26), # St. Stephen's Day
]

def is_working_day(date):
    """Check if date is a working day (not weekend or public holiday)"""
    if date.weekday() >= 5:  # Saturday=5, Sunday=6
        return False
    if date in austrian_holidays_2025:
        return False
    return True

def generate_daily_timetrackings(date, user_id):
    """Generate realistic timetracking entries for one day"""
    entries = []
    
    # Random start time between 7:30 and 9:00
    start_hour = random.randint(7, 8)
    start_minute = random.choice([0, 15, 30, 45]) if start_hour == 7 else random.choice([0, 15, 30])
    
    current_time = datetime(date.year, date.month, date.day, start_hour, start_minute)
    
    # Decide on break pattern (2-3 breaks, 30-60 min total)
    num_breaks = random.choice([2, 3])
    if num_breaks == 2:
        break_durations = [random.randint(10, 20), random.randint(20, 30)]
    else:  # 3 breaks
        break_durations = [random.randint(10, 15), random.randint(10, 15), random.randint(10, 15)]
    
    # Calculate total work time (8 hours)
    total_work_minutes = 8 * 60
    total_break_minutes = sum(break_durations)
    
    # Distribute work time across sessions
    num_work_sessions = num_breaks + 1
    work_session_durations = []
    
    remaining_work = total_work_minutes
    for i in range(num_work_sessions - 1):
        # Each work session between 30 minutes and 3 hours (180 min)
        min_duration = 30
        max_duration = min(180, remaining_work - 30 * (num_work_sessions - i - 1))
        duration = random.randint(min_duration, max_duration)
        work_session_durations.append(duration)
        remaining_work -= duration
    
    work_session_durations.append(remaining_work)
    
    # Generate entries
    break_idx = 0
    for i in range(num_work_sessions):
        # Work session
        work_duration = work_session_durations[i]
        task_id = random.choice(work_task_ids)
        
        start_time_str = current_time.strftime("%Y-%m-%d %H:%M:%S")
        current_time += timedelta(minutes=work_duration)
        end_time_str = current_time.strftime("%Y-%m-%d %H:%M:%S")
        
        entries.append({
            "user_id": str(user_id),
            "task_id": str(task_id),
            "start_time": start_time_str,
            "end_time": end_time_str
        })
        
        # Add break if not the last work session
        if i < num_work_sessions - 1:
            break_duration = break_durations[break_idx]
            start_time_str = current_time.strftime("%Y-%m-%d %H:%M:%S")
            current_time += timedelta(minutes=break_duration)
            end_time_str = current_time.strftime("%Y-%m-%d %H:%M:%S")
            
            entries.append({
                "user_id": str(user_id),
                "task_id": "9",  # Break task
                "start_time": start_time_str,
                "end_time": end_time_str
            })
            break_idx += 1
    
    return entries

# Generate timetrackings from May 1, 2025 to November 6, 2025
start_date = datetime(2025, 5, 1)
end_date = datetime(2025, 11, 6)
user_id = 1

all_entries = []
current_date = start_date

while current_date <= end_date:
    if is_working_day(current_date):
        daily_entries = generate_daily_timetrackings(current_date, user_id)
        all_entries.extend(daily_entries)
    current_date += timedelta(days=1)

# Write to file
with open('test_data/timetrackings.json', 'w') as f:
    json.dump(all_entries, f, indent=2)

print(f"Generated {len(all_entries)} timetracking entries for user {user_id}")
print(f"Period: {start_date.strftime('%Y-%m-%d')} to {end_date.strftime('%Y-%m-%d')}")
print(f"Working days: {len([e for e in all_entries if e['task_id'] != '9']) // 4}")  # Approximate
