CLASS lhc_zr_oe_staging_file DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    DATA buffer_t TYPE zedoc_db_t.
    DATA buffer TYPE zedoc_db.
    DATA edocument_t TYPE zoe_Edocument_t .
    DATA edocument TYPE zoe_Edocument.
    DATA edocumentfile TYPE zoe_edocfile .
    DATA edocumentfile_t TYPE zoe_edocfile_t .

    DATA o_dispatcher TYPE REF TO zcl_zoe_dispatcher.
    METHODS get_instance_features FOR INSTANCE FEATURES IMPORTING keys REQUEST requested_features FOR Staging RESULT result.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Staging
        RESULT result,

      document_post FOR MODIFY
        IMPORTING keys FOR ACTION Staging~document_post  RESULT result.

    METHODS save_entity_edocument .
    METHODS save_entity_buffer .
    METHODS save_entity_edocufile .
    METHODS update_entity_edocument .
ENDCLASS.

CLASS lhc_zr_oe_staging_file IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD get_instance_features.
  ENDMETHOD.
  METHOD document_post.

    LOOP AT keys INTO DATA(key).

      o_dispatcher = NEW zcl_zoe_dispatcher( invoice = key-Invoice ).
      o_dispatcher->execute_action(  'POST_FROM_STAGING' ).

      DATA(severity) = o_dispatcher->severity.
      DATA(action_text) = o_dispatcher->action_text.
      buffer_t = o_dispatcher->buffer_t.
      edocument_t = o_dispatcher->edocument_t.
      edocumentfile_t = o_dispatcher->edocumentfile_t.


      FREE o_dispatcher.

      save_entity_edocument(  ) .
      save_entity_buffer(  ) .
      save_entity_edocufile(  ) .


      READ ENTITIES OF zr_oe_staging_file IN LOCAL MODE
       ENTITY Staging
       FROM VALUE #( ( Invoice = keys[ 1 ]-Invoice ) )
       RESULT DATA(staging)
       FAILED DATA(staiging_failed)
       REPORTED DATA(staging_reported).

      APPEND VALUE #( %msg = new_message_with_text(
                       severity = severity
                       text     = action_text
                     ) ) TO reported-staging.

    ENDLOOP.
  ENDMETHOD.

  METHOD save_entity_buffer.
    LOOP AT buffer_t INTO buffer.
      MODIFY ENTITIES OF zr_edoc_db
        ENTITY EdocDB
        CREATE FROM VALUE #( (
          %cid = 'CID_CREATE_EDOC'
          edocflow = buffer-edocflow
          UniqueValue = buffer-unique_value
          filename = buffer-filename
          filenamezip = buffer-filenamezip
          mimetypexml = buffer-mimetypexml
          xmldata = buffer-xmldata
          mimetypezip = buffer-mimetypezip
          zipdata = buffer-zipdata
          ernam = buffer-ernam
          erdat = buffer-erdat
          erzet = buffer-erzet
          tmstp = buffer-tmstp
          createdon = buffer-created_on
*          createdby = buffer-created_by
          creationuser = buffer-creation_user
*          lastchangedby = buffer-lastchangedby
*          locallastchanged = buffer-local_last_changed
*          lastchanged = buffer-last_changed
          mimetypepdf = buffer-mimetypepdf
          filenamepdf = buffer-filenamepdf
          pdfdata = buffer-pdfdata
          filesraw = buffer-file_sraw
          %control-edocflow = if_abap_behv=>mk-on
          %control-uniquevalue = if_abap_behv=>mk-on
          %control-filename = if_abap_behv=>mk-on
          %control-filenamezip = if_abap_behv=>mk-on
          %control-mimetypexml = if_abap_behv=>mk-on
          %control-xmldata = if_abap_behv=>mk-on
          %control-mimetypezip = if_abap_behv=>mk-on
          %control-zipdata = if_abap_behv=>mk-on
          %control-ernam = if_abap_behv=>mk-on
          %control-erdat = if_abap_behv=>mk-on
          %control-erzet = if_abap_behv=>mk-on
          %control-tmstp = if_abap_behv=>mk-on
          %control-createdon = if_abap_behv=>mk-on
*          %control-createdby = if_abap_behv=>mk-on
          %control-creationuser = if_abap_behv=>mk-on
*          %control-lastchangedby = if_abap_behv=>mk-on
*          %control-locallastchanged = if_abap_behv=>mk-on
*          %control-lastchanged = if_abap_behv=>mk-on
          %control-mimetypepdf = if_abap_behv=>mk-on
          %control-filenamepdf = if_abap_behv=>mk-on
          %control-pdfdata = if_abap_behv=>mk-on
          %control-filesraw = if_abap_behv=>mk-on
        ) )
        MAPPED DATA(edocdb_mapped)
        FAILED DATA(edocdb_failed)
        REPORTED DATA(edocdb_reported).

    ENDLOOP.

  ENDMETHOD.
  METHOD update_entity_edocument.

    DATA: ls_edocument TYPE zr_oe_edocument.


    LOOP AT edocument_t INTO edocument.

      ls_edocument-UniqueValue = edocument-zunique_value.
*      ls_edocument-SeqNo = edocument-seq_no.
*      ls_edocument-Land = edocument-land.
*      ls_edocument-FileGuid = edocument-file_guid.
      ls_edocument-Status = edocument-status.
      ls_edocument-Statusdescr = edocument-statusdescr.
*      ls_edocument-Ernam = edocument-ernam.
*      ls_edocument-Erdat = edocument-erdat.
*      ls_edocument-Erzet = edocument-erzet.
*      ls_edocument-Tmstp = edocument-tmstp.
*      ls_edocument-Vatcode = edocument-vatcode.
*      ls_edocument-Cedente = edocument-cedente.
*      ls_edocument-DataFattura = edocument-data_fattura.
*      ls_edocument-Importototaledocumento = edocument-importototaledocumento.


      MODIFY ENTITIES OF zr_oe_edocument
            ENTITY Edocument
            UPDATE FROM VALUE #( (

               %data = ls_edocument
               %control = VALUE #(
*                 unique_value = if_abap_behv=>mk-on
*                 SeqNo = if_abap_behv=>mk-on
*                   Bukrs = if_abap_behv=>mk-on
*                 Land = if_abap_behv=>mk-on
*                 FileGuid = if_abap_behv=>mk-on
                 Status = if_abap_behv=>mk-on
                 Statusdescr = if_abap_behv=>mk-on
**                 Ernam = if_abap_behv=>mk-on
*                 Erdat = if_abap_behv=>mk-on
*                 Erzet = if_abap_behv=>mk-on
*                 Tmstp = if_abap_behv=>mk-on
*                 Vatcode = if_abap_behv=>mk-on
*                 Cedente = if_abap_behv=>mk-on
*                 DataFattura = if_abap_behv=>mk-on
*                 Importototaledocumento = if_abap_behv=>mk-on
   ) ) )
      MAPPED DATA(edocu_mapped)
      FAILED DATA(edocu_failed)
      REPORTED DATA(edocu_reported).

    ENDLOOP.

  ENDMETHOD.




  METHOD save_entity_edocument.

    DATA: ls_edocument TYPE zr_oe_edocument.


    LOOP AT edocument_t INTO edocument.

      ls_edocument-UniqueValue = edocument-zunique_value.
      ls_edocument-SeqNo = edocument-seq_no.
      ls_edocument-Land = edocument-land.
      ls_edocument-FileGuid = edocument-file_guid.
      ls_edocument-Status = edocument-status.
      ls_edocument-Statusdescr = edocument-statusdescr.
      ls_edocument-Ernam = edocument-ernam.
      ls_edocument-Erdat = edocument-erdat.
      ls_edocument-Erzet = edocument-erzet.
      ls_edocument-Tmstp = edocument-tmstp.
      ls_edocument-Vatcode = edocument-vatcode.
      ls_edocument-Cedente = edocument-cedente.
      ls_edocument-DataFattura = edocument-data_fattura.
      ls_edocument-Importototaledocumento = edocument-importototaledocumento.


      MODIFY ENTITIES OF zr_oe_edocument
            ENTITY Edocument
            CREATE FROM VALUE #( (
               %cid = 'CID_CREATE_EDOC'
               %data = ls_edocument
               %control = VALUE #(
                 UniqueValue = if_abap_behv=>mk-on
                 SeqNo = if_abap_behv=>mk-on
*                   Bukrs = if_abap_behv=>mk-on
                 Land = if_abap_behv=>mk-on
                 FileGuid = if_abap_behv=>mk-on
                 Status = if_abap_behv=>mk-on
                 Statusdescr = if_abap_behv=>mk-on
                 Ernam = if_abap_behv=>mk-on
                 Erdat = if_abap_behv=>mk-on
                 Erzet = if_abap_behv=>mk-on
                 Tmstp = if_abap_behv=>mk-on
                 Vatcode = if_abap_behv=>mk-on
                 Cedente = if_abap_behv=>mk-on
                 DataFattura = if_abap_behv=>mk-on
                 Importototaledocumento = if_abap_behv=>mk-on      ) ) )
      MAPPED DATA(edocu_mapped)
      FAILED DATA(edocu_failed)
      REPORTED DATA(edocu_reported).

    ENDLOOP.

  ENDMETHOD.

  METHOD save_entity_edocufile.
    DATA: ls_edocfile TYPE zr_oe_edocfile.

    LOOP AT edocumentfile_t INTO edocumentfile.
      ls_edocfile-FileGuid = edocumentfile-file_guid.
      ls_edocfile-ZuniqueValue = edocumentfile-zunique_value.
      ls_edocfile-SeqNo = edocumentfile-seq_no.
      ls_edocfile-Filename = edocumentfile-filename.
      ls_edocfile-Filenamezip = edocumentfile-filenamezip.
      ls_edocfile-Mimetypexml = edocumentfile-mimetypexml.
      ls_edocfile-Xmldata = edocumentfile-xmldata.
      ls_edocfile-Mimetypezip = edocumentfile-mimetypezip.
      ls_edocfile-Zipdata = edocumentfile-zipdata.
      ls_edocfile-CreatedOn = edocumentfile-created_on.
      ls_edocfile-CreatedBy = edocumentfile-created_by.
      ls_edocfile-Lastchangedby = edocumentfile-lastchangedby.
      ls_edocfile-LocalLastChanged = edocumentfile-local_last_changed.
      ls_edocfile-LastChanged = edocumentfile-last_changed.
      ls_edocfile-FileRaw = edocumentfile-file_raw.
      ls_edocfile-Mimetypepdf = edocumentfile-mimetypepdf.
      ls_edocfile-Filenamepdf = edocumentfile-filenamepdf.
      ls_edocfile-Pdfdata = edocumentfile-pdfdata.
      ls_edocfile-FileSraw = edocumentfile-file_sraw.



      MODIFY ENTITIES OF zr_oe_edocfile
            ENTITY EdocumentFile
            CREATE FROM VALUE #( (
                %cid = 'CID_CREATE_EDOC'
               %data = ls_edocfile
               %control = VALUE #(
               FileGuid = if_abap_behv=>mk-on
               ZuniqueValue = if_abap_behv=>mk-on
               SeqNo = if_abap_behv=>mk-on
               Filename = if_abap_behv=>mk-on
               Filenamezip = if_abap_behv=>mk-on
               Mimetypexml = if_abap_behv=>mk-on
               Xmldata = if_abap_behv=>mk-on
               Mimetypezip = if_abap_behv=>mk-on
               Zipdata = if_abap_behv=>mk-on
               CreatedOn = if_abap_behv=>mk-on
               CreatedBy = if_abap_behv=>mk-on
               Lastchangedby = if_abap_behv=>mk-on
               LocalLastChanged = if_abap_behv=>mk-on
               LastChanged = if_abap_behv=>mk-on
               FileRaw = if_abap_behv=>mk-on
               Mimetypepdf = if_abap_behv=>mk-on
               Filenamepdf = if_abap_behv=>mk-on
               Pdfdata = if_abap_behv=>mk-on
               FileSraw = if_abap_behv=>mk-on )   ) )
            MAPPED DATA(edocuf_mapped)
            FAILED DATA(edocuf_failed)
            REPORTED DATA(edocuf_reported).
      " Gestione degli errori
*      IF edocuf_failed IS NOT INITIAL.
*
*        RETURN.
*      ENDIF.

*      " Messaggio di successo
*      APPEND VALUE #( %msg = new_message_with_text(
*                       severity = if_abap_behv_message=>severity-success
*                       text     = 'Document created successfully in OCRA Edocument'
*                     ) ) TO edocuf_reported-EdocumentFile.
    ENDLOOP.


  ENDMETHOD.


ENDCLASS.
