CLASS zcl_zoe_edoc_unit_test DEFINITION
  PUBLIC
  INHERITING FROM zcl_zoe_edoc
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES: ty_worklog TYPE zedoc_db.
    TYPES: tt_worklog TYPE TABLE OF ty_worklog.
    METHODS constructor .

    METHODS prepare_test_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
    mt_worklog TYPE tt_worklog.

ENDCLASS.



CLASS zcl_zoe_edoc_unit_test IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ZOE_EDOC_UNIT_TEST->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.

    CALL METHOD super->constructor.


  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.


    prepare_test_data( ).

    " Verifica che tutti i record siano stati inseriti

  ENDMETHOD.

  METHOD prepare_test_data.
    " Prepara i dati di test
    DATA o_edoc TYPE REF TO zcl_zoe_edoc.

    o_edoc = NEW zcl_zoe_edoc( ).

*    CREATE OBJECT o_edoc
*      EXPORTING
*        unit_test = abap_true
*       filename  =
*       iv_edoc_guid =
*       iv_edocflow  = 'EDOC'
**         is_new       = ABAP_TRUE
**         iv_content   =
    .

  ENDMETHOD.
ENDCLASS.
