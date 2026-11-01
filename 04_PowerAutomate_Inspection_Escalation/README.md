# Overdue inspection digest | Power Automate

## Business question
How can a coordinator receive a daily list of overdue open issues without manually checking every airport?

This project includes a precise designer build specification, demonstration data and an executable dry-run simulator with automated tests. It is not an importable Power Automate solution ZIP. A tenant-bound export requires real connection references and environment resources and has not been fabricated.

## Build in a development environment
1. Complete [project 03's SharePoint setup](../03_PowerApps_Airport_Inspections/README.md). Create a few synthetic inspections through the app, including an open overdue issue, closed overdue issue and future issue. Never substitute real recipients during the demo.
2. Create a Scheduled cloud flow. Set daily 08:00 and timezone **AUS Eastern Standard Time** (Sydney, including daylight-saving handling). Enable trigger concurrency control with degree 1.
3. Add a Scope named Main. Inside it add Compose **RunTime** with utcNow(), then Compose **TodayUTC** with formatDateTime(outputs('RunTime'),'yyyy-MM-dd'). One captured timestamp makes selection boundaries consistent.
4. Add SharePoint Get items named **Get_inspections**, configured with your site and Inspections list. Paste the FilterQuery from flow_build_spec.json. If editing in the designer, insert the RunTime output as dynamic content inside the quoted OData timestamp. Enable pagination; set an appropriate threshold up to 100000. Index Status and DueAt. Pagination alone does not solve SharePoint list-view-threshold issues on large lists.
5. Add Filter array **Eligible**, using Get_inspections value and the advanced expression in the JSON. It removes items already reminded on the same UTC date.
6. Condition **Any_overdue**: length(body('Eligible')) > 0. If false, finish successfully with no email. Inside the true branch use Select **Digest_rows**, Create HTML table **Digest_table**, then Send an email (V2) **Send_digest** with only your configured test mailbox. Use the fields and subject from the specification. OwnerEmail is displayed in the digest, not used as a recipient.
7. Still in the true branch, add Apply to each **Mark_reminded** over Eligible, sequentially. Run it only after Send_digest succeeds. Update each item's ID and required Title with their original values and set LastReminderDate to TodayUTC. Do not map unrelated optional columns. Verify the connector preserves unmapped fields in your tenant before publishing.
8. Add a second Scope outside Main, configured to run after Main fails or times out. Capture the error in run history or a FlowErrors list and terminate as Failed. Do not update reminder stamps after failure.

Date comparisons are exact UTC instants, while the recurrence follows Sydney local time. The reminder deduplication date is explicitly UTC. Closed issues are excluded. An issue due exactly at RunTime is not yet overdue. Blank DueAt values are excluded. Text Status values must match the labels in project 03.

## Run and test locally
From this folder, run `python simulate.py` to reproduce the fixed demonstration as-of time (1 November 2026 00:00 UTC), or pass `--now 2026-11-02T00:00:00Z`. Run `python -m unittest test_simulate.py`. The simulator reads CSV and prints a proposed digest only. It sends nothing and does not update SharePoint.

## Acceptance in Power Automate
Test an overdue open request, a closed request, a future request and an item already stamped today. Run twice: the second successful run must exclude stamped requests. Force a Get items failure and an email failure: stamps must remain unchanged. Force a post-email update failure: the run must fail visibly and a duplicate digest can occur on rerun. Compare designer selection with the simulator at the same timestamp and input records. Replace example.invalid addresses only with your own test values.

## Reliability and portfolio narrative
This is a best-effort daily digest, not an exactly-once delivery system. If email succeeds but stamping fails, reruns may duplicate it; record the run ID and check history before manual retry. Concurrent user edits remain possible even with sequential flow runs. At higher volume, use a dedicated delivery log and queue and test connector throttling. Demonstrate the selection logic, data-quality controls, error path and operational tradeoffs. No real messages have been sent, and no tenant deployment has been tested.

Sources: https://ourairports.com/data/ for master assets. Inspection records and SLA rules are synthetic. Official schedule documentation: https://learn.microsoft.com/power-automate/run-scheduled-tasks
