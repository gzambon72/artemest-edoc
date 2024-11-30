@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_EDOC_DB
  as select from zedoc_db as Edocument
{
  key edocflow as Edocflow,
  key unique_value as UniqueValue,
  xdata as Xdata,
  filename as Filename,
  mimetypexml as Mimetypexml,
  xmldata as Xmldata,
  mimetypepdf as Mimetypepdf,
  pdfdata as Pdfdata,
  created_on as CreatedOn,
  creation_user as CreationUser,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.user.lastChangedBy: true
  lastchangedby as Lastchangedby,
  @Semantics.systemDateTime.lastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged
  
}
