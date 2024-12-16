@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_OE_STAGING_FILE
  provider contract transactional_query
  as projection on ZR_OE_STAGING_FILE
{
  key Invoice,
      Comments,
      @EndUserText.label : 'MIME Type'
      Mimetypepdf,
      @Consumption.semanticObject: 'Document'
      @EndUserText.label : 'Filename'
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
      //  Purchaseorder,
      //  Price,
      FromEdoc,
      Inbound,
      Outbound,
      ManualPost,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt

}
