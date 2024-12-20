CLASS lhc_zr_mri_invoice001 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
*    DATA o_edoc TYPE REF TO zcl_zoe_edoc.
    DATA o_dispatcher TYPE REF TO zcl_zoe_dispatcher.
    METHODS get_instance_features FOR INSTANCE FEATURES IMPORTING keys REQUEST requested_features FOR Invoice RESULT result.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Invoice
        RESULT result,

      document_post FOR MODIFY
        IMPORTING keys FOR ACTION Invoice~document_post  RESULT result.
ENDCLASS.

CLASS lhc_zr_mri_invoice001 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD get_instance_features.
  ENDMETHOD.
  METHOD document_post.

    LOOP AT keys INTO DATA(key).
      o_dispatcher = NEW zcl_zoe_dispatcher( invoice = key-Invoice ).
      o_dispatcher->execute_action(  'POST_FROM_IMVOICE' ).
      FREE o_dispatcher.

      READ ENTITIES OF zr_mri_invoice001 IN LOCAL MODE
       ENTITY Invoice
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(invoices).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
