@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_MRI_INVOICE001
  provider contract  transactional_query
  as projection on ZR_MRI_INVOICE001
{
  key Invoice,
      Comments,
      @EndUserText.label : 'MIME Type ZIP'
      Mimetypepdf,
      ///// PDF /////
      @Consumption.semanticObject: 'Document'
      @EndUserText.label : 'ZIP Filename'
      Filenamepdf,
      @Semantics.largeObject:
             {
               mimeType: 'Mimetypepdf',
               fileName: 'Filenamepdf',
               contentDispositionPreference: #INLINE // #ATTACHMENT - download as file
                                                          // #INLINE - open in new window
                                                           }
      @EndUserText.label : 'Content'
      Pdfdata,
      //      Purchaseorder,
      //      Price,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt

}
