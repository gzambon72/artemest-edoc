@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_UPLOAD'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_UPLOAD as select from zupload_t
{
  key upload_id    as UploadId,
      filename     as Filename,
      mimetype     as Mimetype,
      @Semantics.largeObject: { mimeType: 'Mimetype',
                               fileName: 'Filename',
                               contentDispositionPreference: #INLINE                               
                                }
                           
      xdata        as XData,
      @Semantics.user.createdBy: true
      created_by   as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at   as CreatedAt,
      @Semantics.user.lastChangedBy: true
      changed_by   as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at   as ChangedAt
      }

 