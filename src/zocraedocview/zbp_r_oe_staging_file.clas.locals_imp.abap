CLASS lhc_zr_oe_staging_file DEFINITION INHERITING FROM cl_abap_behavior_handler.
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

CLASS lhc_zr_oe_staging_file IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD get_instance_features.
  ENDMETHOD.
  METHOD document_post.

    LOOP AT keys INTO DATA(key).

      o_dispatcher = NEW zcl_zoe_dispatcher( invoice = key-Invoice ).
      o_dispatcher->execute_action(  'POST_FROM_STAGING' ).

      DATA(severity) = o_dispatcher->severity.
      DATA(action_text) = o_dispatcher->action_text.

      FREE o_dispatcher.

      READ ENTITIES OF zr_oe_staging_file IN LOCAL MODE
       ENTITY Staging
       FROM VALUE #( ( Invoice = keys[ 1 ]-Invoice ) )
       RESULT DATA(staging)
       FAILED DATA(staiging_failed)
       REPORTED DATA(staging_reported).

      APPEND VALUE #( %msg = new_message_with_text(
                       severity = severity
                       text     = action_text
                     ) ) TO reported-staging.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
