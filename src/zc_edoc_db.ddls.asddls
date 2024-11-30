@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EDOC_DB
  provider contract transactional_query
  as projection on ZR_EDOC_DB
{
  key Edocflow,
  key UniqueValue,
  Xdata,
  Filename,
  Mimetypexml,
  Xmldata,
  Mimetypepdf,
  Pdfdata,
  CreatedOn,
  CreationUser,
  CreatedBy,
  Lastchangedby,
  LocalLastChanged,
  LastChanged
  
}
