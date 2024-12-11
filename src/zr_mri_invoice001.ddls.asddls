@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_MRI_INVOICE001
  as select from zmri_invoice as Invoice
{
  key invoice               as Invoice,
      comments              as Comments,      
      @Semantics.mimeType: true
      @UI.hidden: true
      mimetypepdf           as Mimetypepdf,
      ///// PDF /////
      @Consumption.semanticObject: 'Document'
      @EndUserText.label: 'Filename ZIP'
      filenamepdf           as Filenamepdf,
      @Semantics.largeObject:
                       { mimeType: 'Mimetypepdf',
                       fileName: 'Filenamepdf',
                       contentDispositionPreference: #INLINE }
      @EndUserText.label: 'ZIP'
      pdfdata               as Pdfdata,
      purchaseorder         as Purchaseorder,
      price                 as Price,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt

}
