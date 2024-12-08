@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_EDOC_DB
  as select from ZEDOC_DB as EdocDB
{
  key edocflow as Edocflow,
  key unique_value as UniqueValue,
  filename as Filename,
  filenamezip as Filenamezip,
  mimetypexml as Mimetypexml,
  xmldata as Xmldata,
  mimetypezip as Mimetypezip,
  zipdata as Zipdata,
  ernam as Ernam,
  erdat as Erdat,
  erzet as Erzet,
  tmstp as Tmstp,
  created_on as CreatedOn,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  creation_user as CreationUser,
  @Semantics.user.lastChangedBy: true
  lastchangedby as Lastchangedby,
  @Semantics.systemDateTime.lastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged,
  mimetypepdf as Mimetypepdf,
  filenamepdf as Filenamepdf,
  pdfdata as Pdfdata,
  file_sraw as FileSraw
  
}
