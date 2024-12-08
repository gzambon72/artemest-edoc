@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_OE_EDOCUMENT
  as select from ZOE_EDOCUMENT as Edocument
{
  key zunique_value as UniqueValue,
  seq_no as SeqNo,
  bukrs as Bukrs,
  land as Land,
  file_guid as FileGuid,
  status as Status,
  statusdescr as Statusdescr,
  ernam as Ernam,
  erdat as Erdat,
  erzet as Erzet,
  tmstp as Tmstp,
  vatcode as Vatcode,
  cedente as Cedente,
  data_fattura as DataFattura,
  importototaledocumento as Importototaledocumento
  
}
