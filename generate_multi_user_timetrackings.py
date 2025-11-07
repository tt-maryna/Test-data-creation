import json
import random
from datetime import datetime, timedelta

# Task IDs provided
work_task_ids = [4, 6, 7, 65, 76, 114, 116, 131, 136, 62, 77, 80, 83, 86, 108, 112, 126, 142,
                 71, 73, 79, 90, 91, 102, 109, 120, 133, 134, 139, 146, 150, 60, 74, 78, 84,
                 88, 100, 117, 119, 128, 130, 147, 158, 162, 72, 75, 96, 98, 103, 110, 111,
                 121, 123, 143, 144, 145, 149, 152, 161, 64, 81, 85, 89, 93, 99, 104, 125,
                 140, 63, 69, 70, 95, 105, 107, 113, 115, 156, 159, 66, 67, 68, 87, 97, 124,
                 127, 129, 141, 148, 154, 160, 94, 101, 106, 118, 122, 132, 135, 138, 61, 82,
                 92, 137, 151, 153, 155, 157]

# Austrian public holidays in 2025
austrian_holidays_2025 = [
    datetime(2025, 1, 1), datetime(2025, 1, 6), datetime(2025, 4, 21),
    datetime(2025, 5, 1), datetime(2025, 5, 29), datetime(2025, 6, 9),
    datetime(2025, 6, 19), datetime(2025, 8, 15), datetime(2025, 10, 26),
    datetime(2025, 11, 1), datetime(2025, 12, 8), datetime(2025, 12, 25),
    datetime(2025, 12, 26)
]

def get_all_working_days(start_date, end_date):
    """Get all working days in the period"""
    working_days = []
    current = start_date
    while current <= end_date:
        if current.weekday() < 5 and current not in austrian_holidays_2025:
            working_days.append(current)
        current += timedelta(days=1)
    return working_days

def generate_vacation_days(working_days, num_days):
    """Generate random vacation days"""
    return sorted(random.sample(working_days, min(num_days, len(working_days))))

def generate_short_days(working_days, vacation_days, num_short_days):
    """Generate days with short working hours (2-5 hours)"""
    available_days = [d for d in working_days if d not in vacation_days]
    return sorted(random.sample(available_days, min(num_short_days, len(available_days))))

def generate_daily_timetrackings(date, user_id, is_short_day=False):
    """Generate timetracking entries for one day"""
    entries = []
    
    # Random start time between 7:30 and 9:00
    start_hour = random.randint(7, 8)
    start_minute = random.choice([0, 15, 30, 45]) if start_hour == 7 else random.choice([0, 15, 30])
    current_time = datetime(date.year, date.month, date.day, start_hour, start_minute)
    
    if is_short_day:
        # Short day: 2-5 hours total work time
        total_work_minutes = random.randint(120, 300)  # 2-5 hours
        # 1-2 breaks for short days
        num_breaks = random.choice([1, 2])
        if num_breaks == 1:
            break_durations = [random.randint(10, 20)]
        else:
            break_durations = [random.randint(10, 15), random.randint(10, 15)]
    else:
        # Normal day: 8 hours work time
        total_work_minutes = 8 * 60
        # 2-3 breaks
        num_breaks = random.choice([2, 3])
        if num_breaks == 2:
            break_durations = [random.randint(10, 20), random.randint(20, 30)]
        else:
            break_durations = [random.randint(10, 15), random.randint(10, 15), random.randint(10, 15)]
    
    # Distribute work time across sessions
    num_work_sessions = num_breaks + 1
    work_session_durations = []
    remaining_work = total_work_minutes
    
    for i in range(num_work_sessions - 1):
        min_duration = 30
        max_duration = min(180, remaining_work - 30 * (num_work_sessions - i - 1))
        if max_duration < min_duration:
            max_duration = remaining_work
        duration = random.randint(min_duration, max_duration)
        work_session_durations.append(duration)
        remaining_work -= duration
    
    work_session_durations.append(remaining_work)
    
    # Generate entries
    break_idx = 0
    for i in range(num_work_sessions):
        work_duration = work_session_durations[i]
        if work_duration <= 0:
            continue
            
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
        if i < num_work_sessions - 1 and break_idx < len(break_durations):
            break_duration = break_durations[break_idx]
            start_time_str = current_time.strftime("%Y-%m-%d %H:%M:%S")
            current_time += timedelta(minutes=break_duration)
            end_time_str = current_time.strftime("%Y-%m-%d %H:%M:%S")
            
            entries.append({
                "user_id": str(user_id),
                "task_id": "9",
                "start_time": start_time_str,
                "end_time": end_time_str
            })
            break_idx += 1
    
    return entries

# Configuration
start_date = datetime(2025, 4, 1)
end_date = datetime(2025, 6, 6)
user_ids = [51, 52, 53]
total_vacation_days = 30
num_users = len(user_ids)

# Get all working days
all_working_days = get_all_working_days(start_date, end_date)
print(f"Total working days in period: {len(all_working_days)}")

# Generate 30 vacation days distributed among users
vacation_days_list = generate_vacation_days(all_working_days, total_vacation_days)

# Distribute vacation days among users (roughly equal)
user_vacation_days = {}
days_per_user = total_vacation_days // num_users
remaining_days = total_vacation_days % num_users

vacation_pool = vacation_days_list.copy()
random.shuffle(vacation_pool)

for i, user_id in enumerate(user_ids):
    num_days = days_per_user + (1 if i < remaining_days else 0)
    user_vacation_days[user_id] = vacation_pool[:num_days]
    vacation_pool = vacation_pool[num_days:]

# Generate short days for each user (different days per user)
user_short_days = {}
all_short_days = []
for user_id in user_ids:
    available_days = [d for d in all_working_days if d not in user_vacation_days[user_id]]
    num_short = random.randint(3, 8)  # 3-8 short days per user
    short_days = generate_short_days(all_working_days, user_vacation_days[user_id], num_short)
    user_short_days[user_id] = short_days
    all_short_days.extend([(user_id, d) for d in short_days])

# Generate timetrackings for all users
all_entries = []

for user_id in user_ids:
    current_date = start_date
    
    while current_date <= end_date:
        # Skip weekends and holidays
        if current_date.weekday() >= 5 or current_date in austrian_holidays_2025:
            current_date += timedelta(days=1)
            continue
        
        # Skip vacation days for this user
        if current_date in user_vacation_days[user_id]:
            current_date += timedelta(days=1)
            continue
        
        # Check if it's a short day for this user
        is_short = current_date in user_short_days[user_id]
        
        # Generate entries
        daily_entries = generate_daily_timetrackings(current_date, user_id, is_short)
        all_entries.extend(daily_entries)
        
        current_date += timedelta(days=1)

# Write to file
with open('test_data/timetrackings.json', 'w') as f:
    json.dump(all_entries, f, indent=2)

# Print summary
print(f"\n{'='*70}")
print(f"Generated {len(all_entries)} timetracking entries")
print(f"Users: {user_ids}")
print(f"Period: {start_date.strftime('%Y-%m-%d')} to {end_date.strftime('%Y-%m-%d')}")
print(f"\n{'='*70}")
print(f"VACATION DAYS (30 days total distributed among all users):")
print(f"{'='*70}")

for user_id in user_ids:
    print(f"\nUser {user_id} - {len(user_vacation_days[user_id])} vacation days:")
    for vday in user_vacation_days[user_id]:
        print(f"  - {vday.strftime('%Y-%m-%d')}")

print(f"\n{'='*70}")
print(f"SHORT WORKING DAYS (2-5 hours per day):")
print(f"{'='*70}")

for user_id in user_ids:
    print(f"\nUser {user_id} - {len(user_short_days[user_id])} short days:")
    for sday in user_short_days[user_id]:
        print(f"  - {sday.strftime('%Y-%m-%d')}")

print(f"\n{'='*70}")
print(f"ALL VACATION DATES (30 days):")
print(f"{'='*70}")
for vday in sorted(vacation_days_list):
    users_on_vacation = [uid for uid in user_ids if vday in user_vacation_days[uid]]
    print(f"{vday.strftime('%Y-%m-%d')} - Users: {users_on_vacation}")

print(f"\n{'='*70}")
