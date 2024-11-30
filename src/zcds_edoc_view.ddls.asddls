@EndUserText.label: 'Electronic Document View'
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
      GroupDB.descr,  
      Flow.edocflowdescr,
      Document.statusdescr,
      DocDB.xdata,
      DocDB.created_on,
      DocDB.created_by,
      DocDB.lastchangedby,
      DocDB.local_last_changed,
      DocDB.last_changed,
      DocDB.ernam,
      DocDB.erdat,
      DocDB.erzet,
      DocDB.tmstp,
      Document.bukrs,
      DocFile.filename,
      DocFile.mimetypexml,
      DocFile.xmldata,
      DocFile.mimetypepdf,
      DocFile.pdfdata
}
where
  DocDB.edocflow = 'EDOC'

