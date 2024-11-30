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
    METHODS fake_xml_display_for_test
      RETURNING
        VALUE(e_content) TYPE zedoc_db-xdata.
    METHODS prepare_test_data.
    METHODS get_xstring RETURNING
                          VALUE(e_content) TYPE zedoc_db-xdata.
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
  METHOD get_xstring.


    DATA(lv_xml_content) = |<?xml version="1.0" encoding="UTF-8"?>| &&
|<?xml-stylesheet type="text/xsl" href="../../css/fatturaordinaria_v1.2.1.xsl"?>| &&
|<p:FatturaElettronica versione="FPR12" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:p="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2" | &&
|  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2 fatturaordinaria_v1.2.xsd">| &&
|  <FatturaElettronicaHeader>| &&
|    <DatiTrasmissione>| &&
|      <IdTrasmittente>| &&
|        <IdPaese>IT</IdPaese>| &&
|        <IdCodice>02480730221</IdCodice>| &&
|      </IdTrasmittente>| &&
|      <ProgressivoInvio>FIM00000FE</ProgressivoInvio>| &&
|      <FormatoTrasmissione>FPR12</FormatoTrasmissione>| &&
|      <CodiceDestinatario>0000000</CodiceDestinatario>| &&
|      <ContattiTrasmittente>| &&
|        <Email>info@codiceicona.com</Email>| &&
|      </ContattiTrasmittente>| &&
|    </DatiTrasmissione>| &&
|    <CedentePrestatore>| &&
|      <DatiAnagrafici>| &&
|        <IdFiscaleIVA>| &&
|          <IdPaese>IT</IdPaese>| &&
|          <IdCodice>02480730221</IdCodice>| &&
|        </IdFiscaleIVA>| &&
|        <Anagrafica>| &&
|          <Denominazione>CODICEICONA SOCIETA&apos; BENEFIT SRL - UNIPERSONALE</Denominazione>| &&
|        </Anagrafica>| &&
|        <RegimeFiscale>RF01</RegimeFiscale>| &&
|      </DatiAnagrafici>| &&
|      <Sede>| &&
|        <Indirizzo>VIA GIOVANNI VIRGINIO SCHIAPARELLI N. 7/B</Indirizzo>| &&
|        <CAP>37135</CAP>| &&
|        <Comune>VERONA</Comune>| &&
|        <Provincia>VR</Provincia>| &&
|        <Nazione>IT</Nazione>| &&
|      </Sede>| &&
|      <IscrizioneREA>| &&
|        <Ufficio>VR</Ufficio>| &&
|        <NumeroREA>398161</NumeroREA>| &&
|        <SocioUnico>SU</SocioUnico>| &&
|        <StatoLiquidazione>LN</StatoLiquidazione>| &&
|      </IscrizioneREA>| &&
|    </CedentePrestatore>| &&
|    <CessionarioCommittente>| &&
|      <DatiAnagrafici>| &&
|        <IdFiscaleIVA>| &&
|          <IdPaese>IT</IdPaese>| &&
|          <IdCodice>08791160966</IdCodice>| &&
|        </IdFiscaleIVA>| &&
|        <Anagrafica>| &&
|          <Denominazione>ARTEMEST S.R.L.</Denominazione>| &&
|        </Anagrafica>| &&
|      </DatiAnagrafici>| &&
|      <Sede>| &&
|        <Indirizzo>VIA SAVONA, 97 - LOFT C6</Indirizzo>| &&
|        <CAP>20144</CAP>| &&
|        <Comune>MILANO</Comune>| &&
|        <Provincia>MI</Provincia>| &&
|        <Nazione>IT</Nazione>| &&
|      </Sede>| &&
|    </CessionarioCommittente>| &&
|  </FatturaElettronicaHeader>| &&
|  <FatturaElettronicaBody>| &&
|    <DatiGenerali>| &&
|      <DatiGeneraliDocumento>| &&
|        <TipoDocumento>TD01</TipoDocumento>| &&
|        <Divisa>EUR</Divisa>| &&
|        <Data>2024-10-29</Data>| &&
|        <Numero>202400072</Numero>| &&
|        <ImportoTotaleDocumento>3609.98</ImportoTotaleDocumento>| &&
|      </DatiGeneraliDocumento>| &&
|      <DatiOrdineAcquisto>| &&
|        <RiferimentoNumeroLinea>1</RiferimentoNumeroLinea>| &&
|        <IdDocumento>#R890975488</IdDocumento>| &&
|        <Data>2024-10-21</Data>| &&
|      </DatiOrdineAcquisto>| &&
|    </DatiGenerali>| &&
|    <DatiBeniServizi>| &&
|      <DettaglioLinee>| &&
|        <NumeroLinea>1</NumeroLinea>| &&
|        <CodiceArticolo>| &&
|          <CodiceTipo>Fornitore</CodiceTipo>| &&
|          <CodiceValore>F0008A05CE</CodiceValore>| &&
|        </CodiceArticolo>| &&
|        <Descrizione>LUMINATOR di Luciano Baldessari, lampada da terra, tubo a spirale rosso</Descrizione>| &&
|        <Quantita>1.00</Quantita>| &&
|        <UnitaMisura>PZ</UnitaMisura>| &&
|        <PrezzoUnitario>2959.00000</PrezzoUnitario>| &&
|        <PrezzoTotale>2959.00</PrezzoTotale>| &&
|        <AliquotaIVA>22.00</AliquotaIVA>| &&
|      </DettaglioLinee>| &&
|      <DatiRiepilogo>| &&
|        <AliquotaIVA>22.00</AliquotaIVA>| &&
|        <ImponibileImporto>2959.00</ImponibileImporto>| &&
|        <Imposta>650.98</Imposta>| &&
|        <EsigibilitaIVA>I</EsigibilitaIVA>| &&
|      </DatiRiepilogo>| &&
|    </DatiBeniServizi>| &&
|    <DatiPagamento>| &&
|      <CondizioniPagamento>TP02</CondizioniPagamento>| &&
|      <DettaglioPagamento>| &&
|        <ModalitaPagamento>MP05</ModalitaPagamento>| &&
|        <DataScadenzaPagamento>2024-11-28</DataScadenzaPagamento>| &&
|        <ImportoPagamento>3609.98</ImportoPagamento>| &&
|        <IstitutoFinanziario>BANCA VALSABBINA SCpa</IstitutoFinanziario>| &&
|        <IBAN>IT95U0511611703000000003195</IBAN>| &&
|      </DettaglioPagamento>| &&
|    </DatiPagamento>| &&
|  </FatturaElettronicaBody>| &&
|</p:FatturaElettronica>|.

    CALL TRANSFORMATION id
             SOURCE XML lv_xml_content
             RESULT  XML e_content.

  ENDMETHOD.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ZOE_EDOC_UNIT_TEST->FAKE_XML_DISPLAY_FOR_TEST
* +-------------------------------------------------------------------------------------------------+
* | [<-()] E_CONTENT                      TYPE        RSRAWSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fake_xml_display_for_test.
    e_content = get_xstring( ).
  ENDMETHOD.


  METHOD prepare_test_data.
    " Prepara i dati di test
    DATA o_edoc TYPE REF TO zcl_zoe_edoc.

    CREATE OBJECT o_edoc
      EXPORTING
        unit_test = abap_true
*       filename  = filename
*       iv_edoc_guid = wa-unique_value
*       iv_edocflow  = 'EDOC'
**         is_new       = ABAP_TRUE
**         iv_content   = xdata
      .

    CHECK 1 = 2.

    TYPES: BEGIN OF ts_test_data,
             messaggio     TYPE string,
             exchange_data TYPE string,
           END OF ts_test_data.

    DATA: ls_datai   TYPE ts_test_data.

    DATA: ls_data   TYPE tt_worklog,
          ls_result TYPE tt_worklog.

    DATA xdata TYPE xstring.

    DATA: db TYPE TABLE OF zedoc_db.
    MOVE-CORRESPONDING mt_worklog TO db.


    DATA tgroups TYPE TABLE OF zedocgroup_db.
    DATA tflows TYPE TABLE OF zedoc_flow.

    tgroups = VALUE #(
    ( edocgroup = 'INBOUND' descr = 'Incoming Invoices'   )
    ( edocgroup = 'OUTBOUND' descr = 'OUTBOUND Invoices'   )
    ) .

    MODIFY zedocgroup_db FROM TABLE @tgroups.

    tflows = VALUE #(

    ( edocgroup = 'INBOUND' edocflow = 'EDOC'  edocflowdescr = 'EDOCUMENT INCOMING INVOICE' )
    ( edocgroup = 'INBOUND' edocflow = 'EDOC'  edocflowdescr = 'EDOCUMENT INCOMING FOREIGN INVOICE' )
    ).

    MODIFY zedoc_flow FROM TABLE @tflows.

    xdata = me->get_xstring(  ).

    DATA(unique_id1) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(unique_id2) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(unique_id3) = cl_system_uuid=>create_uuid_x16_static( ).

    " Fill test dataxdata = xdata
    mt_worklog = VALUE #(
     ( edocflow = 'EDOC' unique_value = unique_id1 filename = 'Test1.xml' xdata = xdata xmldata = xdata mimetypexml = 'application/xml' )
     ( edocflow = 'EDOC' unique_value = unique_id2 filename = 'Test2.xml' xdata = xdata xmldata = xdata mimetypexml = 'application/xml' )
     ( edocflow = 'EDOC' unique_value = unique_id3 filename = 'Test3.xml' xdata = xdata xmldata = xdata mimetypexml = 'application/xml' )
     ) .


**********************************************************************


    MOVE-CORRESPONDING mt_worklog TO db.
    DELETE FROM zedoc_db.
    MODIFY zedoc_db FROM TABLE @db.

*    LOOP AT mt_worklog INTO DATA(wa).
*
*
*      CREATE OBJECT o_edoc
*        EXPORTING
*          iv_edoc_guid = wa-unique_value
*          iv_edocflow  = 'EDOC'
**         is_new       = ABAP_TRUE
**         iv_content   = xdata
*        .
*      o_edoc->execute_action( 'DELETE' ).
*
*      FREE o_edoc.
*    ENDLOOP.


*    LOOP AT mt_worklog INTO DATA(wa_line).
*
*
*      CREATE OBJECT o_edoc
*        EXPORTING
**         iv_edoc_guid = wa-unique_value
*          iv_edocflow = 'EDOC'
**         is_new      = ABAP_TRUE
*          iv_content  = xdata.
*      o_edoc->execute_action( 'CREATE' ).
*
*      FREE o_edoc.
*    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
