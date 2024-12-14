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
    DATA xcontent TYPE xstring.
    DATA(action) = request->get_header_field( 'action' ).
    DATA(i_filename) = request->get_header_field( 'filename' ).
    CONSTANTS c_mime_zip TYPE string VALUE 'application/zip' .
    DATA o_dispatcher TYPE REF TO zcl_zoe_dispatcher.
    DATA(path_info) =  request->get_header_field( i_name = '~path_info' ).
    DATA edocflow TYPE zedocflow.
    DATA xml_base64_x_encoded TYPE xstring.
    TRY.


        DATA r_value TYPE if_web_http_request=>name_value_pairs.

*        r_value = request->get_header_fields( ).

        DATA(lv_request_body) =  request->get_text( ).

*** da xml a zip ***

        DATA(o_model) = NEW  zcl_sdi_xml_model( ).
        TRANSLATE path_info TO UPPER CASE .

        CASE  path_info.
          WHEN 'EDOCI_CREATE'.
            edocflow = 'EDOCI'.
            action =  'EDOCI_CREATE'.
          WHEN 'CREATE_UNIT_TEST_ZIP'.
            edocflow = 'EDOCI'.
            action =  'CREATE_UNIT_TEST_ZIP'.
          WHEN 'CREATE_UNIT_TEST_ZIP_OUT'.
            action =  'CREATE_UNIT_TEST_ZIP'.
            edocflow = 'EDOCO'.
          WHEN 'UNIT-TEST-ZIP'.
            lv_request_body = o_model->get_content_dummy(  ).
            action = 'ZIP'.
          WHEN 'UNIT-TEST-ZIP-GET'.
            action = 'ZIP-GET'.
          WHEN 'UNIT-TEST-CREATE'.
            action = 'CREATE_UNIT_TEST'.
          WHEN 'XML-GET'.
            action = 'XML-GET'.
          WHEN 'UPLOAD-XML'.
            action = 'UPLOAD-XML'.
          WHEN OTHERS.
        ENDCASE.


        DATA(xoutput) = o_model->get_encoded_xml( lv_request_body  ).
        DATA o_edoc TYPE REF TO zcl_zoe_edoc.
        DATA(unique_value) = cl_system_uuid=>create_uuid_c36_static( )  .

        CASE action.
          WHEN 'EDOCI_CREATE'.

            IF i_filename IS INITIAL.
              i_filename = 'test-postman.xml'.
            ENDIF.
            lv_filename = i_filename.

            xml_base64_x_encoded  =  request->get_binary( ).

            o_dispatcher = NEW zcl_zoe_dispatcher(
               iv_edoc_guid = unique_value
               xcontent =  xml_base64_x_encoded
               content = lv_request_body
                edocflow = edocflow
               filename = lv_filename ).

            o_dispatcher->execute_action( 'CREATE_FROM_REST' ).
            response->set_text( '<h1>CREATE_UNIT_TEST ---> SUCCESS to STAGING and EDOCUMENT<h1>' ).

*            response->set_header_field(
*           EXPORTING
*             i_name  = 'Content-Type'
*             i_value = 'application/xml' ).  "MIME type per FIP
*
*
*            response->set_text( lv_request_body ).
          WHEN  'CREATE_UNIT_TEST_ZIP'.
            SELECT * FROM zedoc_db INTO @DATA(wa) .
            ENDSELECT.

            DATA(content) = wa-file_sraw .


            xml_base64_x_encoded = wa-xmldata.

            lv_filename = wa-filename.



            o_dispatcher = NEW zcl_zoe_dispatcher(
               iv_edoc_guid = unique_value
               xcontent =  xml_base64_x_encoded
*               content = wa-file_sraw
                edocflow = edocflow
               filename = lv_filename ).

            o_dispatcher->execute_action( 'CREATE_FROM_REST' ).
            response->set_text( '<h1>CREATE_UNIT_TEST ---> SUCCESS to STAGING and EDOCUMENT<h1>' ).

          WHEN  'CREATE_UNIT_TEST'.

            o_dispatcher  = NEW zcl_zoe_dispatcher(  ).
            o_dispatcher->execute_action(  action ).
            response->set_text( '<h1>CREATE_UNIT_TEST ---> SUCCESS<h1>' ).

          WHEN 'XML-GET'.

            response->set_header_field(
          EXPORTING
            i_name  = 'Content-Type'
            i_value = 'application/xml' ).  "MIME type per FIP


            response->set_binary( xoutput ).



          WHEN 'ZIP-GET'.

            SELECT * FROM zedoc_db INTO  @wa  UP TO 1 ROWS.
            ENDSELECT.

            lv_zip   = wa-zipdata.

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
              e_filename_zip    = lv_filename
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
              e_filename_zip    = lv_filename
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
            i_value = 'application/xml' ).  "


            response->set_text( response_xml ).


        ENDCASE.

      CATCH cx_root INTO DATA(lo_error).

        response->set_text( 'error in program' ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
