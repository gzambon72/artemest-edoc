@EndUserText.label: 'Copy Edocument (Flow)'
define abstract entity ZD_CopyEdocumentFlowP
{
  @EndUserText.label: 'New EDOC (Gruppo)'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Edocgroup' )
  Edocgroup : ZEDOCGROUP;
  @EndUserText.label: 'New Edoc FLow'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Edocflow' )
  Edocflow : ZEDOCFLOW;
  
}
