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

    TRY.
        DATA e_content TYPE string.

        DATA(xstring) = request->get_binary(  ).

        DATA(o_ut) = NEW zcl_zoe_edoc_unit_test(  ).

        xstring = o_ut->get_xstring(  ).


        CALL TRANSFORMATION id
                 SOURCE XML xstring
                 RESULT  XML e_content.

        " Impostazione response
        response->set_header_field(
          i_name  = 'Content-Type'
          i_value = 'application/xml; charset=utf-8'
        ).

        " Set CORS headers
        response->set_header_field(
            i_name  = 'Access-Control-Allow-Origin'
            i_value = '*'
        ).
*        response->set_header_field(
*            i_name  = 'Access-Control-Allow-Methods'
*            i_value = 'GET, POST, OPTIONS'
*        ).
*        response->set_header_field(
*            i_name  = 'Access-Control-Allow-Headers'
*            i_value = 'Content-Type, Authorization'
*        ).

        response->set_text( e_content ).

      CATCH cx_root INTO DATA(lx_error).
        " Gestione errori
        response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
        response->set_text( lx_error->get_text( ) ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
