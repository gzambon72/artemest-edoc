@EndUserText.label: 'Edoc Flow Table'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_EdocFlowTable
  as select from ZEDOC_FLOW
  association to parent ZI_EdocFlowTable_S as _EdocFlowTableAll on $projection.SingletonID = _EdocFlowTableAll.SingletonID
{
  key EDOCGROUP as Edocgroup,
  key EDOCFLOW as Edocflow,
  EDOCFLOWDESCR as Edocflowdescr,
  @Consumption.hidden: true
  1 as SingletonID,
  _EdocFlowTableAll
  
}
