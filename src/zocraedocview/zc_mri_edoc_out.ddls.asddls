@Metadata.allowExtensions: true
@EndUserText.label: 'CDS PROJECTION ZC_MRI_EDOC_OUT001'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_MRI_EDOC_OUT
  provider contract transactional_query
  as projection on ZR_MRI_EDOC_OUT
{
  key Invoice,
      Comments,
      @EndUserText.label : 'MIME Type ZIP'
      Mimetypezip,
      ///// zip /////
      @Consumption.semanticObject: 'Document'
      @EndUserText.label : 'ZIP Filename'
      Filenamezip,
      @Semantics.largeObject:
      {
      mimeType: 'Mimetypezip',
      fileName: 'Filenamezip',
      contentDispositionPreference: #INLINE // #ATTACHMENT - download as file
      // #INLINE - open in new window
      }
      @EndUserText.label : 'Content'
      zipdata,
      //      Purchaseorder,
      //      Price,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      FromEdocCustom

}
