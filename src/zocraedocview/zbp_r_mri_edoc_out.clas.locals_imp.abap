CLASS lhc_zr_MRI_EDOC_OUT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
*    DATA o_edoc TYPE REF TO zcl_zoe_edoc.
    DATA o_dispatcher TYPE REF TO zcl_zoe_dispatcher.
    METHODS get_instance_features FOR INSTANCE FEATURES IMPORTING keys REQUEST requested_features FOR EdocFile RESULT result.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR EdocFile
        RESULT result,

      document_download FOR MODIFY
        IMPORTING keys FOR ACTION EdocFile~document_download  RESULT result.
ENDCLASS.

CLASS lhc_zr_MRI_EDOC_OUT IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD get_instance_features.
  ENDMETHOD.
  METHOD document_download.
    LOOP AT keys INTO DATA(key).
*      o_dispatcher = NEW zcl_zoe_dispatcher( invoice = key-Invoice ).
*      o_dispatcher->execute_action(  'CREATE' ).



*      FREE o_dispatcher.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
