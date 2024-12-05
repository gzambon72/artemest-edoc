@EndUserText.label: 'Edocument (Flow)'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_EdocumentFlow
  as select from ZEDOC_FLOW
  association to parent ZI_EdocumentFlow_S as _EdocumentFlowAll on $projection.SingletonID = _EdocumentFlowAll.SingletonID
{
  key EDOCGROUP as Edocgroup,
  key EDOCFLOW as Edocflow,
  EDOCFLOWDESCR as Edocflowdescr,
  @Consumption.hidden: true
  1 as SingletonID,
  _EdocumentFlowAll
  
}
