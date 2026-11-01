# Airport inspection tracker | Power Apps + SharePoint

## Business question
How can staff browse a public airport register, log an inspection issue, assign ownership and close it with evidence?

This is a buildable canvas-app source kit, not an exported .msapp or deployed app. The public airport master contains 150 Australian large/medium airports selected in identifier order from OurAirports. Inspection requests are entirely synthetic and labelled DEMO. No source indicates these airports have actual maintenance problems.

## Set up SharePoint
Use an existing development SharePoint site where you can create lists. `sharepoint_schema.json` defines exact internal names and field types. Either create lists manually using those names or run `provision_lists.ps1 -SiteUrl <your-site> -ClientId <your-tenant-approved-app-id>` in PowerShell 7 after installing PnP.PowerShell. The script creates missing lists/fields and imports public assets without updating existing records. It does not send messages or import demonstration issues. Inspect existing field types first if reusing lists.

## Build the canvas app
1. Create a blank tablet canvas app. Add SharePoint connections named **Airports** and **Inspections** to the two lists.
2. Add four screens: `scrHome`, `scrAirport`, `scrNewInspection`, `scrInspection`.
3. scrHome: Text input `txtSearch`, vertical gallery `galAirports`, with a label for ThisItem.AirportName and another for ThisItem.Title. Apply the Items and OnSelect formulas from PowerFx.fx.
4. scrAirport: labels for varAirport.AirportName and varAirport.Municipality, gallery `galInspections` with ThisItem.Title, ThisItem.Status and ThisItem.DueAt, and button `btnNewInspection`. Apply the named formulas.
5. scrNewInspection: text inputs `txtIssue` (multiline), `txtOwner` (default User().Email), classic dropdown `ddPriority` (default Medium), and button `btnSaveInspection`. Apply the matching formulas.
6. scrInspection: labels for varInspection.Title and varInspection.IssueDescription, multiline `txtResolution` (default varInspection.ResolutionNotes), `btnStart`, `btnClose`. Apply the named formulas. Add Back() buttons to all detail screens.
7. Put the app initialization formula in App.OnStart and run OnStart. Save, preview, test, then publish/share only after checking list permissions. UI visibility is not a security boundary. Share the app and grant appropriate list access separately.

The default due dates are illustrative: High +1 day, Medium +3 days, Low +7 days. SharePoint stores DateTime values in UTC; the UI displays local time. Status and Priority are plain text, so all editors must preserve the exact labels used by the formulas and workflow. Read delegation warnings in Studio. The airport gallery uses delegated StartsWith, and inspections use a delegated equality on indexed AirportIdent. Do not replace these with nondelegable in-memory searches for large lists.

## Acceptance tests
Search for a known airport; create an inspection with your own development mailbox; verify AirportIdent and due date. Blank issue or invalid email must block save. Start it, enter resolution notes and close it. Closing without notes must be blocked. Simulate denied write permission: an error must appear and the app must not show success or navigate away. Ensure users without SharePoint permissions cannot access records. Test two users editing the same record before using this beyond a demo; conflict handling is not implemented.

## Portfolio demonstration
Show airport search → new issue → assigned owner → progress → resolution. Explain the master/detail relationship, delegated filtering, input validation, and UTC dates. Use [project 04](../04_PowerAutomate_Inspection_Escalation/README.md) to demonstrate overdue reminders. No operational deployment or measured impact is claimed.

Source: https://ourairports.com/data/ (public-domain airport database). This repository includes the selected import records in data/Airports_import.csv, not the full global airport database. sources.json documents the selection and original snapshot hash. Downloaded 1 November 2026. Native Power Apps, SharePoint permissions and provisioning have not been executed here.
