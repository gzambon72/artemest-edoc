CLASS lhc_electronicdocument DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES IMPORTING keys REQUEST requested_features FOR electronicdocument RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION IMPORTING keys REQUEST requested_authorizations FOR electronicdocument RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK electronicdocument.

    METHODS read FOR READ
      IMPORTING keys FOR READ electronicdocument RESULT result.


    METHODS fileupload FOR MODIFY
      IMPORTING keys FOR ACTION electronicdocument~fileupload RESULT result.

    METHODS pdf_display FOR MODIFY
      IMPORTING keys FOR ACTION electronicdocument~pdf_display RESULT result.

    METHODS xml_display FOR MODIFY
      IMPORTING keys FOR ACTION electronicdocument~xml_display RESULT result.

    METHODS document_post FOR MODIFY
      IMPORTING keys FOR ACTION electronicdocument~document_post RESULT result.

    METHODS uploadxml FOR MODIFY IMPORTING keys FOR  ACTION  electronicdocument~uploadxml  RESULT    result.

    METHODS uploadxml_model.

ENDCLASS.


CLASS lhc_electronicdocument IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD fileupload.
  ENDMETHOD.

  METHOD uploadxml.
    uploadxml_model(  ).
  ENDMETHOD.
  METHOD uploadxml_model.


    DATA(o_edoc) = NEW zcl_zoe_edoc( ).

  ENDMETHOD.

  METHOD pdf_display.


  ENDMETHOD.

  METHOD xml_display.
**    DATA(o_unit_test) = NEW zcl_zoe_edoc_unit_test( ).
*    DATA xstring TYPE xstring.
*    DATA lv_xml_content TYPE string.
*
**    xstring  = o_unit_test->fake_xml_display_for_test( ).
*    DATA o_edoc TYPE REF TO zcl_zoe_edoc.
*
*    LOOP AT keys INTO DATA(key).
*
*      DATA(unique_value) = key-unique_value.
*
*      CHECK unique_value IS NOT INITIAL.
*
*      CREATE OBJECT o_edoc
*        EXPORTING
*          unit_test    = abap_false
**         filename     = filename
*          iv_edoc_guid = unique_value
**         iv_edocflow  = 'EDOC'
*          is_new       = abap_false
***         iv_content   = xdata
*        .
*
*      o_edoc->execute_action( 'DISPLAY_XML' )  .
*
*      FREE o_edoc.

*    ENDLOOP.
*
*
*    CALL TRANSFORMATION id
*             SOURCE XML xstring
*             RESULT  XML lv_xml_content.



  ENDMETHOD.

  METHOD document_post.
    DATA o_edoc TYPE REF TO zcl_zoe_edoc.
    DATA o_dispatcher TYPE REF TO zcl_zoe_dispatcher.


    LOOP AT keys INTO DATA(key).

      DATA(unique_value) = key-unique_value.

      CHECK unique_value IS NOT INITIAL.

      o_dispatcher = NEW zcl_zoe_dispatcher( iv_edoc_guid = unique_value  ).
      o_dispatcher->execute_action(  'IV_POST' ).
*      CREATE OBJECT o_edoc
*        EXPORTING
*          unit_test    = abap_false.
**         filename     = filename
*          iv_edoc_guid = unique_value
**         iv_edocflow  = 'EDOC'
*          is_new       = abap_false
***         iv_content   = xdata
*        .
*
*      o_edoc->execute_action( 'IV_POST' )  .
*
*      FREE o_edoc.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zcds_edoc_view DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lsc_zcds_edoc_view IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

ENDCLASS.
