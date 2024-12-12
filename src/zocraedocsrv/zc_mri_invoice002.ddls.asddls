@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_MRI_INVOICE002
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_MRI_INVOICE002
{
  key Invoice,
  Comments,
  Mimetypepdf,
  Filenamepdf,
  Pdfdata,
  Purchaseorder,
  Price,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt,
  FromEdoc
  
}
