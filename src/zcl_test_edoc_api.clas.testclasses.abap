"!@testing SRVB:ZEDOC_API_V4
CLASS lcl_test_edoc_api  DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA lv_xml_xstring TYPE xstring.
    DATA lv_xml_string  TYPE string.


    METHODS:
      setup,
      create FOR TESTING RAISING cx_static_check.

    DATA:
      mo_cut         TYPE REF TO object,
      mo_environment TYPE REF TO if_cds_test_environment.

ENDCLASS.

CLASS lcl_test_edoc_api IMPLEMENTATION.
  METHOD setup.

    lv_xml_string  =
     |<?xml version="1.0" encoding="utf-8"?>\n| &&
     |<SalesOrder>\n| &&
     |  <Header>\n| &&
     |    <OrderNumber>4500000123</OrderNumber>\n| &&
     |    <OrderDate>2024-12-07</OrderDate>\n| &&
     |    <Customer>\n| &&
     |      <ID>1000</ID>\n| &&
     |      <Name>ACME Corporation</Name>\n| &&
     |      <Country>IT</Country>\n| &&
     |    </Customer>\n| &&
     |  </Header>\n| &&
     |  <Items>\n| &&
     |    <Item>\n| &&
     |      <Position>10</Position>\n| &&
     |      <MaterialNumber>MAT001</MaterialNumber>\n| &&
     |      <Quantity>100</Quantity>\n| &&
     |      <Unit>PC</Unit>\n| &&
     |      <Price>10.50</Price>\n| &&
     |    </Item>\n| &&
     |    <Item>\n| &&
     |      <Position>20</Position>\n| &&
     |      <MaterialNumber>MAT002</MaterialNumber>\n| &&
     |      <Quantity>50</Quantity>\n| &&
     |      <Unit>PC</Unit>\n| &&
     |      <Price>25.00</Price>\n| &&
     |    </Item>\n| &&
     |  </Items>\n| &&
     |</SalesOrder>|.


    " Convert to xstring
    lv_xml_xstring = xco_cp=>string( lv_xml_string )->as_xstring( xco_cp_character=>code_page->utf_8 )->value.


    " Prepare test data
    DATA: lt_edoc_api TYPE STANDARD TABLE OF zedoc_api.



    lt_edoc_api = VALUE #( ( filename = 'test.xml'
                            fileformat = 'application/xml'
                            file_raw = lv_xml_string ) ) .

    mo_environment = cl_cds_test_environment=>create( i_for_entity = 'ZEDOC_API_V' ).
    mo_environment->insert_test_data( lt_edoc_api ).

check 1 = 2.

    DATA:

      lo_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request      TYPE REF TO /iwbep/if_cp_request_create,
      lo_response     TYPE REF TO /iwbep/if_cp_response_create.



    lo_client_proxy = /iwbep/cl_cp_factory_unit_tst=>create_v2_local_proxy(
                    EXPORTING
                      is_service_key     = VALUE #( service_id      = 'ZEDOC_API_V2'
                                                    service_version = '0001' )
                       iv_do_write_traces = abap_true ).

    " Navigate to the resource and create a request for the create operation
    lo_request = lo_client_proxy->create_resource_for_entity_set( 'EdocAPI' )->create_request_for_create( ).



    DATA ls_business_data TYPE zedoc_api_s.

    lv_xml_xstring = 'PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4='.

    ls_business_data  = VALUE #( filename = 'test.xml'
                               fileformat = 'application/xml'
*                            file_raw = cl_abap_codepage=>convert_to( 'Test Content' ) ) ).
                               file_raw = lv_xml_string ).

    " Set the business data for the created entity
    lo_request->set_business_data( ls_business_data  ).

    " Execute the request
    lo_response = lo_request->execute( ).
    "
  ENDMETHOD.

  METHOD create.
    DATA lt_failed   TYPE RESPONSE FOR FAILED EARLY zedoc_api_v.
    DATA lt_mapped   TYPE RESPONSE FOR MAPPED EARLY zedoc_api_v.
    DATA lt_reported TYPE RESPONSE FOR REPORTED EARLY zedoc_api_v.


    MODIFY ENTITIES OF zedoc_api_v
      ENTITY edocapi
        CREATE SET FIELDS WITH VALUE #(
          ( %cid = 'doc2'
            filename = 'test2.xml'
            fileformat = 'application/xml'
            fileraw = lv_xml_string ) )
      MAPPED lt_mapped
      FAILED lt_failed
      REPORTED lt_reported.

*    cl_abap_unit_assert=>assert_initial( lt_failed ).
  ENDMETHOD.
ENDCLASS.
