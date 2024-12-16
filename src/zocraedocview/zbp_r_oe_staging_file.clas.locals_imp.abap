CLASS LHC_ZR_OE_STAGING_FILE DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    DATA o_dispatcher TYPE REF TO zcl_zoe_dispatcher.
    METHODS get_instance_features FOR INSTANCE FEATURES IMPORTING keys REQUEST requested_features FOR Staging RESULT result.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Staging
        RESULT result,

      document_post FOR MODIFY
        IMPORTING keys FOR ACTION Staging~document_post  RESULT result.
ENDCLASS.

CLASS LHC_ZR_OE_STAGING_FILE IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD get_instance_features.
  ENDMETHOD.
  METHOD document_post.

    LOOP AT keys INTO DATA(key).
      o_dispatcher = NEW zcl_zoe_dispatcher( invoice = key-Invoice ).
      o_dispatcher->execute_action(  'POST_FROM_IMVOICE' ).
      FREE o_dispatcher.

      READ ENTITIES OF ZR_OE_STAGING_FILE IN LOCAL MODE
       ENTITY Staging
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(Stagings).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
