// English authoring locale; each block belongs to the named control property.
// Both SharePoint lists use TEXT for Priority and Status (not Choice).

// App.OnStart
Set(varAirport, Blank()); Set(varInspection, Blank())

// galAirports.Items. StartsWith on text fields supports delegated SharePoint search.
SortByColumns(Filter(Airports, StartsWith(AirportName, txtSearch.Text)), "AirportName", SortOrder.Ascending)

// galAirports.OnSelect
Set(varAirport, ThisItem); Navigate(scrAirport)

// galInspections.Items
Filter(Inspections, AirportIdent = varAirport.Title)

// btnNewInspection.OnSelect
Navigate(scrNewInspection)

// ddPriority.Items
["High", "Medium", "Low"]

// btnSaveInspection.OnSelect
If(
 IsBlank(varAirport.Title) || IsBlank(Trim(txtIssue.Text)) || !IsMatch(Trim(txtOwner.Text), Match.Email),
 Notify("Choose an airport and enter an issue and valid owner email.", NotificationType.Error),
 IfError(
  With({saved: Patch(Inspections, Defaults(Inspections), {
   Title: "INSP-" & Text(GUID()), AirportIdent: varAirport.Title,
   Priority: ddPriority.Selected.Value, Status: "Open",
   DueAt: DateAdd(Now(), Switch(ddPriority.Selected.Value, "High", 1, "Medium", 3, 7), TimeUnit.Days),
   OwnerEmail: Trim(txtOwner.Text), IssueDescription: Trim(txtIssue.Text),
   ResolutionNotes: "", LastReminderDate: ""
  })},
   Set(varInspection, saved); Reset(txtIssue); Notify("Inspection created.", NotificationType.Success); Navigate(scrAirport)
  ),
  Notify("Save failed: " & FirstError.Message, NotificationType.Error)
 )
)

// galInspections.OnSelect
Set(varInspection, ThisItem); Navigate(scrInspection)

// btnStart.OnSelect
IfError(Set(varInspection, Patch(Inspections, varInspection, {Status:"In progress"})), Notify(FirstError.Message, NotificationType.Error))

// btnClose.OnSelect
If(IsBlank(Trim(txtResolution.Text)),
 Notify("Enter resolution notes before closing.", NotificationType.Error),
 IfError(
  With({saved: Patch(Inspections, varInspection, {Status:"Closed", ResolutionNotes:Trim(txtResolution.Text)})},
   Set(varInspection, saved); Notify("Inspection closed.", NotificationType.Success); Navigate(scrAirport)
  ),
  Notify("Close failed: " & FirstError.Message, NotificationType.Error)
 )
)

// btnClose.DisplayMode and btnStart.DisplayMode
If(varInspection.Status = "Closed", DisplayMode.Disabled, DisplayMode.Edit)
