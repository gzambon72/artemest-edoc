CLASS zcl_zoe_dispatcher DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA pub_response TYPE string READ-ONLY .
    METHODS constructor
      IMPORTING
        !iv_edoc_guid TYPE zunique_value OPTIONAL
        !iv_edocflow  TYPE zedocflow DEFAULT 'EDOCI'
        !is_new       TYPE abap_bool DEFAULT abap_true
        !unit_test    TYPE abap_bool DEFAULT abap_true
        !filename     TYPE string OPTIONAL
        xcontent      TYPE zedoc_db-xmldata OPTIONAL
        edocflow      TYPE zedoc_db-edocflow OPTIONAL
        content       TYPE string OPTIONAL
        invoice       TYPE zmri_invoice-invoice OPTIONAL
        parent_edoc_guid TYPE zunique_value OPTIONAL.
    METHODS execute_action
      IMPORTING
        !iv_action TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA edocument TYPE zoe_Edocument .
    DATA edocument_t TYPE zoe_Edocument_t .
    DATA edocumentfile TYPE zoe_edocfile   .
    DATA edocumentfile_t TYPE zoe_edocfile_t .
    DATA buffer TYPE zedoc_db.
    DATA buffer_t TYPE zedoc_db_t.
    DATA content TYPE zedoc_db-xmldata .
    DATA edocflow TYPE zedocflow .
    DATA new TYPE abap_bool .
    DATA filename TYPE string.
    DATA edoc_guid TYPE zunique_value .
    DATA o_edoc TYPE REF TO zcl_zoe_edoc.

ENDCLASS.

CLASS zcl_zoe_dispatcher IMPLEMENTATION.

  METHOD constructor.
    me->o_edoc = NEW zcl_zoe_edoc( ).
    me->edocflow  = edocflow.
    IF me->edocflow IS INITIAL.
      me->edocflow = 'EDOCI'.
    ENDIF..
    me->content = xcontent.
    me->filename = filename.
    me->edoc_guid = iv_edoc_guid.
    o_edoc->data_init(
        xcontent = xcontent content = content edocflow = me->edocflow
        edoc_guid = edoc_guid filename = filename invoice = invoice
        parent_edoc_guid = parent_edoc_guid ) .

  ENDMETHOD.

  METHOD execute_action.
    o_edoc->execute_action(  iv_action ).
    edocument = o_edoc->edocument.
    edocumentfile = o_edoc->edocumentfile.
    buffer = o_edoc->buffer.
    edocument_t = o_edoc->edocument_t.
    edocumentfile_t = o_edoc->edocumentfile_t.
    buffer_t = o_edoc->buffer_t.
    pub_response = o_edoc->pub_response.
  ENDMETHOD.
ENDCLASS.
