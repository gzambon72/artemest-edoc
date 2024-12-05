@EndUserText.label: 'Electronic Document CDS View'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define root view entity ZCDS_EDOC_VIEW
  as select from zedocgroup_db as GroupDB
    inner join   zedoc_flow    as Flow     on GroupDB.edocgroup = Flow.edocgroup
    inner join   zedoc_db      as DocDB    on Flow.edocflow = DocDB.edocflow
    inner join   zoe_edocfile  as DocFile  on DocDB.unique_value = DocFile.file_guid
    inner join   zoe_edocument as Document on DocDB.unique_value = Document.zunique_value
{

      @Search.defaultSearchElement: true
  key GroupDB.edocgroup,
      @Search.defaultSearchElement: true
  key Flow.edocflow,
      @Search.defaultSearchElement: true
  key DocDB.unique_value,
      GroupDB.groupdescr,
      Flow.edocflowdescr,
      Document.statusdescr,
      Document.vatcode as VAT,
      Document.cedente as Cedente,
      Document.importototaledocumento as ImportoFattura,
      Document.data_fattura as DataFattura,
      // XML
      DocDB.filename    as Filename,
      @Semantics.mimeType: true
      DocDB.mimetypexml as MimeType,
      @Semantics.largeObject:
                    { mimeType: 'MimeType',
                    fileName: 'Filename',
                    contentDispositionPreference: #INLINE }
      DocDB.xmldata     as xmlAttachment,
      DocDB.file_sraw as xmlAttachmentRaw,
      // PDF
      DocDB.filenamepdf as FilenamePdf,
      @Semantics.mimeType: true
      DocDB.mimetypepdf as MimeTypePDF,
      @Semantics.largeObject:
                    { mimeType: 'MimeTypePDF',
                    fileName: 'FilenamePdf',
                    contentDispositionPreference: #INLINE }
      DocDB.pdfdata,
      
      // ZIP
      DocDB.filenamezip as FilenameZIP,
      @Semantics.mimeType: true
      DocDB.mimetypezip as MimeTypeZip,

      @Semantics.largeObject:
           { mimeType: 'MimeTypeZip',
           fileName: 'FilenameZIP',
           contentDispositionPreference: #INLINE }
      DocDB.zipdata     as zipAttachment,

      DocDB.created_on,
      DocDB.created_by,
      DocDB.lastchangedby,
      DocDB.local_last_changed,
      DocDB.last_changed,
      DocDB.ernam,
      DocDB.erdat,
      DocDB.erzet,
      DocDB.tmstp
}
where
  DocDB.edocflow = 'EDOC'
