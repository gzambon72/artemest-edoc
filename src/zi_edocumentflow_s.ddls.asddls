@EndUserText.label: 'Edocument (Flow) Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'EdocumentFlowAll'
  }
}
define root view entity ZI_EdocumentFlow_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_EDOCUMENTFLOW'
  association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_EdocumentFlow as _EdocumentFlow
{
  @UI.facet: [ {
    id: 'ZI_EdocumentFlow', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Edocument (Flow)', 
    position: 1 , 
    targetElement: '_EdocumentFlow'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _EdocumentFlow,
  @UI.hidden: true
  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax,
  @ObjectModel.text.association: '_I_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 2 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _I_ABAPTransportRequestText
  
}
where I_Language.Language = $session.system_language
