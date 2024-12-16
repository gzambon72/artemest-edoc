CLASS zcl_zoe_dispatcher_rest DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA response TYPE REF TO if_web_http_response READ-ONLY.
    DATA edocument TYPE zoe_Edocument READ-ONLY.
    DATA edocument_t TYPE zoe_Edocument_t READ-ONLY.
    DATA edocumentfile TYPE zoe_edocfile READ-ONLY .
    DATA edocumentfile_t TYPE zoe_edocfile_t READ-ONLY.
    DATA buffer TYPE zedoc_db.
    DATA buffer_t TYPE zedoc_db_t.
    METHODS constructor
      IMPORTING
        VALUE(request)  TYPE REF TO if_web_http_request
        VALUE(response) TYPE REF TO if_web_http_response .
    METHODS execute_action
      IMPORTING
        !iv_action TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA o_dispatcher TYPE REF TO zcl_zoe_dispatcher.
    DATA content TYPE zedoc_db-xmldata .
    DATA edocflow TYPE zedocflow .
    DATA new TYPE abap_bool .
    DATA filename TYPE string.
    DATA edoc_guid TYPE zunique_value .
    DATA o_edoc TYPE REF TO zcl_zoe_edoc.
    DATA request  TYPE REF TO if_web_http_request.

ENDCLASS.

CLASS zcl_zoe_dispatcher_rest IMPLEMENTATION.

  METHOD constructor.
    DATA lv_filename TYPE string.
    DATA lv_zip TYPE xstring.
    DATA xcontent TYPE xstring.
    CONSTANTS c_mime_zip TYPE string VALUE 'application/zip' .
    CONSTANTS c_mime_xml TYPE string VALUE 'application/xml' .
    CONSTANTS c_mime_pdf TYPE string VALUE 'application/pdf' .

    me->request = request.
    me->response = response.

    DATA(action) = request->get_header_field( 'action' ).
    DATA(edoc_guid) = request->get_header_field( 'edoc_guid' ).
    DATA(parent_edoc_guid) = request->get_header_field( 'parent_edoc_guid' ).
    DATA i_parent_edoc_guid  TYPE zunique_value.
    DATA(i_filename) = request->get_header_field( 'filename' ).
    DATA(path_info) =  request->get_header_field( i_name = '~path_info' ).
    DATA(content_type) = request->get_header_field( 'content-type' ).

    DATA(headers) = request->get_header_fields( ).
    DATA r_value TYPE if_web_http_request=>name_value_pairs.

    I_parent_edoc_guid = parent_edoc_guid.

    DATA(lv_request_body) =  request->get_text( ).

*    DATA(unique_value) = cl_system_uuid=>create_uuid_c36_static( )  .
    DATA i_edoc_guid TYPE zunique_value.
    TRANSLATE path_info TO UPPER CASE .
    CASE  path_info.
      WHEN 'EDOCI_CREATE'.
        edocflow = 'EDOCI'.
        CASE content_type.
          WHEN c_mime_xml.
            action =  'EDOCI_CREATE'.
          WHEN c_mime_pdf.
            action =  'EDOCI_CREATE_PDF'.
          WHEN c_mime_zip.
            action =  'EDOCI_CREATE_ZIP'.
        ENDCASE.
      WHEN 'EDOCO_CREATE'.
        edocflow = 'EDOCO'.
        CASE content_type.
          WHEN c_mime_xml.
            action =  'EDOCO_CREATE'.
          WHEN c_mime_pdf.
            action =  'EDOCO_CREATE_PDF'.
          WHEN c_mime_zip.
            action =  'EDOCO_CREATE_ZIP'.
        ENDCASE.
      WHEN 'UNIT-TEST-CREATE'.
        action = 'CREATE_UNIT_TEST'.
    ENDCASE.

    DATA(xml_base64_x_encoded)  =  request->get_binary( ).

    CASE action.
      WHEN  'CREATE_UNIT_TEST'.

        o_dispatcher  = NEW zcl_zoe_dispatcher(  ).
        o_dispatcher->execute_action(  action ).

      WHEN 'EDOCI_CREATE'.

        IF i_filename IS INITIAL.
          i_filename = 'test-postman.xml'.
        ENDIF.

        lv_filename = i_filename.

        o_dispatcher = NEW zcl_zoe_dispatcher(
           iv_edoc_guid = i_edoc_guid
           xcontent =  xml_base64_x_encoded
           content = lv_request_body
            edocflow = edocflow
           filename = lv_filename ).

        o_dispatcher->execute_action( 'CREATE_FROM_REST' ).


      WHEN 'EDOCI_CREATE_ZIP'.
        IF i_filename IS INITIAL.
          i_filename = 'test-postman.zip'.
        ENDIF.

        lv_filename = i_filename.

        xml_base64_x_encoded  =  request->get_binary( ).
        xml_base64_x_encoded  =  request->get_form_field( 'file' ).

*** ---> FOR TESTING START --- zip content fake from edocument
        SELECT zipdata FROM zedoc_db INTO @xml_base64_x_encoded.
          EXIT.
        ENDSELECT.
*** ---> FOR TESTING END -- zip content fake from edocument


        o_dispatcher = NEW zcl_zoe_dispatcher(
           iv_edoc_guid = i_edoc_guid
           xcontent =  xml_base64_x_encoded
           content = lv_request_body
            edocflow = edocflow
           filename = lv_filename
           parent_edoc_guid = i_parent_edoc_guid ).

        o_dispatcher->execute_action(  'CREATE_ZIP' ).

      WHEN 'EDOCI_CREATE_PDF'.

        IF i_filename IS INITIAL.
          i_filename = 'test-postman.pdf'.
        ENDIF.

        lv_filename = i_filename.

        xml_base64_x_encoded  =  request->get_binary( ).
        xml_base64_x_encoded  =  request->get_form_field( 'file' ).

*** ---> FOR TESTING REPLACE Incominc pdf Content WITH pdf XML embedded START
        SELECT pdfdata FROM zedoc_db INTO @xml_base64_x_encoded.
          EXIT.
        ENDSELECT.
*** ---> FOR TESTING replace Incominc PDF Content with PDF XML EMBEDDED END


        o_dispatcher = NEW zcl_zoe_dispatcher(
           iv_edoc_guid = i_edoc_guid
           xcontent =  xml_base64_x_encoded
           content = lv_request_body
            edocflow = edocflow
           filename = lv_filename
           parent_edoc_guid = i_parent_edoc_guid ).

        o_dispatcher->execute_action(  'CREATE_PDF' ).

    ENDCASE.


    IF  o_dispatcher->pub_response IS INITIAL.
      response->set_text( '<h1>CREATE_UNIT_TEST ---> SUCCESS<h1>' ).
    ELSE.
      response->set_text( o_dispatcher->pub_response ).
    ENDIF.

    response->set_header_field(
            EXPORTING
                    i_name  = 'Content-Type'
                    i_value = 'application/json' ).

  ENDMETHOD.

  METHOD execute_action.
    o_edoc->execute_action(  iv_action ).
    edocument = o_edoc->edocument.
    edocumentfile = o_edoc->edocumentfile.
    buffer = o_edoc->buffer.
    edocument_t = o_edoc->edocument_t.
    edocumentfile_t = o_edoc->edocumentfile_t.
    buffer_t = o_edoc->buffer_t.
  ENDMETHOD.
ENDCLASS.
