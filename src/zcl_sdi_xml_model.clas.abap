CLASS zcl_sdi_xml_model DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_invoice_line,
        doc_number    TYPE string,
        doc_date      TYPE string,
        supplier_vat  TYPE string,
        supplier_name TYPE string,
        customer_vat  TYPE string,
        customer_name TYPE string,
        total_amount  TYPE string,
        line_number   TYPE string,
        description   TYPE string,
        quantity      TYPE string,
        unit_price    TYPE string,
        total_price   TYPE string,
        vat_rate      TYPE string,
      END OF ty_invoice_line .
    TYPES:
      tt_invoice_lines TYPE TABLE OF ty_invoice_line .
    TYPES:
      " Strutture per le tabelle annidate
      BEGIN OF ty_delivery_note,
        supplierinvoice     TYPE string,
        fiscalyear          TYPE string,
        inbounddeliverynote TYPE string,
      END OF ty_delivery_note .
    TYPES:
      tt_delivery_notes TYPE STANDARD TABLE OF ty_delivery_note WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_purchase_order,
        supplierinvoice   TYPE string,
        fiscalyear        TYPE string,
        purchaseorder     TYPE string,
        purchaseorderitem TYPE string,
      END OF ty_purchase_order .
    TYPES:
      tt_purchase_orders TYPE STANDARD TABLE OF ty_purchase_order WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_service_sheet,
        supplierinvoice       TYPE string,
        fiscalyear            TYPE string,
        serviceentrysheet     TYPE string,
        serviceentrysheetitem TYPE string,
      END OF ty_service_sheet .
    TYPES:
      tt_service_sheets TYPE STANDARD TABLE OF ty_service_sheet WITH DEFAULT KEY .
    TYPES:
      " Struttura per Invoice Item Asset
      BEGIN OF ty_item_asset,
        supplierinvoice            TYPE string,
        fiscalyear                 TYPE string,
        supplierinvoiceitem        TYPE string,
        companycode                TYPE string,
        masterfixedasset           TYPE string,
        fixedasset                 TYPE string,
        profitcenter               TYPE string,
        glaccount                  TYPE string,
        documentcurrency           TYPE string,
        supplierinvoiceitemamount  TYPE p LENGTH 15 DECIMALS 2,
        taxcode                    TYPE string,
        taxjurisdiction            TYPE string,
        taxcountry                 TYPE string,
        taxdeterminationdate       TYPE string,
        debitcreditcode            TYPE string,
        supplierinvoiceitemtext    TYPE string,
        assignmentreference        TYPE string,
        isnotcashdiscountliable    TYPE abap_bool,
        assetvaluedate             TYPE string,
        quantityunit               TYPE string,
        suplrinvcitmqtyunitsapcode TYPE string,
        suplrinvcitmqtyunitisocode TYPE string,
        quantity                   TYPE string,
      END OF ty_item_asset .
    TYPES:
      tt_item_assets TYPE STANDARD TABLE OF ty_item_asset WITH DEFAULT KEY .
    TYPES:
      " Struttura per Material Items
      BEGIN OF ty_item_material,
        supplierinvoice            TYPE string,
        fiscalyear                 TYPE string,
        supplierinvoiceitem        TYPE string,
        material                   TYPE string,
        valuationarea              TYPE string,
        companycode                TYPE string,
        plant                      TYPE string,
        inventoryvaluationtype     TYPE string,
        taxcode                    TYPE string,
        taxjurisdiction            TYPE string,
        taxcountry                 TYPE string,
        taxdeterminationdate       TYPE string,
        documentcurrency           TYPE string,
        supplierinvoiceitemamount  TYPE p LENGTH 15 DECIMALS 2,
        quantityunit               TYPE string,
        suplrinvcitmqtyunitsapcode TYPE string,
        suplrinvcitmqtyunitisocode TYPE string,
        quantity                   TYPE string,
        debitcreditcode            TYPE string,
        isnotcashdiscountliable    TYPE abap_bool,
      END OF ty_item_material .
    TYPES:
      tt_item_materials TYPE STANDARD TABLE OF ty_item_material WITH DEFAULT KEY .
    TYPES:
      " Struttura per Account Assignment
      BEGIN OF ty_account_assignment,
        supplierinvoice               TYPE string,
        fiscalyear                    TYPE string,
        supplierinvoiceitem           TYPE string,
        ordinalnumber                 TYPE string,
        costcenter                    TYPE string,
        controllingarea               TYPE string,
        businessarea                  TYPE string,
        profitcenter                  TYPE string,
        functionalarea                TYPE string,
        glaccount                     TYPE string,
        salesorder                    TYPE string,
        salesorderitem                TYPE string,
        costobject                    TYPE p LENGTH 15 DECIMALS 2,
        costctractivitytype           TYPE string,
        businessprocess               TYPE string,
        wbselement                    TYPE string,
        documentcurrency              TYPE string,
        suplrinvcacctassignmentamount TYPE p LENGTH 15 DECIMALS 2,
        accountassignmentisunplanned  TYPE abap_bool,
        taxcode                       TYPE string,
        taxjurisdiction               TYPE string,
        taxcountry                    TYPE string,
        taxdeterminationdate          TYPE string,
      END OF ty_account_assignment .
    TYPES:
      tt_account_assignments TYPE STANDARD TABLE OF ty_account_assignment WITH DEFAULT KEY .
    TYPES:
      " Struttura per Purchase Order Reference
      BEGIN OF ty_pur_ord_ref,
        supplierinvoice              TYPE string,
        fiscalyear                   TYPE string,
        supplierinvoiceitem          TYPE string,
        purchaseorder                TYPE string,
        purchaseorderitem            TYPE string,
        plant                        TYPE string,
        taxcode                      TYPE string,
        documentcurrency             TYPE string,
        supplierinvoiceitemamount    TYPE p LENGTH 15 DECIMALS 2,
        supplierinvoiceitemtext      TYPE string,
        isnotcashdiscountliable      TYPE abap_bool,
        retentionamountindoccurrency TYPE p LENGTH 15 DECIMALS 2,
        isfinallyinvoiced            TYPE abap_bool,
        to_supplinvitmacctassgmt     TYPE tt_account_assignments,
      END OF ty_pur_ord_ref .
    TYPES:
      tt_pur_ord_refs TYPE STANDARD TABLE OF ty_pur_ord_ref WITH DEFAULT KEY .
    TYPES:
      " Struttura per Additional Data
      BEGIN OF ty_additional_data,
        supplierinvoice                TYPE string,
        fiscalyear                     TYPE string,
        invoicingpartyname1            TYPE string,
        invoicingpartyname2            TYPE string,
        invoicingpartyname3            TYPE string,
        invoicingpartyname4            TYPE string,
        postalcode                     TYPE string,
        cityname                       TYPE string,
        country                        TYPE string,
        onetmeaccountisvatliable       TYPE abap_bool,
        isonetimeaccount               TYPE abap_bool,
        isnaturalperson                TYPE abap_bool,
        onetmeacctisequalizationtxsubj TYPE abap_bool,
      END OF ty_additional_data .
    TYPES:
      " Struttura per Tax Data
      BEGIN OF ty_invoice_tax,
        supplierinvoice           TYPE string,
        fiscalyear                TYPE string,
        taxcode                   TYPE string,
        supplierinvoicetaxcounter TYPE string,
        documentcurrency          TYPE string,
        taxamount                 TYPE p LENGTH 15 DECIMALS 2,
        taxbaseamountintranscrcy  TYPE p LENGTH 15 DECIMALS 2,
        taxjurisdiction           TYPE string,
        taxcountry                TYPE string,
        taxdeterminationdate      TYPE string,
        taxratevaliditystartdate  TYPE string,
      END OF ty_invoice_tax .
    TYPES:
      tt_invoice_taxes TYPE STANDARD TABLE OF ty_invoice_tax WITH DEFAULT KEY .
    TYPES:
      " Struttura per Selected Delivery Notes
      " Tabella per results di Delivery Notes
      BEGIN OF ty_delivery_notes_wrapper,
        results TYPE STANDARD TABLE OF ty_delivery_note WITH DEFAULT KEY,
      END OF ty_delivery_notes_wrapper .
    TYPES:
      BEGIN OF ty_purchase_orders_wrapper,
        results TYPE STANDARD TABLE OF ty_purchase_order WITH DEFAULT KEY,
      END OF ty_purchase_orders_wrapper .
    TYPES:
      BEGIN OF ty_asset_wrapper,
        results TYPE STANDARD TABLE OF ty_item_asset WITH DEFAULT KEY,
      END OF ty_asset_wrapper .
    TYPES:
*      BEGIN OF ty_delivery_notes_wrapper,
*        results TYPE STANDARD TABLE OF ty_delivery_note WITH DEFAULT KEY,
*      END OF ty_delivery_notes_wrapper,
*      BEGIN OF ty_purchase_orders_wrapper,
*        results TYPE STANDARD TABLE OF ty_purchase_order WITH DEFAULT KEY,
*      END OF ty_purchase_orders_wrapper,
      BEGIN OF ty_service_sheets_wrapper,
        results TYPE STANDARD TABLE OF ty_service_sheet WITH DEFAULT KEY,
      END OF ty_service_sheets_wrapper .
    TYPES:
      BEGIN OF ty_item_asset_wrapper,
        results TYPE STANDARD TABLE OF ty_item_asset WITH DEFAULT KEY,
      END OF ty_item_asset_wrapper .
    TYPES:
      BEGIN OF ty_item_material_wrapper,
        results TYPE STANDARD TABLE OF ty_item_material WITH DEFAULT KEY,
      END OF ty_item_material_wrapper .
    TYPES:
      BEGIN OF ty_pur_ord_ref_wrapper,
        results TYPE STANDARD TABLE OF ty_pur_ord_ref WITH DEFAULT KEY,
      END OF ty_pur_ord_ref_wrapper .
    TYPES:
      BEGIN OF ty_gl_acct_wrapper,
        results TYPE STANDARD TABLE OF ty_account_assignment WITH DEFAULT KEY,
      END OF ty_gl_acct_wrapper .
    TYPES:
      BEGIN OF ty_invoice_tax_wrapper,
        results TYPE STANDARD TABLE OF ty_invoice_tax WITH DEFAULT KEY,
      END OF ty_invoice_tax_wrapper .
    TYPES:
      " Struttura principale
      BEGIN OF ty_supplier_invoice_deep,   supplierinvoice                TYPE string,
        fiscalyear                     TYPE string,
        companycode                    TYPE string,
        documentdate                   TYPE string,
        postingdate                    TYPE string,
        creationdate                   TYPE string,
        suplrinvclstchgdtetmetxt       TYPE string,
        supplierinvoiceidbyinvcgparty  TYPE string,
        invoicingparty                 TYPE string,
        documentcurrency               TYPE string,
        invoicegrossamount             TYPE p LENGTH 15 DECIMALS 2,
        unplanneddeliverycost          TYPE string,
        documentheadertext             TYPE string,
        manualcashdiscount             TYPE string,
        paymentterms                   TYPE string,
        duecalculationbasedate         TYPE string,
        cashdiscount1percent           TYPE string,
        cashdiscount1days              TYPE string,
        cashdiscount2percent           TYPE string,
        cashdiscount2days              TYPE string,
        netpaymentdays                 TYPE string,
        paymentblockingreason          TYPE string,
        accountingdocumenttype         TYPE string,
        bpbankaccountinternalid        TYPE string,
        supplierinvoicestatus          TYPE string,
        indirectquotedexchangerate     TYPE string,
        directquotedexchangerate       TYPE string,
        statecentralbankpaymentreason  TYPE string,
        supplyingcountry               TYPE string,
        paymentmethod                  TYPE string,
        paymentmethodsupplement        TYPE string,
        paymentreference               TYPE string,
        invoicereference               TYPE string,
        invoicereferencefiscalyear     TYPE string,
        fixedcashdiscount              TYPE string,
        unplanneddeliverycosttaxcode   TYPE string,
        unplnddelivcosttaxjurisdiction TYPE string,
        unplnddeliverycosttaxcountry   TYPE string,
        assignmentreference            TYPE string,
        supplierpostinglineitemtext    TYPE string,
        taxiscalculatedautomatically   TYPE abap_bool,
        businessplace                  TYPE string,
        businesssectioncode            TYPE string,
        businessarea                   TYPE string,
        suplrinvciscapitalgoodsrelated TYPE abap_bool,
        supplierinvoiceiscreditmemo    TYPE string,
        paytslipwthrefsubscriber       TYPE string,
        paytslipwthrefcheckdigit       TYPE string,
        paytslipwthrefreference        TYPE string,
        taxdeterminationdate           TYPE string,
        taxreportingdate               TYPE string,
        taxfulfillmentdate             TYPE string,
        invoicereceiptdate             TYPE string,
        deliveryofgoodsreportingcntry  TYPE string,
        suppliervatregistration        TYPE string,
        iseutriangulardeal             TYPE abap_bool,
        suplrinvcdebitcrdtcodedelivery TYPE string,
        suplrinvcdebitcrdtcodereturns  TYPE string,
        retentionduedate               TYPE string,
        paymentreason                  TYPE string,
        housebank                      TYPE string,
        housebankaccount               TYPE string,
        alternativepayeepayer          TYPE string,
        supplierinvoiceorigin          TYPE string,
        reversedocument                TYPE string,
        reversedocumentfiscalyear      TYPE string,
        isreversal                     TYPE abap_bool,
        isreversed                     TYPE abap_bool,
        in_gstpartner                  TYPE string,
        in_gstplaceofsupply            TYPE string,
        in_invoicereferencenumber      TYPE string,
        jrnlentrycntryspecificref1     TYPE string,
        jrnlentrycntryspecificdate1    TYPE string,
        jrnlentrycntryspecificref2     TYPE string,
        jrnlentrycntryspecificdate2    TYPE string,
        jrnlentrycntryspecificref3     TYPE string,
        jrnlentrycntryspecificdate3    TYPE string,
        jrnlentrycntryspecificref4     TYPE string,
        jrnlentrycntryspecificdate4    TYPE string,
        jrnlentrycntryspecificref5     TYPE string,
        jrnlentrycntryspecificdate5    TYPE string,
        jrnlentrycntryspecificbp1      TYPE string,
        jrnlentrycntryspecificbp2      TYPE string,
        to_selecteddeliverynotes       TYPE ty_delivery_notes_wrapper,
        to_selectedpurchaseorders      TYPE ty_purchase_orders_wrapper,
*        to_suplrinvcitemasset          TYPE ty_asset_wrapper,
        to_selectedserviceentrysheets  TYPE ty_service_sheets_wrapper,
        to_suplrinvcitemasset          TYPE ty_item_asset_wrapper,
        to_suplrinvcitemmaterial       TYPE ty_item_material_wrapper,
        to_suplrinvcitempurordref      TYPE ty_pur_ord_ref_wrapper,
        to_supplrinvoiceitemglacct     TYPE ty_gl_acct_wrapper,
        to_suplrinvoiceadditionaldata  TYPE ty_additional_data,     "questo non ha results
        to_supplrinvoicetax            TYPE ty_invoice_tax_wrapper,
*    to_additionaldata  type ty_additionaldata_wrapper,
      END OF ty_supplier_invoice_deep .
    TYPES:
      " Struttura root
      BEGIN OF ty_root,
        d TYPE ty_supplier_invoice_deep,
      END OF ty_root .
    TYPES:
      BEGIN OF ty_testata,
        id_paese                  TYPE string,
        id_codice                 TYPE string,
        progressivo_invio         TYPE string,
        formato_trasmissione      TYPE string,
        codice_destinatario       TYPE string,
        email                     TYPE string,
        cedente_denominazione     TYPE string,
        cedente_indirizzo         TYPE string,
        cedente_cap               TYPE string,
        cedente_comune            TYPE string,
        cedente_provincia         TYPE string,
        cedente_nazione           TYPE string,
        cessionario_denominazione TYPE string,
        cessionario_indirizzo     TYPE string,
        cessionario_cap           TYPE string,
        cessionario_comune        TYPE string,
        cessionario_provincia     TYPE string,
        cessionario_nazione       TYPE string,
        data_fattura              TYPE string,
        importototaledocumento    TYPE string,

      END OF ty_testata .
    TYPES:
      BEGIN OF ty_posizione,
        numero_linea    TYPE string,
        codice_tipo     TYPE string,
        codice_valore   TYPE string,
        descrizione     TYPE string,
        quantita        TYPE string,
        unita_misura    TYPE string,
        prezzo_unitario TYPE string,
        prezzo_totale   TYPE string,
        aliquota_iva    TYPE string,
      END OF ty_posizione .
    TYPES:
      BEGIN OF ty_allegati,
        nome_attachment        TYPE string,
        formato_attachment     TYPE string,
        descrizione_attachment TYPE string,
        attachment             TYPE string,
      END OF ty_allegati .
    TYPES:
      BEGIN OF ty_riepilogo,
        aliquota_iva       TYPE string,
        imponibile_importo TYPE string,
        imposta            TYPE string,
        esigibilita_iva    TYPE string,
      END OF ty_riepilogo .
    TYPES:
      "Definizione tipi
      BEGIN OF ts_fattura,
        testata   TYPE ty_testata,
        posizioni TYPE TABLE OF ty_posizione WITH EMPTY KEY,
        allegati  TYPE TABLE OF ty_allegati WITH EMPTY KEY,
        riepilogo TYPE TABLE OF ty_riepilogo WITH EMPTY KEY,
      END OF ts_fattura .

    METHODS transform_xml_to_api_json
      IMPORTING
        !iv_xml        TYPE string
      RETURNING
        VALUE(ev_json) TYPE string .
    METHODS get_xml
      RETURNING
        VALUE(ev_zip) TYPE xstring .
    METHODS get_encoded_xml
      IMPORTING
        !xresult      TYPE any
      RETURNING
        VALUE(output) TYPE xstring .
    METHODS parse_xml
      IMPORTING
        !xresult      TYPE any
      RETURNING
        VALUE(output) TYPE string .
    METHODS get_allegato
      EXPORTING
        !allegato TYPE ty_allegati .
    METHODS get_testata
      EXPORTING
        !testata TYPE ty_testata .
    METHODS    get_xml_header
      RETURNING VALUE(xml_header) TYPE zoe_xml_data_extract  .
    METHODS from_zip_to_xml
      IMPORTING
        !i_filename          TYPE string
        !i_zip               TYPE xstring
      RETURNING
        VALUE(lv_xml_string) TYPE string .
    METHODS from_xml_to_zip
      IMPORTING
        !lv_xml_string  TYPE string
      EXPORTING
        !e_filename_pdf TYPE string
        !e_filename_xml TYPE string
        !e_filename_zip TYPE string
        !e_zip          TYPE xstring
        !e_pdf          TYPE xstring.
    METHODS get_content_dummy RETURNING VALUE(e_content) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA o_model TYPE REF TO zcl_sdi_xml_model.
    DATA ls_testata TYPE ty_testata .
    DATA xml_header TYPE zoe_xml_data_extract.
    DATA ls_allegato TYPE ty_allegati .
    DATA ls_root TYPE ty_root .
    DATA lt_invoice_lines TYPE tt_invoice_lines .
ENDCLASS.



CLASS zcl_sdi_xml_model IMPLEMENTATION.
  METHOD get_content_dummy.
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
    |      <DettaglioLinee>| &&
    |        <NumeroLinea>2</NumeroLinea>| &&
    |        <Descrizione>********************************************************************| &&
    |VS. CONFERMA ORDINE #R890975488| &&
    |********************************************************************</Descrizione>| &&
    |        <Quantita>0.00</Quantita>| &&
    |        <PrezzoUnitario>0.000</PrezzoUnitario>| &&
    |        <PrezzoTotale>0.00</PrezzoTotale>| &&
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
    |    <Allegati>| &&
    |      <NomeAttachment>FATTIMM72.PDF</NomeAttachment>| &&
    |      <FormatoAttachment>PDF</FormatoAttachment>| &&
    |      <DescrizioneAttachment>Fattura in formato PDF</DescrizioneAttachment>| &&
    |      <Attachment> | &&
    |  JVBERi0xLjQKJeLjz9MKMSAwIG9iajw8L1Byb2R1Y2VyKGh0bWxkb2MgMS45LjIgQ29weXJp | &&
|  Z2h0IDIwMTEtMjAxNyBieSBNaWNoYWVsIFIgU3dlZXQpL0NyZWF0aW9uRGF0ZShEOjIwMjQx | &&
|  MTA4MDkxNDQ1KzAwMDApPj5lbmRvYmoKMiAwIG9iajw8L1R5cGUvRW5jb2RpbmcvRGlmZmVy | &&
|  ZW5jZXNbIDMyL3NwYWNlL2V4Y2xhbS9xdW90ZWRibC9udW1iZXJzaWduL2RvbGxhci9wZXJj | &&
|  ZW50L2FtcGVyc2FuZC9xdW90ZXNpbmdsZS9wYXJlbmxlZnQvcGFyZW5yaWdodC9hc3Rlcmlz | &&
|  ay9wbHVzL2NvbW1hL2h5cGhlbi9wZXJpb2Qvc2xhc2gvemVyby9vbmUvdHdvL3RocmVlL2Zv | &&
|  dXIvZml2ZS9zaXgvc2V2ZW4vZWlnaHQvbmluZS9jb2xvbi9zZW1pY29sb24vbGVzcy9lcXVh | &&
|  bC9ncmVhdGVyL3F1ZXN0aW9uL2F0L0EvQi9DL0QvRS9GL0cvSC9JL0ovSy9ML00vTi9PL1Av | &&
|  US9SL1MvVC9VL1YvVy9YL1kvWi9icmFja2V0bGVmdC9iYWNrc2xhc2gvYnJhY2tldHJpZ2h0 | &&
|  L2FzY2lpY2lyY3VtL3VuZGVyc2NvcmUvZ3JhdmUvYS9iL2MvZC9lL2YvZy9oL2kvai9rL2wv | &&
|  bS9uL28vcC9xL3Ivcy90L3Uvdi93L3gveS96L2JyYWNlbGVmdC9iYXIvYnJhY2VyaWdodC9h | &&
|  c2NpaXRpbGRlIDE2MC9zcGFjZS9leGNsYW1kb3duL2NlbnQvc3RlcmxpbmcvY3VycmVuY3kv | &&
|  eWVuL2Jyb2tlbmJhci9zZWN0aW9uL2RpZXJlc2lzL2NvcHlyaWdodC9vcmRmZW1pbmluZS9n | &&
|  dWlsbGVtb3RsZWZ0L2xvZ2ljYWxub3QvbWludXMvcmVnaXN0ZXJlZC9tYWNyb24vZGVncmVl | &&
|  L3BsdXNtaW51cy90d29zdXBlcmlvci90aHJlZXN1cGVyaW9yL2FjdXRlL211L3BhcmFncmFw | &&
|  aC9wZXJpb2RjZW50ZXJlZC9jZWRpbGxhL29uZXN1cGVyaW9yL29yZG1hc2N1bGluZS9ndWls | &&
|  bGVtb3RyaWdodC9vbmVxdWFydGVyL29uZWhhbGYvdGhyZWVxdWFydGVycy9xdWVzdGlvbmRv | &&
|  d24vQWdyYXZlL0FhY3V0ZS9BY2lyY3VtZmxleC9BdGlsZGUvQWRpZXJlc2lzL0FyaW5nL0FF | &&
|  L0NjZWRpbGxhL0VncmF2ZS9FYWN1dGUvRWNpcmN1bWZsZXgvRWRpZXJlc2lzL0lncmF2ZS9J | &&
|  YWN1dGUvSWNpcmN1bWZsZXgvSWRpZXJlc2lzL0V0aC9OdGlsZGUvT2dyYXZlL09hY3V0ZS9P | &&
|  Y2lyY3VtZmxleC9PdGlsZGUvT2RpZXJlc2lzL211bHRpcGx5L09zbGFzaC9VZ3JhdmUvVWFj | &&
|  dXRlL1VjaXJjdW1mbGV4L1VkaWVyZXNpcy9ZYWN1dGUvVGhvcm4vZ2VybWFuZGJscy9hZ3Jh | &&
|  dmUvYWFjdXRlL2FjaXJjdW1mbGV4L2F0aWxkZS9hZGllcmVzaXMvYXJpbmcvYWUvY2NlZGls | &&
|  bGEvZWdyYXZlL2VhY3V0ZS9lY2lyY3VtZmxleC9lZGllcmVzaXMvaWdyYXZlL2lhY3V0ZS9p | &&
|  Y2lyY3VtZmxleC9pZGllcmVzaXMvZXRoL250aWxkZS9vZ3JhdmUvb2FjdXRlL29jaXJjdW1m | &&
|  bGV4L290aWxkZS9vZGllcmVzaXMvZGl2aWRlL29zbGFzaC91Z3JhdmUvdWFjdXRlL3VjaXJj | &&
|  dW1mbGV4L3VkaWVyZXNpcy95YWN1dGUvdGhvcm4veWRpZXJlc2lzXT4+ZW5kb2JqCjMgMCBv | &&
|  Ymo8PC9UeXBlL0ZvbnQvU3VidHlwZS9UeXBlMS9CYXNlRm9udC9Db3VyaWVyL0VuY29kaW5n | &&
|  IDIgMCBSPj5lbmRvYmoKNCAwIG9iajw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUxL0Jhc2VG | &&
|  b250L0hlbHZldGljYS9FbmNvZGluZyAyIDAgUj4+ZW5kb2JqCjUgMCBvYmo8PC9UeXBlL0Zv | &&
|  bnQvU3VidHlwZS9UeXBlMS9CYXNlRm9udC9IZWx2ZXRpY2EtQm9sZC9FbmNvZGluZyAyIDAg | &&
|  Uj4+ZW5kb2JqCjYgMCBvYmo8PC9EZXN0cyA3IDAgUj4+ZW5kb2JqCjcgMCBvYmo8PC9LaWRz | &&
|  WzggMCBSXT4+ZW5kb2JqCjggMCBvYmo8PC9MaW1pdHNbKG1vZHVsb19iYXNlLmFzcCkobW9k | &&
|  dWxvX2Jhc2UuYXNwKV0vTmFtZXNbKG1vZHVsb19iYXNlLmFzcCk5IDAgUl0+PmVuZG9iago5 | &&
|  IDAgb2JqPDwvRFsxMSAwIFIvWFlaIDAgODI0IDBdPj5lbmRvYmoKMTAgMCBvYmo8PC9UeXBl | &&
|  L1BhZ2VzL0NvdW50IDEvS2lkc1sxMSAwIFIKXT4+ZW5kb2JqCjExIDAgb2JqPDwvVHlwZS9Q | &&
|  YWdlL1BhcmVudCAxMCAwIFIvQ29udGVudHMgMTIgMCBSL01lZGlhQm94WzAgMCA1OTUgODQy | &&
|  XS9SZXNvdXJjZXM8PC9Qcm9jU2V0Wy9QREYvVGV4dF0vRm9udDw8L0YwIDMgMCBSL0Y4IDQg | &&
|  MCBSL0Y5IDUgMCBSPj4vWE9iamVjdDw8Pj4+Pi9EdXIgMTAvVHJhbnM8PC9UeXBlL1RyYW5z | &&
|  L0QgMS4wL1MvRGlzc29sdmU+Pj4+ZW5kb2JqCjEyIDAgb2JqPDwvTGVuZ3RoIDU4OTYgICAg | &&
|  ICA+PnN0cmVhbQpxCjEgMCAwIDEgMTggMTggY20KMS4wMCAwLjY1IDAuMDAgcmcgMC4wIDI5 | &&
|  Mi4wIDU1OS4wIDkuNSByZSBmCjEuMDAgMS4wMCAxLjAwIHJnIC0wLjAgMzM5LjEgNTU5LjAg | &&
|  NDcuOCByZSBmCjAuMDAgMC4wMCAwLjAwIHJnIDAuMCA3MDcuNSAxMDIuMSAwLjggcmUgZgow | &&
|  LjAgNjg2LjAgMC44IDIyLjQgcmUgZgoxMDEuMyA2ODYuMCAwLjggMjIuNCByZSBmCjAuMCA2 | &&
|  ODYuMCAxMDIuMSAwLjggcmUgZgoxMDEuMyA3MDcuNSA3Ni44IDAuOCByZSBmCjEwMS4zIDY4 | &&
|  Ni4wIDAuOCAyMi40IHJlIGYKMTc3LjMgNjg2LjAgMC44IDIyLjQgcmUgZgoxMDEuMyA2ODYu | &&
|  MCA3Ni44IDAuOCByZSBmCjE3Ny4zIDcwNy41IDc1LjEgMC44IHJlIGYKMTc3LjMgNjg2LjAg | &&
|  MC44IDIyLjQgcmUgZgoyNTEuNiA2ODYuMCAwLjggMjIuNCByZSBmCjE3Ny4zIDY4Ni4wIDc1 | &&
|  LjEgMC44IHJlIGYKMC4wIDY4Ni4wIDYxLjcgMC44IHJlIGYKMC4wIDY1Ny40IDAuOCAyOS40 | &&
|  IHJlIGYKNjAuOCA2NTcuNCAwLjggMjkuNCByZSBmCjAuMCA2NTcuNCA2MS43IDAuOCByZSBm | &&
|  CjYwLjggNjg2LjAgMTMzLjUgMC44IHJlIGYKNjAuOCA2NTcuNCAwLjggMjkuNCByZSBmCjE5 | &&
|  My41IDY1Ny40IDAuOCAyOS40IHJlIGYKNjAuOCA2NTcuNCAxMzMuNSAwLjggcmUgZgoxOTMu | &&
|  NSA2ODYuMCA1OC45IDAuOCByZSBmCjE5My41IDY1Ny40IDAuOCAyOS40IHJlIGYKMjUxLjYg | &&
|  NjU3LjQgMC44IDI5LjQgcmUgZgoxOTMuNSA2NTcuNCA1OC45IDAuOCByZSBmCjEuMDAgMC42 | &&
|  NSAwLjAwIHJnIDI2OC4zIDczNi4yIDI5MS41IDcwLjIgcmUgZgowLjAwIDAuMDAgMC4wMCBy | &&
|  ZyAyNjguMyA4MDUuNiAyOTEuNSAwLjggcmUgZgoyNjguMyA3MzYuMiAwLjggNzAuMiByZSBm | &&
|  CjU1OS4wIDczNi4yIDAuOCA3MC4yIHJlIGYKMjY4LjMgNzM2LjIgMjkxLjUgMC44IHJlIGYK | &&
|  MS4wMCAwLjk4IDAuOTggcmcgMjY4LjMgNjU3LjggMjkxLjUgNzkuMyByZSBmCjAuMDAgMC4w | &&
|  MCAwLjAwIHJnIDI2OC4zIDczNi4yIDI5MS41IDAuOCByZSBmCjI2OC4zIDY1Ny44IDAuOCA3 | &&
|  OS4zIHJlIGYKNTU5LjAgNjU3LjggMC44IDc5LjMgcmUgZgoyNjguMyA2NTcuOCAyOTEuNSAw | &&
|  LjggcmUgZgoxLjAwIDAuNjUgMC4wMCByZyAwLjggNjM2LjQgNDUuMiAxMS4yIHJlIGYKNDYu | &&
|  MCA2MzYuNCAzNzMuNyAxMS4yIHJlIGYKNDE5LjcgNjM2LjQgMTcuNCAxMS4yIHJlIGYKNDM3 | &&
|  LjEgNjM2LjQgMjAuNSAxMS4yIHJlIGYKNDU3LjYgNjM2LjQgMzUuNSAxMS4yIHJlIGYKNDkz | &&
|  LjEgNjM2LjQgMzEuMyAxMS4yIHJlIGYKNTI0LjQgNjM2LjQgMzMuOCAxMS4yIHJlIGYKMS4w | &&
|  MCAxLjAwIDEuMDAgcmcgMC44IDYxNC4wIDQ1LjIgMTEuMiByZSBmCjQ2LjAgNjE0LjAgMzcz | &&
|  LjcgMTEuMiByZSBmCjQxOS43IDYxNC4wIDE3LjQgMTEuMiByZSBmCjQzNy4xIDYxNC4wIDIw | &&
|  LjUgMTEuMiByZSBmCjQ1Ny42IDYxNC4wIDM1LjUgMTEuMiByZSBmCjQ5My4xIDYxNC4wIDMx | &&
|  LjMgMTEuMiByZSBmCjUyNC40IDYxNC4wIDMzLjggMTEuMiByZSBmCjAuMDAgMC4wMCAwLjAw | &&
|  IHJnIDAuMCA2NDguNCA1NTkuOCAwLjggcmUgZgowLjAgMzg2LjkgMC44IDI2Mi4zIHJlIGYK | &&
|  NTU5LjAgMzg2LjkgMC44IDI2Mi4zIHJlIGYKMC4wIDM4Ni45IDU1OS44IDAuOCByZSBmCi0w | &&
|  LjAgMzg2LjkgMzA2LjUgMC44IHJlIGYKLTAuMCAzMzkuMSAwLjggNDguNiByZSBmCjMwNS43 | &&
|  IDMzOS4xIDAuOCA0OC42IHJlIGYKLTAuMCAzMzkuMSAzMDYuNSAwLjggcmUgZgozMDUuNyAz | &&
|  ODYuOSAxOTUuMiAwLjggcmUgZgozMDUuNyAzMzkuMSAwLjggNDguNiByZSBmCjUwMC4xIDMz | &&
|  OS4xIDAuOCA0OC42IHJlIGYKMzA1LjcgMzM5LjEgMTk1LjIgMC44IHJlIGYKNTAwLjEgMzg2 | &&
|  LjkgNTkuNyAwLjggcmUgZgo1MDAuMSAzMzkuMSAwLjggNDguNiByZSBmCjU1OS4wIDMzOS4x | &&
|  IDAuOCA0OC42IHJlIGYKNTAwLjEgMzM5LjEgNTkuNyAwLjggcmUgZgowLjAgMzM5LjEgMTk2 | &&
|  LjUgMC44IHJlIGYKMC4wIDMxMC41IDAuOCAyOS40IHJlIGYKMTk1LjYgMzEwLjUgMC44IDI5 | &&
|  LjQgcmUgZgowLjAgMzEwLjUgMTk2LjUgMC44IHJlIGYKMTk1LjYgMzM5LjEgMzA4LjMgMC44 | &&
|  IHJlIGYKMTk1LjYgMzEwLjUgMC44IDI5LjQgcmUgZgo1MDMuMSAzMTAuNSAwLjggMjkuNCBy | &&
|  ZSBmCjE5NS42IDMxMC41IDMwOC4zIDAuOCByZSBmCjUwMy4xIDMzOS4xIDU2LjcgMC44IHJl | &&
|  IGYKNTAzLjEgMzEwLjUgMC44IDI5LjQgcmUgZgo1NTkuMCAzMTAuNSAwLjggMjkuNCByZSBm | &&
|  CjUwMy4xIDMxMC41IDU2LjcgMC44IHJlIGYKMC4wIDMwMS41IDU1OS44IDAuOCByZSBmCjAu | &&
|  MCAyOTIuMCAwLjggMTAuNCByZSBmCjU1OS4wIDI5Mi4wIDAuOCAxMC40IHJlIGYKMC4wIDI5 | &&
|  Mi4wIDU1OS44IDAuOCByZSBmCjAuMCAyOTIuMCAxNTQuMiAwLjggcmUgZgowLjAgMjgyLjQg | &&
|  MC44IDEwLjQgcmUgZgoxNTMuNCAyODIuNCAwLjggMTAuNCByZSBmCjAuMCAyODIuNCAxNTQu | &&
|  MiAwLjggcmUgZgoxNTMuNCAyOTIuMCAxOTQuNyAwLjggcmUgZgoxNTMuNCAyODIuNCAwLjgg | &&
|  MTAuNCByZSBmCjM0Ny4yIDI4Mi40IDAuOCAxMC40IHJlIGYKMTUzLjQgMjgyLjQgMTk0Ljcg | &&
|  MC44IHJlIGYKMzQ3LjIgMjkyLjAgMjEyLjYgMC44IHJlIGYKMzQ3LjIgMjgyLjQgMC44IDEw | &&
|  LjQgcmUgZgo1NTkuMCAyODIuNCAwLjggMTAuNCByZSBmCjM0Ny4yIDI4Mi40IDIxMi42IDAu | &&
|  OCByZSBmCjAuMCAyODIuNCAxNTQuMiAwLjggcmUgZgowLjAgMjcyLjkgMC44IDEwLjQgcmUg | &&
|  ZgoxNTMuNCAyNzIuOSAwLjggMTAuNCByZSBmCjAuMCAyNzIuOSAxNTQuMiAwLjggcmUgZgox | &&
|  NTMuNCAyODIuNCAxOTQuNyAwLjggcmUgZgoxNTMuNCAyNzIuOSAwLjggMTAuNCByZSBmCjM0 | &&
|  Ny4yIDI3Mi45IDAuOCAxMC40IHJlIGYKMTUzLjQgMjcyLjkgMTk0LjcgMC44IHJlIGYKMzQ3 | &&
|  LjIgMjgyLjQgMjEyLjYgMC44IHJlIGYKMzQ3LjIgMjcyLjkgMC44IDEwLjQgcmUgZgo1NTku | &&
|  MCAyNzIuOSAwLjggMTAuNCByZSBmCjM0Ny4yIDI3Mi45IDIxMi42IDAuOCByZSBmCkJUCi9G | &&
|  OSA2LjMgVGYgMS42NDQgNzk0LjgxOCBUZCAwLjAwMCBUYyhDT0RJQ0VJQ09OQSBTT0NJRVRB | &&
|  JyBCRU5FRklUIFNSTCAtIFVOSVBFUlNPTkFMRSlUagovRjggNi4zIFRmIC0wIC0xMi44MjYg | &&
|  VGQoVklBIEdJT1ZBTk5JIFZJUkdJTklPIFNDSElBUEFSRUxMSSBOLiA3L0IpVGoKMCAtOS41 | &&
|  MzggVGQoMzcxMzUpVGoKMS4wMCAxLjAwIDEuMDAgcmcgKC4pVGoKMC4wMCAwLjAwIDAuMDAg | &&
|  cmcgKCBWRVJPTkEgXChWUlwpKVRqCi0wIC0xMi44MjYgVGQoV2ViIFNpdGU6KVRqCjAgLTku | &&
|  NTM4IFRkKEVtYWlsOiBpbmZvQGNvZGljZWljb25hLmNvbSlUagowIC05LjUzOCBUZChDb2Qu | &&
|  RmlzY2FsZTogMDI0ODA3MzAyMjEpVGoKMCAtOS41MzggVGQoUC50YSBJdmE6ICAwMjQ4MDcz | &&
|  MDIyMSlUagotMCAtOS41MzggVGQoSXNjcml6aW9uZSBSZWdpc3RybyBJbXByZXNlOiBWUi0z | &&
|  OTgxNjEpVGoKMC44MjIgLTIyLjY0OCBUZChUSVBPIERPQ1VNRU5UTylUagowIC0xMC4zNiBU | &&
|  ZChGQVRUVVJBKVRqCjEwMS4yODMgMTAuMzYgVGQoTlVNRVJPKVRqCi0wIC0xMC4zNiBUZCgy | &&
|  MDI0MDAwNzIpVGoKNzYuMDAyIDEwLjM2IFRkKERBVEEpVGoKMCAtMTAuMzYgVGQoMjkvMTAv | &&
|  MjAyNClUagotMTc3LjI4NSAtMTQuMzA3IFRkKENMSUVOVEUpVGoKMCAtMTEuMTgyIFRkKDM1 | &&
|  KVRqCjYwLjgyOSAxMS4xODIgVGQoUEFSVElUQSBJVkEpVGoKODguNTEgMy4xMjUgVGQoQ09E | &&
|  SUNFKVRqCjAgLTYuMjUgVGQoRklTQ0FMRSlUagotODguNTEgLTExLjE4MiBUZCgwODc5MTE2 | &&
|  MDk2NilUago4OC41MSAwIFRkKDA4NzkxMTYwOTY2KVRqCjQ0LjE1NyAxNC4zMDcgVGQoUEFH | &&
|  SU5BKVRqCjAgLTExLjE4MiBUZCgxKVRqCjc2LjQ2OCAxMzIuMjY5IFRkKFNQRVRULkxFKVRq | &&
|  CjAgLTE1LjI5MyBUZChBUlRFTUVTVCBTLlIuTC4pVGoKMCAtMjQuMzM1IFRkKFZJQSBTQVZP | &&
|  TkEsIDk3IC0gTE9GVCBDNilUagowIC0xNS4yOTMgVGQoMjAxNDQgTUlMQU5PIFwoTUlcKSAt | &&
|  IElUQUxJQSlUagotMCAtMTQuNDcxIFRkKElORElSSVpaTyBTUEVESVpJT05FKVRqCjAgLTE1 | &&
|  LjI5MyBUZChBUlRFTUVTVCBTLlIuTC4pVGoKMCAtMjQuMzM1IFRkKFZJQSBTQVZPTkEsIDk3 | &&
|  IC0gTE9GVCBDNilUagowIC0xNS4yOTMgVGQoMjAxNDQgTUlMQU5PIFwoTUlcKSAtIElUQUxJ | &&
|  QSlUagotMjY5LjE0MiAtMzIuMDg3IFRkKENPRElDRSApVGoKNDUuMTg5IDAgVGQoREVTQ1JJ | &&
|  WklPTkUpVGoKMzc0LjcyIDAgVGQoVU0gKVRqCjE3LjM4OSAwIFRkKFFUQSApVGoKMjIuOTk3 | &&
|  IDAgVGQoUFJFWlpPIClUagozMy4wMiAwIFRkKFNDT05USSApVGoKMzMuMDU5IDAgVGQoVE9U | &&
|  QUxFIClUagovRjkgNi4zIFRmIC00ODEuMTg1IC0xMS4xODIgVGQoUklGIE5TIENPTkZFUk1B | &&
|  IEQnT1JESU5FIE4uIDE4IERFTCAyMy8xMC8yMDI0KVRqCi9GOCA2LjMgVGYgLTQ1LjE4OSAt | &&
|  MTEuMTgyIFRkKEYwMDA4QTA1Q0UpVGoKNDUuMTg5IDAgVGQoTFVNSU5BVE9SIGRpIEx1Y2lh | &&
|  bm8gQmFsZGVzc2FyaSwgbGFtcGFkYSBkYSB0ZXJyYSwgdHVibyBhIHNwaXJhbGUgcm9zc28p | &&
|  VGoKMzc2LjQ1MSAwIFRkKFBaIClUagoyMy4yOTUgMCBUZCggMSApVGoKMTguMTIyIDAgVGQo | &&
|  Mi45NTksMDApVGoKNjUuMDQyIDAgVGQoMi45NTksMDApVGoKL0Y5IDYuMyBUZiAtNDgyLjkx | &&
|  IC0xMS4xODIgVGQoKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq | &&
|  KioqKioqKioqKioqKioqKioqKioqKioqKiopVGoKMCAtMTIuNSBUZChWUy4gQ09ORkVSTUEg | &&
|  T1JESU5FICNSODkwOTc1NDg4KVRqCi0wIC0xMi41IFRkKCoqKioqKioqKioqKioqKioqKioq | &&
|  KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqICApVGoK | &&
|  L0Y4IDYuMyBUZiAtNDEuOSAtMjA2LjIxNSBUZChBTElRVU9UQSlUago0MC4wMDUgMCBUZChE | &&
|  RVNDUklaSU9ORSlUagoxODAuMDcyIDAgVGQoSU1QT05JQklMRSlUago2Mi4zNDcgMCBUZChJ | &&
|  VkEpVGoKLTI4Mi40MjQgLTEzLjY0OSBUZCgyMilUago0MC4wMDUgMCBUZChJdmEgYWwgMjIl | &&
|  KVRqCjE5MS41MjIgMCBUZCgyLjk1OSwwMClUago0MS44NiAwIFRkKDY1MCw5OClUagoyOS43 | &&
|  OTkgMTQuNzQgVGQoSU1QT05JQklMRSlUagowIC0xNS4yOTMgVGQoSVZBKVRqCjAgLTE1LjI5 | &&
|  MyBUZChUT1RBTEUgRE9DVU1FTlRPIFMuRS4mTy4gRVVSICAgIClUagoyMjAuODAyIDMxLjk2 | &&
|  IFRkKDIuOTU5LDAwKVRqCjEuMDAgMS4wMCAxLjAwIHJnIC0xOS44NzcgLTE4LjA0MyBUZCgu | &&
|  Li4uLi4uLi4uLi4uKVRqCjAuMDAgMC4wMCAwLjAwIHJnIDI1LjA5IDAgVGQoNjUwLDk4KVRq | &&
|  Ci01LjIxMyAtMTUuMjkzIFRkKDMuNjA5LDk4KVRqCi01MjguMDk4IC0xMi44MjYgVGQoUEFH | &&
|  QU1FTlRPKVRqCi0wIC0xMS4xODIgVGQoQk9OSUZJQ08gMzBHRyBEQVRBIEZBVFRVUkEpVGoK | &&
|  MTk1LjY1IDExLjE4MiBUZChCQU5DQSlUagotMCAtMTEuMTgyIFRkKEJBTkNBIFZBTFNBQkJJ | &&
|  TkEgU0NwYSBBQkk6IDA1MTE2IENBQjogMTE3MDMgQy9DOiAwIElCQU46IElUOTVVMDUxMTYx | &&
|  MTcwMzAwMDAwMDAwMzE5NSBCSUMpVGoKMCAtNi4yNSBUZChCQ1ZBSVQyVilUagozMDcuNDUg | &&
|  MTQuMzA3IFRkKFNDQURFTlpFKVRqCi0wIC0xMS4xODIgVGQoMjgvMTEvMjQpVGoKLTUwMy45 | &&
|  MjIgLTIyLjQ4NSBUZChDT09SRElOQVRFIEJBTkNBUklFKVRqCi0wIC05LjUzOCBUZChJU1RJ | &&
|  VFVUTylUagoxNTMuMzY1IDAgVGQoRklMSUFMRSlUagoxOTMuODgzIDAgVGQoQ09OVE8gQ09S | &&
|  UkVOVEUpVGoKLTM0Ny4yNDggLTkuNTM4IFRkKEJBTkNBIFZBTFNBQkJJTkEgU0NQQSlUagox | &&
|  NTMuMzY1IDAgVGQoUElBWlpBIFBSQURBVkFMIDEwLCAzNzEyMiAtIFZFUk9OQSlUagoxOTMu | &&
|  ODgzIDAgVGQoSVQ5NVUwNTExNjExNzAzMDAwMDAwMDAzMTk1IEJJQzogQkNWQUlUMlYpVGoK | &&
|  L0Y5IDYuMyBUZiAtMzQ3LjI0OCAtMTguNTM4IFRkKENvbnRyaWJ1dG8gY29uYWkgYXNzb2x0 | &&
|  byBvdmUgZG92dXRvKVRqCkVUClEKZW5kc3RyZWFtCmVuZG9iagoxMyAwIG9iajw8L0NvdW50 | &&
|  IDEvRmlyc3QgMTQgMCBSL0xhc3QgMTQgMCBSPj5lbmRvYmoKMTQgMCBvYmo8PC9QYXJlbnQg | &&
|  MTMgMCBSL1RpdGxlKG1vZHVsb19iYXNlLmFzcD9hej1JQ08xMTE5Jm51bWVybz03MiZ0aXBv | &&
|  ZG9jPUZBVFRJTU0mdmVuZGl0YW09biZhbm5vPTIwMjQmbjE9NzImbjI9NzImcmlzdGFtcGE9 | &&
|  MSZwcmV6emk9JnV0ZW50ZT0mbm9wcmV6emk9Jm5vcHJlenppdG90PSZyZXNpZHVvPSZ2bm90 | &&
|  ZT0mc3RhbXBhaXQ9JnN0bWFyZ2luZT0mY29waWU9JmZwPSZubD0pPj5lbmRvYmoKMTUgMCBv | &&
|  Ymo8PC9UeXBlL0NhdGFsb2cvUGFnZXMgMTAgMCBSL05hbWVzIDYgMCBSL1BhZ2VMYXlvdXQv | &&
|  U2luZ2xlUGFnZS9PdXRsaW5lcyAxMyAwIFIvUGFnZU1vZGUvVXNlTm9uZS9QYWdlTGFiZWxz | &&
|  PDwvTnVtc1swPDwvUy9EL1N0IDE+PjA8PC9TL0QvU3QgMT4+XT4+Pj5lbmRvYmoKeHJlZgow | &&
|  IDE2IAowMDAwMDAwMDAwIDY1NTM1IGYgCjAwMDAwMDAwMTUgMDAwMDAgbiAKMDAwMDAwMDEz | &&
|  MiAwMDAwMCBuIAowMDAwMDAxNDUzIDAwMDAwIG4gCjAwMDAwMDE1MjcgMDAwMDAgbiAKMDAw | &&
|  MDAwMTYwMyAwMDAwMCBuIAowMDAwMDAxNjg0IDAwMDAwIG4gCjAwMDAwMDE3MTQgMDAwMDAg | &&
|  biAKMDAwMDAwMTc0NCAwMDAwMCBuIAowMDAwMDAxODM1IDAwMDAwIG4gCjAwMDAwMDE4NzUg | &&
|  MDAwMDAgbiAKMDAwMDAwMTkyNyAwMDAwMCBuIAowMDAwMDAyMTM0IDAwMDAwIG4gCjAwMDAw | &&
|  MDgwODQgMDAwMDAgbiAKMDAwMDAwODEzNiAwMDAwMCBuIAowMDAwMDA4MzY0IDAwMDAwIG4g | &&
|  CnRyYWlsZXIKPDwvU2l6ZSAxNi9Sb290IDE1IDAgUi9JbmZvIDEgMCBSL0lEWzw0YWM0N2I3 | &&
|  NDg0Y2ZkZDQzMzYzNjM2NmVhM2ZmZDE5NT48NGFjNDdiNzQ4NGNmZGQ0MzM2MzYzNjZlYTNm | &&
|  ZmQxOTU+XT4+CnN0YXJ0eHJlZgo4NTI2CiUlRU9GCg== | &&
    |      </Attachment>| &&
    |    </Allegati>| &&
    |  </FatturaElettronicaBody>| &&
    |</p:FatturaElettronica>|.

    e_content = lv_xml_content.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SDI_XML_MODEL->FROM_XML_TO_ZIP
* +-------------------------------------------------------------------------------------------------+
* | [<---] E_FILENAME_PDF TYPE STRING
* | [<---] E_FILENAME_XML TYPE STRING
* | [<---] E_FILENAME_ZIP TYPE STRING
* | [<---] E_ZIP                          TYPE        XSTRING
* | [<---] E_PDF                          TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD from_xml_to_zip.
    DATA xml_base64_x_encoded TYPE xstring.
    DATA pdf_base64_x_decoded TYPE xstring.

*    DATA(xml_base64_encoded) = cl_web_http_utility=>encode_base64( lv_xml_string ).
*    DATA(xml_base64_encoded) =   lv_xml_string  .
    DATA(xml_utf8_encoded) = cl_web_http_utility=>encode_utf8( lv_xml_string ).
    parse_xml( xml_utf8_encoded )    .
    get_testata( IMPORTING testata = DATA(ls_testata) ).
    get_allegato( IMPORTING allegato = DATA(ls_allegato) ).

    CALL TRANSFORMATION id
      SOURCE pdf = ls_allegato-attachment
        RESULT pdf = pdf_base64_x_decoded.

    CALL TRANSFORMATION id
       SOURCE xml = xml_utf8_encoded
       RESULT xml = xml_base64_x_encoded.

    e_pdf = pdf_base64_x_decoded.
    e_filename_pdf = ls_allegato-nome_attachment.
    e_filename_zip = e_filename_pdf.

*    DATA(zip_filename) = ls_allegato-nome_attachment.

    REPLACE 'PDF' WITH 'ZIP' INTO e_filename_zip .
    REPLACE 'PDF' WITH 'XML' INTO e_filename_xml .

    DATA(lo_zip) = NEW cl_abap_zip( ).
    lo_zip->add( name    = e_filename_pdf  content = pdf_base64_x_decoded ). "PDF
    lo_zip->add( name    = e_filename_xml  content = xml_utf8_encoded ). " XML
    e_zip = lo_zip->save( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SDI_XML_MODEL->FROM_ZIP_TO_XML
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_FILENAME                     TYPE        STRING
* | [--->] I_ZIP                          TYPE        XSTRING
* | [<-()] LV_XML_STRING                  TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD from_zip_to_xml.
    DATA xml_base64_x_encoded TYPE xstring.
    DATA pdf_base64_x_decoded TYPE xstring.
    DATA(xml_filename) = i_filename.
    DATA(pdf_filename) = i_filename.
    DATA(lo_zip) = NEW cl_abap_zip( ).

    DATA(xml_name) = i_filename.
    DATA xml_base64_encoded TYPE string.

**********************************************************************

    REPLACE 'ZIP'  WITH 'PDF'  INTO pdf_filename .
    REPLACE 'ZIP'  WITH 'XML'  INTO xml_filename .

    "Carica il contenuto ZIP
    lo_zip->load(
      EXPORTING
        zip             = i_zip    ).

*    "Ottiene lista dei files
*    DATA lt_files TYPE lo_zip->t_files.
*    DATA lt_files_pdf TYPE lo_zip->t_files.
*    DATA lt_files_xml TYPE lo_zip->t_files.
*    DATA file TYPE lo_zip->t_file.
*
*    lt_files = lo_zip->files.
*
*    LOOP AT lt_files INTO file.
*      IF file-name CS 'PDF'.
*        APPEND file TO lt_files_pdf.
*      ELSEIF file-name CS 'XML'.
*        APPEND file TO lt_files_xml.
*      ENDIF.
*    ENDLOOP.

    REPLACE 'ZIP' WITH 'XML' INTO xml_name.

*     xml_base64_x_encoded  = lo_zip->get( lt_files_xml[ 1 ]-name ).
    lo_zip->get( EXPORTING  name = xml_name
      IMPORTING content = xml_base64_x_encoded ).


    CALL TRANSFORMATION id
       SOURCE xml = xml_base64_x_encoded
       RESULT xml = xml_base64_encoded.

*    lv_xml_string = cl_web_http_utility=>decode_base64( xml_base64_encoded ).
    lv_xml_string = cl_web_http_utility=>decode_utf8( xml_base64_x_encoded ).


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SDI_XML_MODEL->GET_ALLEGATO
* +-------------------------------------------------------------------------------------------------+
* | [<---] ALLEGATO                       TYPE        TY_ALLEGATI
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_allegato.
    allegato = me->ls_allegato.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SDI_XML_MODEL->GET_TESTATA
* +-------------------------------------------------------------------------------------------------+
* | [<---] TESTATA                        TYPE        TY_TESTATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_testata.
    testata = me->ls_testata.
  ENDMETHOD.

  METHOD get_xml_header.
    me->xml_header = VALUE #( vatcode = me->ls_testata-id_paese && me->ls_testata-id_codice cedente = me->ls_testata-cedente_denominazione
           data_fattura = me->ls_testata-data_fattura importototaledocumento  = me->ls_testata-importototaledocumento  ).

    xml_header = me->xml_header.
  ENDMETHOD.
* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SDI_XML_MODEL->GET_XML
* +-------------------------------------------------------------------------------------------------+
* | [<-()] EV_ZIP                         TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_xml.




  ENDMETHOD.

  METHOD get_encoded_xml.
* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SDI_XML_MODEL->PARSE_XML
* +-------------------------------------------------------------------------------------------------+
* | [--->] XRESULT                        TYPE        ANY
* | [<-()] OUTPUT                         TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>

    DATA payload TYPE string.

    IF xresult IS INITIAL.
      payload = get_content_dummy(  ).
    ELSE.
      payload = xresult.
    ENDIF.

    DATA(lv_xml_xstring) = xco_cp=>string( payload
      )->as_xstring( xco_cp_character=>code_page->utf_8
      )->value.

*    output = cl_web_http_utility=>encode_utf8( payload ).

    output = lv_xml_xstring.

  ENDMETHOD.
* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SDI_XML_MODEL->PARSE_XML
* +-------------------------------------------------------------------------------------------------+
* | [--->] XRESULT                        TYPE        ANY
* | [<-()] OUTPUT                         TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD parse_xml.

    DATA: lt_testata   TYPE TABLE OF ty_testata,
          lt_posizioni TYPE TABLE OF ty_posizione,
          lt_allegati  TYPE TABLE OF ty_allegati,
          lt_riepilogo TYPE TABLE OF ty_riepilogo.

    DATA lv_xml TYPE string.



*    DATA(base64_decoded) = cl_web_http_utility=>decode_base64( xresult ).
    DATA(base64_utf8) = cl_web_http_utility=>decode_utf8( xresult ).
    lv_xml = base64_utf8.


    DATA: ls_fattura TYPE ts_fattura.

    "Esecuzione trasformazione

    "Parsing del risultato
    CALL TRANSFORMATION zsdi_complex
      SOURCE XML lv_xml
      RESULT fattura = ls_fattura.

    "Assegnazione dei risultati
    me->ls_testata   = ls_fattura-testata.
    lt_posizioni = ls_fattura-posizioni.
    lt_allegati  = ls_fattura-allegati.
    me->ls_allegato = lt_allegati[ 1 ].
    lt_riepilogo = ls_fattura-riepilogo.


*    CALL TRANSFORMATION id
*      SOURCE fattura = ls_fattura
*      RESULT xml = output.


    "Serializzazione in JSON

    "Serializzazione in JSON
    output = /ui2/cl_json=>serialize(
        data             = ls_fattura
        pretty_name      = /ui2/cl_json=>pretty_mode-low_case    "lowercase per nomi
        compress         = abap_false                            "output formattato
        assoc_arrays     = abap_true                            "array per tabelle
        ts_as_iso8601   = abap_true                            "timestamp ISO8601
    ).


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SDI_XML_MODEL->TRANSFORM_XML_TO_API_JSON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_XML                         TYPE        STRING
* | [<-()] EV_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD transform_xml_to_api_json.

    DATA lv_xstring TYPE xstring.

    CALL TRANSFORMATION id
     SOURCE XML iv_xml
     RESULT XML lv_xstring.

    DATA(lv_json) = parse_xml( lv_xstring  ).

    CALL METHOD /ui2/cl_json=>serialize
      EXPORTING
        data        = ls_root
*       compress    = C_BOOL-FALSE
*       name        =
        pretty_name = /ui2/cl_json=>pretty_mode-camel_case
*       type_descr  =
*       assoc_arrays     = C_BOOL-FALSE
*       ts_as_iso8601    = C_BOOL-FALSE
*       expand_includes  = C_BOOL-TRUE
*       assoc_arrays_opt = C_BOOL-FALSE
*       numc_as_string   = C_BOOL-FALSE
*       name_mappings    =
*       conversion_exits = C_BOOL-FALSE
      RECEIVING
        r_json      = ev_json.

  ENDMETHOD.
ENDCLASS.
