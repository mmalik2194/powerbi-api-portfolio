import datetime,unittest
from simulate import eligible
class ReminderTests(unittest.TestCase):
 def setUp(self):
  self.now=datetime.datetime(2026,11,1,tzinfo=datetime.timezone.utc)
  self.row={'Status':'Open','DueAt':'2026-10-31T23:59:00Z','LastReminderDate':''}
 def test_overdue(self):self.assertTrue(eligible(self.row,self.now))
 def test_closed(self):self.row['Status']='Closed';self.assertFalse(eligible(self.row,self.now))
 def test_future(self):self.row['DueAt']='2026-11-02T00:00:00Z';self.assertFalse(eligible(self.row,self.now))
 def test_exact_boundary(self):self.row['DueAt']='2026-11-01T00:00:00Z';self.assertFalse(eligible(self.row,self.now))
 def test_same_day_reminder(self):self.row['LastReminderDate']='2026-11-01';self.assertFalse(eligible(self.row,self.now))
 def test_old_reminder(self):self.row['LastReminderDate']='2026-10-31';self.assertTrue(eligible(self.row,self.now))
 def test_no_due_date(self):self.row['DueAt']='';self.assertFalse(eligible(self.row,self.now))
 def test_timezone_offset(self):self.row['DueAt']='2026-11-01T10:59:00+11:00';self.assertTrue(eligible(self.row,self.now))
 def test_naive_date_rejected(self):
  self.row['DueAt']='2026-11-01T00:00:00'
  with self.assertRaises(ValueError):eligible(self.row,self.now)
if __name__=='__main__':unittest.main()
