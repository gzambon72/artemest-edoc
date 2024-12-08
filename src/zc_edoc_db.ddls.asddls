@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EDOC_DB
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_EDOC_DB
{
  key Edocflow,
  key UniqueValue,
  Filename,
  Filenamezip,
  Mimetypexml,
  Xmldata,
  Mimetypezip,
  Zipdata,
  Ernam,
  Erdat,
  Erzet,
  Tmstp,
  CreatedOn,
  CreatedBy,
  CreationUser,
  Lastchangedby,
  LocalLastChanged,
  LastChanged,
  Mimetypepdf,
  Filenamepdf,
  Pdfdata,
  FileSraw
  
}
