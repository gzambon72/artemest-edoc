CLASS zcl_zoe_edoc DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !iv_edoc_guid TYPE zunique_value OPTIONAL
        !iv_edocflow  TYPE zedocflow DEFAULT 'EDOC'
        !is_new       TYPE abap_bool DEFAULT abap_true
        !unit_test    TYPE abap_bool DEFAULT abap_false
        !filename     TYPE string OPTIONAL
        !iv_content   TYPE zedoc_db-xdata OPTIONAL .
    METHODS execute_action
      IMPORTING
        !iv_action TYPE string .
  PROTECTED SECTION.

    DATA edocument TYPE zoe_edocument .
    DATA edocumentfile TYPE zoe_edocfile .
    DATA new TYPE abap_bool .
    DATA filename TYPE string.
    DATA action TYPE string .
    DATA file_guid TYPE zunique_value .
    DATA edoc_guid TYPE zunique_value .
    DATA xcontent TYPE zedoc_db-xdata .
    DATA edocflow TYPE zedocflow .
    DATA buffer TYPE zedoc_db .
  PRIVATE SECTION.

    METHODS xml_2_buffer .
    METHODS edoc_save_2_db .
    METHODS xml_display .
    METHODS pdf_display .
    METHODS create .
    METHODS updateinvoice .
    METHODS display_file .
    METHODS display_pdf .
    METHODS iv_park .
    METHODS iv_post .
    METHODS upload_file .
    METHODS upload_xml .
    METHODS validate_source .
    METHODS delete .
    METHODS init_data_for_unit_test.
ENDCLASS.



CLASS zcl_zoe_edoc IMPLEMENTATION.


  METHOD constructor.

    me->new = is_new.
    me->xcontent = iv_content.
    me->edocflow = iv_edocflow .
    me->filename = filename.


    IF unit_test = abap_true.
*
*      DELETE FROM zedoc_db.
*      DELETE FROM zoe_edocument.
*      DELETE FROM zoe_edocfile.
*
*      DATA flow TYPE zedoc_flow.
*      flow  = VALUE #(  edocgroup = 'INBOUND' edocflow = iv_edocflow edocflowdescr = 'EDOCUMENT INCOMING INVOICE'   ).

*      MODIFY zedoc_flow FROM @flow.

      DO 10 TIMES.
        me->filename  = 'unit_test' && sy-index && '.xml'.
        CONDENSE  me->filename NO-GAPS.
        init_data_for_unit_test(  ).
      ENDDO.
    ENDIF.

    CHECK unit_test = abap_false.

    CASE new.
      WHEN abap_true.
        IF  iv_edoc_guid IS NOT SUPPLIED.
          DATA(unique_value) = cl_system_uuid=>create_uuid_c36_static( )  .
        ELSE.
          unique_value = iv_edoc_guid.
        ENDIF.

        me->edoc_guid = unique_value.
        me->file_guid  = unique_value.

*        me->edocument-zunique_value = me->edoc_guid.
*        me->edocument-file_guid = me->file_guid.

        me->edocument = VALUE #(  zunique_value = me->edoc_guid   file_guid = file_guid  status = 1 statusdescr = 'Ricevuto da Intermediario' ).

        me->edocumentfile = VALUE #(  file_guid = file_guid zunique_value = me->edoc_guid   file_raw = me->xcontent
           filename = filename  mimetypexml = 'application/xml' xmldata = me->xcontent  ).

*        me->edocumentfile-file_guid = me->file_guid.
*        me->edocumentfile-zunique_value = me->edoc_guid.
*        me->edocumentfile-file_raw = me->xcontent.
*        me->edocumentfile-filename = filename.

        me->xml_2_buffer( ).
      WHEN abap_false.
        me->edoc_guid = iv_edoc_guid.

        SELECT SINGLE * FROM zedoc_db WHERE unique_value = @me->edoc_guid INTO @me->buffer .
        check sy-subrc = 0.
        SELECT SINGLE * FROM zoe_edocument  WHERE zunique_value = @me->edoc_guid INTO @me->edocument.
        SELECT SINGLE * FROM zoe_edocfile  WHERE file_guid = @me->edocument-file_guid INTO @me->edocumentfile.
        me->file_guid  = me->edocumentfile-file_guid.
        me->filename = me->edocumentfile-filename.
        xcontent = me->buffer-xdata.
    ENDCASE.
  ENDMETHOD.

  METHOD init_data_for_unit_test.


    DATA(o_ut) = NEW zcl_zoe_edoc_unit_test(  ).

    me->xcontent = o_ut->get_xstring(  ).

    DATA(unique_value) = cl_system_uuid=>create_uuid_c36_static( )  .

    me->edoc_guid = unique_value.
    me->file_guid  = unique_value.

    me->edocument = VALUE #(  zunique_value = me->edoc_guid   file_guid = file_guid  status = 1 statusdescr = 'Ricevuto da Intermediario' ).

    me->edocumentfile = VALUE #(  file_guid = file_guid zunique_value = me->edoc_guid   file_raw = me->xcontent
       filename = filename  mimetypexml = 'application/xml' xmldata = me->xcontent  ).

    me->xml_2_buffer( ).
    me->execute_action( 'CREATE' ).

  ENDMETHOD.

  METHOD create.
    edoc_save_2_db( ).
  ENDMETHOD.


  METHOD delete.

    DELETE zoe_edocument FROM @me->edocument.

    DELETE zoe_edocfile FROM @me->edocumentfile.

    DELETE zedoc_db FROM @me->buffer.

  ENDMETHOD.


  METHOD display_file.
  ENDMETHOD.


  METHOD display_pdf.
  ENDMETHOD.


  METHOD edoc_save_2_db.

    MODIFY zoe_edocument FROM @me->edocument.

    MODIFY zoe_edocfile FROM @me->edocumentfile.

  ENDMETHOD.


  METHOD execute_action.
    CASE  iv_action.
      WHEN 'CREATE'. create( ).
      WHEN 'UPDATEINVOICE'. updateinvoice( ).
      WHEN 'DELETE'. delete( ).
      WHEN 'DISPLAY_XML'. xml_display( ).
      WHEN 'DISPLAY_PDF'. display_pdf( ).
      WHEN 'IV_PARK'. iv_park( ).
      WHEN 'IV_POST'  . iv_post( ).
      WHEN 'UPLOAD_FILE'. upload_file( ).
      WHEN 'UPLOAD_XML'. upload_xml( ).
      WHEN 'VALIDATE_SOURCE'. validate_source( ).
    ENDCASE.

  ENDMETHOD.


  METHOD iv_park.
  ENDMETHOD.


  METHOD iv_post.
    me->edocument-status = 2. " xml postato in SAP
    me->edocument-statusdescr = 'xml postato in SAP'.

    UPDATE zoe_edocument SET status = @me->edocument-status,
                           statusdescr = @me->edocument-statusdescr
                      WHERE zunique_value = @me->edocument-zunique_value.

  ENDMETHOD.


  METHOD pdf_display.
  ENDMETHOD.


  METHOD updateinvoice.
    edoc_save_2_db( ).
  ENDMETHOD.


  METHOD upload_file.
  ENDMETHOD.


  METHOD upload_xml.
  ENDMETHOD.


  METHOD validate_source.
  ENDMETHOD.


  METHOD xml_2_buffer.
    DATA ls_data TYPE zedoc_db.

    GET TIME STAMP FIELD DATA(tmstp).
    ls_data  = VALUE #( edocflow = me->edocflow   unique_value = me->edoc_guid
    mimetypexml = 'application/xml' xmldata = me->xcontent filename = me->edocumentfile-filename
     xdata = me->xcontent ernam = sy-uname erdat = sy-datum erzet = sy-uzeit tmstp = tmstp ).
    MODIFY zedoc_db FROM @ls_data.
    " COMMIT WORK..

    me->buffer = ls_data.

  ENDMETHOD.


  METHOD xml_display.

  ENDMETHOD.
ENDCLASS.
