@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_OE_EDOCFILE
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_OE_EDOCFILE
{
  key FileGuid,
  ZuniqueValue,
  SeqNo,
  Filename,
  Mimetypexml,
  Xmldata,
  Mimetypepdf,
  Pdfdata,
  FileRaw
  
}