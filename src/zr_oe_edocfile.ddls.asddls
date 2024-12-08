@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_OE_EDOCFILE
  as select from ZOE_EDOCFILE as EdocumentFile
{
  key file_guid as FileGuid,
  zunique_value as ZuniqueValue,
  seq_no as SeqNo,
  filename as Filename,
  filenamezip as Filenamezip,
  mimetypexml as Mimetypexml,
  xmldata as Xmldata,
  mimetypezip as Mimetypezip,
  zipdata as Zipdata,
  created_on as CreatedOn,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.user.lastChangedBy: true
  lastchangedby as Lastchangedby,
  @Semantics.systemDateTime.lastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged,
  file_raw as FileRaw,
  mimetypepdf as Mimetypepdf,
  filenamepdf as Filenamepdf,
  pdfdata as Pdfdata,
  file_sraw as FileSraw
  
}
