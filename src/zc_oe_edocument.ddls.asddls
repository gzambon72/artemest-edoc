@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_OE_EDOCUMENT
  provider contract transactional_query
  as projection on ZR_OE_EDOCUMENT
{
  key UniqueValue,
  SeqNo,
  Bukrs,
  Land,
  FileGuid,
  Status,
  Statusdescr,
  Ernam,
  Erdat,
  Erzet,
  Tmstp,
  Vatcode,
  Cedente,
  DataFattura,
  Importototaledocumento
  
}
