CLASS lhc_zr_edoc_out DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    DATA gt_data TYPE TABLE OF zmri_edoc_out.

    METHODS get_instance_features FOR INSTANCE FEATURES IMPORTING keys REQUEST requested_features FOR EdocFile RESULT result.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR EdocFile
        RESULT result.

    METHODS:
      get_global_feature FOR GLOBAL  FEATURES
        IMPORTING
        REQUEST global_feature FOR EdocFile
        RESULT result,
      zip_all FOR MODIFY
        IMPORTING keys FOR ACTION EdocFile~zip_all  ,

      document_download FOR MODIFY
        IMPORTING keys FOR ACTION EdocFile~document_download ,

      zip_downlaod FOR MODIFY
        IMPORTING keys FOR ACTION EdocFile~zip_downlaod .
ENDCLASS.

CLASS lhc_zr_edoc_out IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD get_instance_features.
  ENDMETHOD.
  METHOD get_global_feature.

  ENDMETHOD.
  METHOD document_download.
    READ ENTITIES OF zr_mri_edoc_out IN LOCAL MODE
               ENTITY EdocFile ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT DATA(entities)
               FAILED failed
               REPORTED reported.

   MOVE-CORRESPONDING entities TO gt_data.

  ENDMETHOD.
  METHOD zip_downlaod.

    READ ENTITIES OF zr_mri_edoc_out IN LOCAL MODE
               ENTITY EdocFile ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT DATA(entities)
               FAILED failed
               REPORTED reported.


  ENDMETHOD.

  METHOD zip_all.

    READ ENTITIES OF zr_mri_edoc_out IN LOCAL MODE
               ENTITY EdocFile ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT DATA(entities)
               FAILED failed
               REPORTED reported.
*
*    " Ora puoi lavorare con le entità selezionate che sono in 'entities'
    LOOP AT entities INTO DATA(entity).
      " ... logica per ogni entità ...
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
