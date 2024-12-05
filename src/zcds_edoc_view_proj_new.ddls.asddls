@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View ZCDS_EDOC_VIEW'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@UI: { headerInfo: { typeName: 'Electronic Document', typeNamePlural: 'Electronic Documents', title: { type: #STANDARD, value: 'edocflowdescr' } } }

define root view entity ZCDS_EDOC_VIEW_PROJ_NEW
  as projection on ZCDS_EDOC_VIEW
{

  key edocgroup,
  key edocflow,
  key unique_value,
      @UI: {
          lineItem: [ { position: 30, importance: #HIGH },
         //     { type: #FOR_ACTION, dataAction: 'xml_display', label: 'Display XML', position: 1 },
         //     { type: #FOR_ACTION, dataAction: 'pdf_display', label: 'Display PDF', position: 2 },
              { type: #FOR_ACTION, dataAction: 'document_post', label: 'Post Document', position: 3 }
        //      { type: #FOR_ACTION, dataAction: 'uploadXML', label: 'XML Upload', position: 4 }
           ],
          identification: [ { position: 10 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 10 } ]
      }


      @Search.defaultSearchElement: true
      @EndUserText.label: 'Gruppo'
      groupdescr,
      @UI: {
       lineItem: [ { position: 20 } ],
       fieldGroup: [ { qualifier: 'DocDetails', position: 20 } ]
      }
      @EndUserText.label: 'Flusso'
      edocflowdescr,
      @UI: {

            fieldGroup: [ { qualifier: 'DocDetails', position: 30 } ]
           }
      @EndUserText.label: 'Stato'
      @UI.identification: [ {
        position: 30 ,
        label: 'Stato'
      } ]
      @UI.lineItem: [ {
        position: 30 ,
        label: 'Stato'
      } ]
      @UI.selectionField: [ {
        position: 30
      } ]
      statusdescr,
      @UI: {

            fieldGroup: [ { qualifier: 'DocDetails', position: 30 } ]
           }
      @EndUserText.label: 'VAT'
      @UI.identification: [ {
        position: 35 ,
        label: 'VAT'
      } ]
      @UI.lineItem: [ {
        position: 35 ,
        label: 'VAT'
      } ]
      @UI.selectionField: [ {
        position: 35
      } ]
      VAT,
      @UI: {

      fieldGroup: [ { qualifier: 'DocDetails', position: 30 } ]
      }
      @EndUserText.label: 'Cedente'
      @UI.identification: [ {
        position: 35 ,
        label: 'Cedente'
      } ]
      @UI.lineItem: [ {
        position: 35 ,
        label: 'Cedente'
      } ]
      @UI.selectionField: [ {
        position: 35
      } ]
      Cedente,
      @UI: {

            fieldGroup: [ { qualifier: 'DocDetails', position: 30 } ]
           }
      @EndUserText.label: 'ImportoFattura'
      @UI.identification: [ {
        position: 35 ,
        label: 'ImportoFattura'
      } ]
      @UI.lineItem: [ {
        position: 35 ,
        label: 'ImportoFattura'
      } ]
      @UI.selectionField: [ {
        position: 35
      } ]
      ImportoFattura,

      @UI: {

            fieldGroup: [ { qualifier: 'DocDetails', position: 30 } ]
           }
      @EndUserText.label: 'DataFattura'
      @UI.identification: [ {
        position: 35 ,
        label: 'DataFattura'
      } ]
      @UI.lineItem: [ {
        position: 35 ,
        label: 'DataFattura'
      } ]
      @UI.selectionField: [ {
        position: 35
      } ]
      DataFattura,



      @UI: {
                identification: [ { position: 40 } ],
                lineItem: [ {
                    position: 40,
                    semanticObject: 'Document',
                    semanticObjectAction: 'display'
                } ],
                selectionField: [ { position: 40 } ],
                fieldGroup: [{
                    qualifier: 'XMLContent',
                    position: 40,
                    semanticObject: 'Document',
                    semanticObjectAction: 'display'
                }]
            }

      ///// XML /////
      @Consumption.semanticObject: 'Document'
      @EndUserText.label: 'Filename'
      Filename,
      @Semantics.largeObject:
      {
        mimeType: 'MimeType',
        fileName: 'Filename',
        contentDispositionPreference: #ATTACHMENT  // #ATTACHMENT - download as file
                                                   // #INLINE - open in new window
                                                    }
      //      xmlAttachmentRaw as XMLContent,
      xmlAttachment as XMLContent,


      @Semantics.mimeType: true
      MimeType,

      ///// PDF /////
      @Consumption.semanticObject: 'Document'
      @EndUserText.label: 'FilenamePDF'
      @UI.lineItem: [ {
        position: 60 ,
        label: 'FilenamePDF'
      } ]
      FilenamePdf,
      @UI: {
       lineItem: [ { position: 50 } ],
       fieldGroup: [ { qualifier: 'DocDetails', position: 50 } ]
      }
      @Semantics.largeObject:
           {
             mimeType: 'MimeTypePDF',
             fileName: 'FilenamePdf',
             contentDispositionPreference: #INLINE // #ATTACHMENT - download as file
                                                        // #INLINE - open in new window
                                                         }
      pdfdata       as PDFContent,
      // Search Term #Stream
      @Semantics.mimeType: true
      MimeTypePDF,
      ///// ZIP /////
      @Consumption.semanticObject: 'Document'
      @EndUserText.label: 'FilenameZIP'
      FilenameZIP,
      @Semantics.largeObject:
         {
           mimeType: 'MimeTypeZip',
           fileName: 'FilenameZIP',
           contentDispositionPreference: #ATTACHMENT // #ATTACHMENT - download as file
                                                      // #INLINE - open in new window
                                                       }
      zipAttachment as ZIPContent,
      // Search Term #Stream
      @Semantics.mimeType: true
      MimeTypeZip,

      @UI: {
          lineItem: [ { position: 60 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 70 } ]
      }
      erdat,



      @UI: {
          lineItem: [ { position: 70 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 80 } ]
      }
      erzet

}
