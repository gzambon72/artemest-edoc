CLASS zcl_icf_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

   PUBLIC SECTION.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_icf_demo IMPLEMENTATION.
  METHOD if_http_service_extension~handle_request.

    TRY.



*        DATA(lv_xml_string) = cl_abap_codepage=>convert_from( lv_xml ).


        " Impostazione response
        response->set_header_field(
          i_name  = 'Content-Type'
          i_value = 'application/xml; charset=utf-8'
        ).

        data(xstring) = request->get_binary(  ).

        response->set_binary( xstring ).

      CATCH cx_root INTO DATA(lx_error).
        " Gestione errori
        response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
        response->set_text( lx_error->get_text( ) ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
