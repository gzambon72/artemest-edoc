CLASS zcl_restcontentdisp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_restcontentdisp IMPLEMENTATION.
  METHOD if_http_service_extension~handle_request.
    DATA lv_filename TYPE string.
    DATA lv_zip TYPE xstring.
    DATA(action) = request->get_header_field( 'ACTION' ).

    DATA(path_info) =  request->get_header_field( i_name = '~path_info' ).
    TRY.

        DATA(lv_request_body) =  request->get_text( ).

*** da xml a zip ***

        DATA(o_model) = NEW  zcl_sdi_xml_model( ).
        TRANSLATE path_info TO UPPER CASE .

        CASE  path_info.
          WHEN 'UNIT-TEST-ZIP'.
            lv_request_body = o_model->get_content_dummy(  ).
            action = 'ZIP'.
          WHEN 'UNIT-TEST-ZIP-GET'.
            action = 'ZIP-GET'.
          WHEN 'UNIT-TEST-CREATE'.
            action = 'CREATE_UNIT_TEST'.
          WHEN OTHERS.
        ENDCASE.

        CASE action.
          WHEN 'ZIP-GET'.

            SELECT * FROM zedoc_db INTO @DATA(wa) UP TO 1 ROWS.
            ENDSELECT.
            lv_zip   = wa-pdfdata.

            lv_filename = 'test-download-da-db.zip'.


            response->set_header_field(
          EXPORTING
            i_name  = 'Content-Type'
            i_value = 'application/zip' ).  "MIME type per FIP

            "Imposta Content-Disposition per far scaricare il file
            response->set_header_field(
              EXPORTING
                i_name  = 'Content-Disposition'
                i_value = |attachment; filename="{ lv_filename }"| ).


            "Imposta Content-Length
            response->set_header_field(
              EXPORTING
                i_name  = 'Content-Length'
                i_value = CONV string( xstrlen( lv_zip ) ) ).

            "Imposta il contenuto binario del file
            response->set_binary( lv_zip ).
          WHEN 'ZIP'.

            o_model->from_xml_to_zip(
            EXPORTING
              lv_xml_string = lv_request_body
            IMPORTING
              e_filename    = lv_filename
              e_zip         =  lv_zip  )    .

            response->set_header_field(
          EXPORTING
            i_name  = 'Content-Type'
            i_value = 'application/zip' ).  "MIME type per FIP

            "Imposta Content-Disposition per far scaricare il file
            response->set_header_field(
              EXPORTING
                i_name  = 'Content-Disposition'
                i_value = |attachment; filename="{ lv_filename }"| ).


            "Imposta Content-Length
            response->set_header_field(
              EXPORTING
                i_name  = 'Content-Length'
                i_value = CONV string( xstrlen( lv_zip ) ) ).

            "Imposta il contenuto binario del file
            response->set_binary( lv_zip ).
          WHEN 'XML'.

            o_model->from_xml_to_zip(
            EXPORTING
              lv_xml_string = lv_request_body
            IMPORTING
              e_filename    = lv_filename
              e_zip         =  lv_zip  )    .


            o_model->from_zip_to_xml(
            EXPORTING
              i_filename    = lv_filename
              i_zip         =  lv_zip
            RECEIVING
              lv_xml_string = DATA(response_xml) )    .

            response->set_header_field(
          EXPORTING
            i_name  = 'Content-Type'
            i_value = 'application/xml' ).  "MIME type per FIP


            response->set_text( response_xml ).


          WHEN  'CREATE_UNIT_TEST'.
            DATA o_edoc TYPE REF TO zcl_zoe_edoc.

            o_edoc = NEW zcl_zoe_edoc( ).

            response->set_text( 'NO error in program' ).

        ENDCASE.

      CATCH cx_root INTO DATA(lo_error).

        response->set_text( 'error in program' ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
