@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_OE_EDOCFILE
  as select from zoe_edocfile as EdocFile
{
  key file_guid as FileGuid,
  zunique_value as ZuniqueValue,
  seq_no as SeqNo,
  filename as Filename,
  mimetypexml as Mimetypexml,
  xmldata as Xmldata,
  mimetypepdf as Mimetypepdf,
  pdfdata as Pdfdata,
  file_raw as FileRaw
  
}
