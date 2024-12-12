@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_MRI_INVOICE002
  as select from ZMRI_INVOICE as Invoice
{
  key invoice as Invoice,
  comments as Comments,
  mimetypepdf as Mimetypepdf,
  filenamepdf as Filenamepdf,
  pdfdata as Pdfdata,
  purchaseorder as Purchaseorder,
  price as Price,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  from_edoc as FromEdoc
  
}
