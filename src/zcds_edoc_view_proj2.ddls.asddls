@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View ZCDS_EDOC_VIEW'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@UI: { headerInfo: { typeName: 'Electronic Document', typeNamePlural: 'Electronic Documents', title: { type: #STANDARD, value: 'edocflowdescr' } } }

define root view entity ZCDS_EDOC_VIEW_PROJ2
  as projection on ZCDS_EDOC_VIEW2
{
      @UI.facet: [
          {
              id: 'GeneralInfo',
              purpose: #STANDARD,
              type: #IDENTIFICATION_REFERENCE,
              label: 'General Information',
              position: 10
          },
          {
              id: 'DocumentInfo',
              purpose: #STANDARD,
              type: #FIELDGROUP_REFERENCE,
              label: 'Document Details',
              position: 20,
              targetQualifier: 'DocDetails'
          }
      ]
  key edocgroup,
  key edocflow,
  key unique_value,

      @UI: {
          lineItem: [ { position: 30, importance: #HIGH },
              { type: #FOR_ACTION, dataAction: 'xml_display', label: 'Display XML', position: 1 },
              { type: #FOR_ACTION, dataAction: 'pdf_display', label: 'Display PDF', position: 2 },
              { type: #FOR_ACTION, dataAction: 'document_post', label: 'Post Document', position: 3 },
              { type: #FOR_ACTION, dataAction: 'uploadXML', label: 'XML Upload', position: 4 }
           ],
          identification: [ { position: 10 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 10 } ]
      }


      @Search.defaultSearchElement: true
      @EndUserText.label: 'Gruppo'
      descr,
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
        position: 50 ,
        label: 'Stato'
      } ]
      @UI.selectionField: [ {
        position: 50
      } ]
      statusdescr,

      @EndUserText.label: 'Filename'
      @UI.identification: [ {
        position: 50 ,
        label: 'File Name'
      } ]
      @UI.lineItem: [ {
        position: 50 ,
        label: 'File Name'
      } ]
      @UI.selectionField: [ {
        position: 50
      } ]
      Filename,
   // Aggiungo un nuovo facet per il contenuto XML
    @UI.facet: [
        {
            id: 'GeneralInfo',
            purpose: #STANDARD,
            type: #IDENTIFICATION_REFERENCE,
            label: 'General Information',
            position: 10
        },
        {
            id: 'DocumentInfo',
            purpose: #STANDARD,
            type: #FIELDGROUP_REFERENCE,
            label: 'Document Details',
            position: 20,
            targetQualifier: 'DocDetails'
        },
        {
            id: 'XMLContent',
            purpose: #STANDARD,
            type: #FIELDGROUP_REFERENCE,
            label: 'XML Content',
            position: 30,
            targetQualifier: 'XMLContent'
        }
    ]
      xmlAttachment,
      MimeType,
      pdfdata,
      mimetypepdf,
      ernam,

      @UI: {
          lineItem: [ { position: 60 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 60 } ]
      }
      erdat,

      @UI: {
          lineItem: [ { position: 70 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 70 } ]
      }
      erzet,

      @UI.hidden: true
      tmstp
}
