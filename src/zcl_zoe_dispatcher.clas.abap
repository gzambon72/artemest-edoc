CLASS zcl_zoe_dispatcher DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        !iv_edoc_guid TYPE zunique_value OPTIONAL
        !iv_edocflow  TYPE zedocflow DEFAULT 'EDOC'
        !is_new       TYPE abap_bool DEFAULT abap_true
        !unit_test    TYPE abap_bool DEFAULT abap_true
        !filename     TYPE string OPTIONAL
        !iv_content   TYPE zedoc_db-xmldata OPTIONAL .
    METHODS execute_action
      IMPORTING
        !iv_action TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA  content TYPE string .
    DATA edocflow TYPE zedocflow .
    DATA new TYPE abap_bool .
    DATA filename TYPE string.
    DATA o_edoc type ref to zcl_zoe_edoc.
ENDCLASS.



CLASS zcl_zoe_dispatcher IMPLEMENTATION.

  METHOD constructor.
    o_edoc = NEW zcl_zoe_edoc( ).
    edocflow = 'EDOC'.
  ENDMETHOD.

  METHOD execute_action.

    o_edoc->execute_action(  iv_action ).
  ENDMETHOD.
ENDCLASS.
