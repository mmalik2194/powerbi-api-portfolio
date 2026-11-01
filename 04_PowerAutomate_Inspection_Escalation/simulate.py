"""Dry-run reminder selection. Sends no email and makes no external writes."""
import argparse,csv,datetime,json
from pathlib import Path
def eligible(row,now):
    if row['Status'] == 'Closed' or not row.get('DueAt'): return False
    due=datetime.datetime.fromisoformat(row['DueAt'].replace('Z','+00:00'))
    if due.tzinfo is None: raise ValueError('DueAt must include a timezone')
    return due < now and row.get('LastReminderDate','') != now.strftime('%Y-%m-%d')
def select(rows,now):return [r for r in rows if eligible(r,now)]
if __name__ == '__main__':
    p=argparse.ArgumentParser();p.add_argument('--now',default='2026-11-01T00:00:00Z');p.add_argument('--input',type=Path,default=Path(__file__).parent/'data/Inspections_demo.csv');a=p.parse_args()
    now=datetime.datetime.fromisoformat(a.now.replace('Z','+00:00'))
    if now.tzinfo is None: p.error('--now must include a timezone')
    now=now.astimezone(datetime.timezone.utc)
    with a.input.open(encoding='utf-8-sig',newline='') as f:rows=list(csv.DictReader(f))
    print(json.dumps({'as_of_utc':now.isoformat(),'recipient':'CONFIGURE_TEST_MAILBOX','count':len(select(rows,now)),'reminders':select(rows,now)},indent=2))
