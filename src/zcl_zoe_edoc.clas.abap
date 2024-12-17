CLASS zcl_zoe_edoc DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
*    "! Flags per il tipo di documento
    DATA:
      xml TYPE abap_boolean,
      pdf TYPE abap_boolean,
      zip TYPE abap_boolean.

    "! Response pubblica
    DATA pub_response TYPE string READ-ONLY.

*    "! Costanti MIME
    CONSTANTS:
      c_mime_pdf TYPE string VALUE 'application/pdf',
      c_mime_xml TYPE string VALUE 'application/xml',
      c_mime_zip TYPE string VALUE 'application/zip'.

*    "! Strutture dati documento
    DATA:
      edocument       TYPE zoe_edocument READ-ONLY,
      edocument_t     TYPE zoe_edocument_t READ-ONLY,
      edocumentfile   TYPE zoe_edocfile READ-ONLY,
      edocumentfile_t TYPE zoe_edocfile_t READ-ONLY.

*    "! Buffer dati
    DATA:
      buffer   TYPE zedoc_db,
      buffer_t TYPE zedoc_db_t.

*    "! Info di stato
    DATA:
      severity    TYPE if_abap_behv_message=>t_severity READ-ONLY,
      action_text TYPE string READ-ONLY.

    METHODS:
      "! Costruttore
      constructor
        IMPORTING
          !iv_edoc_guid TYPE zunique_value OPTIONAL
          !iv_edocflow  TYPE zedocflow DEFAULT 'EDOCI'
          !is_new       TYPE abap_bool  DEFAULT abap_true
          !unit_test    TYPE abap_bool  DEFAULT abap_true
          !filename     TYPE string     OPTIONAL
          !iv_content   TYPE zedoc_db-xmldata OPTIONAL,

      "! Esegue azioni sui documenti
      execute_action
        IMPORTING
          !iv_action TYPE string,

      "! Aggiorna dati documento
      data_update
        IMPORTING
          edocflow  TYPE zedocflow DEFAULT 'EDOCI'
          edoc_guid TYPE zunique_value,

      "! Inizializza dati documento
      data_init
        IMPORTING
          edoc_guid        TYPE zunique_value OPTIONAL
          parent_edoc_guid TYPE zunique_value OPTIONAL
          edocflow         TYPE zedocflow DEFAULT 'EDOCI'
          is_new           TYPE abap_bool  DEFAULT abap_true
          unit_test        TYPE abap_bool  DEFAULT abap_true
          filename         TYPE string     OPTIONAL
          xcontent         TYPE zedoc_db-xmldata OPTIONAL
          content          TYPE string     OPTIONAL
          invoice          TYPE zmri_invoice-invoice OPTIONAL.

  PROTECTED SECTION.
*    "! Attributi file
    DATA:
      new              TYPE abap_bool,
      filename         TYPE string,
      zip_filename     TYPE string,
      pdf_filename     TYPE string,
      action           TYPE string,
      file_guid        TYPE zunique_value,
      edoc_guid        TYPE zunique_value,
      parent_edoc_guid TYPE zunique_value,
      invoice          TYPE zmri_invoice-invoice,
      iv_content       TYPE string.

*    "! Contenuti documento
    DATA:
      xzipcontent   TYPE zedoc_db-zipdata,
      pdfcontent    TYPE zedoc_db-zipdata,
      xcontent      TYPE zedoc_db-xmldata,
      xmlcontentraw TYPE string,
      xml_header    TYPE zoe_xml_data_extract,
      edocflow      TYPE zedocflow,
      no_commit     TYPE abap_boolean.

  PRIVATE SECTION.
    METHODS:
      "! Conversione XML-Buffer
      xml_2_buffer,

      "! Salvataggio entità
      save_entity_edocument,
      save_entity_buffer,
      save_entity_edocufile,

      "! Aggiornamento entità
      update_entity_edocument,
      update_entity_buffer,

      "! Gestione del salvataggio DB
      edoc_save_2_db
        IMPORTING
          no_commit TYPE abap_boolean DEFAULT abap_false,
      edoc_save_pdf_db,

      "! Gestione documenti
      init_data_from_xml
        IMPORTING
          lv_xml_string TYPE any,
      init_data_from_pdf,
      init_data_from_zip,

      "! Azioni sui documenti
      a_create,
      a_create_pdf,
      a_create_from_rest
        IMPORTING
          no_commit TYPE abap_bool DEFAULT abap_true,
      a_create_from_rest_out,
      a_create_from_staging,
      a_post,

      "! Gestione staging
      a_create_invoice_staging
        IMPORTING
          mime_type TYPE string,
      a_create_invoice_staging_pdf,
      a_create_invoice_staging_xml,
      a_create_invoice_staging_zip,

      "! Conversione formati
      from_xml_to_zip
        IMPORTING
          lv_xml_string TYPE any,
      from_zip_to_xml
        IMPORTING
          !i_filename          TYPE string
          !i_zip               TYPE xstring
        RETURNING
          VALUE(lv_xml_string) TYPE string,

      "! Utility
      get_encode64_content_dummy
        RETURNING
          VALUE(e_xcontent) TYPE xstring,
      get_content_dummy
        RETURNING
          VALUE(e_content) TYPE string,


      data_init_for_test.
    METHODS a_unit_test.
ENDCLASS.



CLASS zcl_zoe_edoc IMPLEMENTATION.


  METHOD constructor.



  ENDMETHOD.


  METHOD get_encode64_content_dummy.
    DATA(content) = me->get_content_dummy(  ).
    DATA xml_base64_x_encoded TYPE xstring.

    DATA(xml_base64_encoded) = cl_web_http_utility=>encode_base64( content ).

    CALL TRANSFORMATION id
       SOURCE xml = xml_base64_encoded
       RESULT xml = xml_base64_x_encoded.

    e_xcontent = xml_base64_x_encoded.

  ENDMETHOD.
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

    DATA(lv_xml_string) =
      |<?xml version="1.0" encoding="utf-8"?>\n| &&
      |<SalesOrder>\n| &&
      |  <Header>\n| &&
      |    <OrderNumber>4500000123</OrderNumber>\n| &&
      |    <OrderDate>2024-12-07</OrderDate>\n| &&
      |    <Customer>\n| &&
      |      <ID>1000</ID>\n| &&
      |      <Name>ACME Corporation</Name>\n| &&
      |      <Country>IT</Country>\n| &&
      |    </Customer>\n| &&
      |  </Header>\n| &&
      |  <Items>\n| &&
      |    <Item>\n| &&
      |      <Position>10</Position>\n| &&
      |      <MaterialNumber>MAT001</MaterialNumber>\n| &&
      |      <Quantity>100</Quantity>\n| &&
      |      <Unit>PC</Unit>\n| &&
      |      <Price>10.50</Price>\n| &&
      |    </Item>\n| &&
      |    <Item>\n| &&
      |      <Position>20</Position>\n| &&
      |      <MaterialNumber>MAT002</MaterialNumber>\n| &&
      |      <Quantity>50</Quantity>\n| &&
      |      <Unit>PC</Unit>\n| &&
      |      <Price>25.00</Price>\n| &&
      |    </Item>\n| &&
      |  </Items>\n| &&
      |</SalesOrder>|.
    e_content = lv_xml_content.

*    e_content = lv_xml_string.

  ENDMETHOD.

  METHOD from_xml_to_zip .

    DATA xml_base64_x_encoded TYPE xstring.
    DATA xml_utf8_encoded TYPE string.

    DATA(o_model) = NEW  zcl_sdi_xml_model( ).

*    DATA(xml_base64_encoded) = cl_web_http_utility=>encode_base64( lv_xml_string ).
*    DATA(xml_utf8_encoded) = cl_web_http_utility=>encode_utf8( lv_xml_string ).

*    DATA(xoutput) = o_model->get_encoded_xml( lv_xml_string  ).

*    CALL TRANSFORMATION id
*       SOURCE xml = lv_xml_string
*       RESULT xml = xml_utf8_encoded.

*    me->xmlcontentraw = lv_xml_string.
*    me->xcontent = xoutput. "xml_base64_x_encoded.



    o_model->from_xml_to_zip(
    EXPORTING
      lv_xml_string = me->xmlcontentraw
      lv_xml_xstring = me->xcontent
      i_filename_xml = me->filename
    IMPORTING
      e_filename_xml    = me->filename
      e_filename_pdf = me->pdf_filename
      e_filename_zip = me->zip_filename
      e_zip         = me->xzipcontent
      e_pdf         = me->pdfcontent  )    .

    me->xml_header = o_model->get_xml_header(  ).

  ENDMETHOD.
  METHOD from_zip_to_xml.
    DATA xml_base64_x_encoded TYPE xstring.
    DATA pdf_base64_x_decoded TYPE xstring.
    DATA(xml_filename) = i_filename.
    DATA(pdf_filename) = i_filename.
    DATA(lo_zip) = NEW cl_abap_zip( ).

    DATA(xml_name) = i_filename.
    DATA xml_base64_encoded TYPE string.

**********************************************************************

*    REPLACE 'ZIP'  WITH 'PDF'  INTO pdf_filename .
*    REPLACE 'ZIP'  WITH 'XML'  INTO xml_filename .

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

*    REPLACE 'ZIP' WITH 'XML' INTO xml_name.

*     xml_base64_x_encoded  = lo_zip->get( lt_files_xml[ 1 ]-name ).
    lo_zip->get( EXPORTING  name = xml_name
      IMPORTING content = xml_base64_x_encoded ).


*    CALL TRANSFORMATION id
*       SOURCE xml = xml_base64_x_encoded
*       RESULT xml = xml_base64_encoded.

*    lv_xml_string = cl_web_http_utility=>decode_base64( xml_base64_encoded ).
    lv_xml_string = cl_web_http_utility=>decode_utf8( xml_base64_x_encoded ).


  ENDMETHOD.
  METHOD init_data_from_zip .

    TRY.
        DATA(unique_value) = cl_system_uuid=>create_uuid_c36_static( )  .
      CATCH  cx_uuid_error .
        me->file_guid  = me->edoc_guid .
    ENDTRY.

    me->edocumentfile = VALUE #(  file_guid = file_guid zunique_value = me->parent_edoc_guid
*       file_raw = me->xcontent
*       file_sraw = me->xmlcontentraw
*        filename = me->filename
*        filenamepdf = me->filename
*        mimetypepdf = c_mime_pdf
*        pdfdata = me->pdfcontent
       filenamezip = me->filename
*       mimetypexml = 'application/xml'
*       xmldata = me->xcontent
        mimetypezip = c_mime_zip
        zipdata = me->xcontent


    ).

    me->xml_2_buffer( ).
  ENDMETHOD.

  METHOD init_data_from_pdf .


    TRY.
        DATA(unique_value) = cl_system_uuid=>create_uuid_c36_static( )  .
      CATCH  cx_uuid_error .
        me->file_guid  = me->edoc_guid .
    ENDTRY.


    me->file_guid  = me->edoc_guid .


    me->edocumentfile = VALUE #(  file_guid = file_guid zunique_value = me->parent_edoc_guid
*       file_raw = me->xcontent
*       file_sraw = me->xmlcontentraw
*        filename = me->filename
        filenamepdf = me->filename
        mimetypepdf = c_mime_pdf
        pdfdata = me->xcontent
*       filenamezip = me->zip_filename
*       mimetypexml = 'application/xml'
*       xmldata = me->xcontent
*       mimetypezip = 'application/zip'
*       zipdata = me->xzipcontent


    ).

    me->xml_2_buffer( ).
  ENDMETHOD.

  METHOD init_data_from_xml .

    me->from_xml_to_zip(  lv_xml_string ).


    IF  me->edoc_guid IS INITIAL.
      DATA(unique_value) = cl_system_uuid=>create_uuid_c36_static( )  .
      me->edoc_guid = unique_value.
    ENDIF.

    IF me->parent_edoc_guid IS INITIAL.
      me->parent_edoc_guid = me->edoc_guid.
    ENDIF.

    me->file_guid  = me->edoc_guid  .


    me->edocument = VALUE #(  zunique_value = me->edoc_guid   file_guid = file_guid
       status = 1 statusdescr = 'Ricevuto da Intermediario'
       vatcode = me->xml_header-vatcode
       cedente = me->xml_header-cedente
       data_fattura = me->xml_header-data_fattura
       importototaledocumento  = me->xml_header-importototaledocumento
    ).

    me->edocumentfile = VALUE #(  file_guid = file_guid zunique_value = me->parent_edoc_guid
       file_raw = me->xcontent
       file_sraw = me->xmlcontentraw
       filename = me->filename
       filenamepdf = me->pdf_filename
       filenamezip = me->zip_filename
       mimetypexml = 'application/xml'
       xmldata = me->xcontent
       mimetypezip = 'application/zip'
       zipdata = me->xzipcontent
       mimetypepdf = 'application/pdf'
       pdfdata = me->pdfcontent
    ).

    me->xml_2_buffer( ).
  ENDMETHOD.
  METHOD a_CREATE_PDF .
    init_data_from_pdf( ).
  ENDMETHOD.


  METHOD a_create.
    init_data_from_xml( me->xmlcontentraw ).
    APPEND me->edocument TO me->edocument_t.
    APPEND me->edocumentfile TO me->edocumentfile_t.
    APPEND me->buffer TO me->buffer_t.
  ENDMETHOD.
  METHOD a_create_from_rest_out.
    a_create_from_rest(  ).
  ENDMETHOD.
  METHOD a_create_from_rest.

    " ZIP - PDF - XML
    me->no_commit = no_commit.
    CASE abap_true.
      WHEN xml.
        me->a_create_invoice_staging_xml( ).
        me->a_create(  ).
        me->edoc_save_2_db( ).
      WHEN pdf.
        init_data_from_pdf( ).
        me->a_create_invoice_staging_pdf( ).
        me->edoc_save_pdf_db( ).
      WHEN zip.
        init_data_from_zip( ).
        a_create_invoice_staging_zip( ).
    ENDCASE.


    xml_header  = VALUE #(
                    pub_edoc_guid = me->edoc_guid
                    parent_edoc_guid = me->parent_edoc_guid
                    result = if_abap_behv_message=>severity-success
                    message     = 'Document created successfully in EDOCUMENT' ).

    "Serializzazione in JSON
    pub_response = /ui2/cl_json=>serialize(
        data             = xml_header
        pretty_name      = /ui2/cl_json=>pretty_mode-low_case    "lowercase per nomi
        compress         = abap_false                            "output formattato
        assoc_arrays     = abap_true                            "array per tabelle
        ts_as_iso8601   = abap_true                            "timestamp ISO8601
    ).


  ENDMETHOD.


  METHOD a_create_invoice_staging_xml .
    a_create_invoice_staging(  c_mime_xml ).
  ENDMETHOD.
  METHOD a_create_invoice_staging_pdf.
    a_create_invoice_staging(  c_mime_pdf ).
  ENDMETHOD.
  METHOD a_create_invoice_staging_zip.
    a_create_invoice_staging(  c_mime_zip ).
  ENDMETHOD.
  METHOD a_create_invoice_staging.
** save invoice in ZOE_STAGING_FILE
    DATA lv_filename TYPE string.
    DATA lv_zip TYPE xstring.
    DATA xcontent TYPE xstring.
    DATA wa_inv_i TYPE zoe_staging_file.
*    DATA wa_inv_d TYPE zmri_invoice_d.
    DATA wa_inv_cds TYPE zr_oe_staging_file.
    DATA comments TYPE zr_oe_staging_file-comments.


    TRY.
        DATA(unique_value) = cl_system_uuid=>create_uuid_c36_static( )  .
      CATCH  cx_uuid_error .
        me->file_guid  = me->edoc_guid .
    ENDTRY.

    invoice = unique_value.

    lv_filename  = me->filename.

    " *** xml ***
    CASE abap_true.
      WHEN xml.  comments =  'unit test XML da REST'.
      WHEN pdf.  comments =  'unit test PDF da REST'.
      WHEN zip.  comments =  'unit test ZIP da REST'.
    ENDCASE.



    IF pdf = abap_true.
      DATA pdf_base64_x_decoded TYPE xstring.
      CALL TRANSFORMATION id
        SOURCE pdf = me->xcontent
          RESULT pdf = pdf_base64_x_decoded.

      me->xcontent = pdf_base64_x_decoded.

    ENDIF.

    IF zip = abap_true.
      DATA zip_base64_x_decoded TYPE xstring.
      CALL TRANSFORMATION id
        SOURCE pdf = me->xcontent
          RESULT pdf = zip_base64_x_decoded.

      me->xcontent = zip_base64_x_decoded.

    ENDIF.

    wa_inv_i = VALUE #(
         invoice = invoice Filenamepdf = lv_filename
         pdfdata = me->xcontent
         mimetypepdf = mime_type
         comments = comments ).

    CASE edocflow.
      WHEN 'EDOCI'.
        " -----  passivo
        " -----
        " -----  xml inbound
        " -----  pdf inbound
        " -----  zip manuale con XML
        CASE abap_true.
          WHEN xml.
            wa_inv_i-inbound = abap_true.
            wa_inv_i-outbound = abap_false.
          WHEN pdf.
            wa_inv_i-inbound = abap_true.
            wa_inv_i-outbound = abap_false.
          WHEN zip.
            wa_inv_i-inbound = abap_true.
            wa_inv_i-outbound = abap_false.
*        wa_inv_i-from_edoc = abap_true.
            wa_inv_i-manual_post = abap_false.
        ENDCASE.
      WHEN 'EDOCO'.
        " ----- attivo
        " -----
        " ----- xml outbound from_edoc
        " ----- pdf outbound
        " ----- zip outbound
        CASE abap_true.
          WHEN xml.
            wa_inv_i-outbound = abap_true.
            wa_inv_i-from_edoc = abap_true.
          WHEN pdf.
            wa_inv_i-outbound = abap_true.
          WHEN zip.
            wa_inv_i-inbound = abap_false.
            wa_inv_i-from_edoc = abap_true.
            wa_inv_i-outbound = abap_true.
        ENDCASE.
    ENDCASE.

    MOVE-CORRESPONDING wa_inv_i TO wa_inv_cds.

    MODIFY ENTITIES OF zr_oe_staging_file
          ENTITY Staging
          CREATE FROM VALUE #( (
             %cid = 'CID_CREATE_EDOC'
             %data = wa_inv_cds
             %control = VALUE #(
               Invoice = if_abap_behv=>mk-on
               Filenamepdf = if_abap_behv=>mk-on
               Pdfdata = if_abap_behv=>mk-on
               Mimetypepdf = if_abap_behv=>mk-on
               Comments = if_abap_behv=>mk-on
               Inbound = if_abap_behv=>mk-on
               Outbound = if_abap_behv=>mk-on
               FromEdoc = if_abap_behv=>mk-on
               ManualPost = if_abap_behv=>mk-on
                    ) ) )
    MAPPED DATA(edocu_mapped)
    FAILED DATA(edocu_failed)
    REPORTED DATA(edocu_reported).

    COMMIT ENTITIES.


    me->invoice = invoice.
  ENDMETHOD.



  METHOD a_create_from_staging.

    DATA lo_zip  TYPE REF TO cl_abap_zip.
    DATA xml_filename TYPE string.
    DATA i_zip  TYPE xstring.
    DATA s_invoice TYPE zoe_staging_file.
    DATA allowed TYPE abap_boolean.


    SELECT SINGLE * FROM zoe_staging_file
      WHERE invoice = @me->invoice
       INTO @s_invoice.

    CLEAR me->invoice.



    IF s_invoice-outbound = abap_false AND s_invoice-manual_post = abap_true.
      allowed = abap_true.
    ELSE.
      me->severity = if_abap_behv_message=>severity-error.
      me->action_text = 'File e Processo NON VALIDO per il POST'.
      allowed = abap_false.

    ENDIF.

    CHECK allowed = abap_true.

    i_zip = s_invoice-pdfdata.

    lo_zip = NEW cl_abap_zip( ).
    lo_zip->load(
    EXPORTING
      zip             = i_zip   ).

    "Ottiene lista dei files
    DATA lt_files TYPE lo_zip->t_files.

    DATA lt_files_xml TYPE lo_zip->t_files.
    DATA file TYPE lo_zip->t_file.

    lt_files = lo_zip->files.

    FREE: me->edocument_t, me->edocumentfile_t, me->buffer_t.

    LOOP AT lt_files INTO file.
      IF file-name CS 'XML'.
        xml_filename = file-name.


        lo_zip->get( EXPORTING  name = xml_filename
      IMPORTING content = DATA(lv_content) ).

        DATA(lv_string) = xco_cp=>xstring( lv_content
              )->as_string( xco_cp_character=>code_page->utf_8
              )->value.
*** istanza singleton
        DATA(me_obj) = NEW zcl_zoe_edoc( ).
        me_obj->data_init( edocflow = 'EDOCI'   filename = xml_filename content = lv_string xcontent = lv_content ).

        me_obj->a_create(  ).
        me_obj->edoc_save_2_db( no_commit = abap_true ).

        me->severity = if_abap_behv_message=>severity-success.


        me->action_text = 'Record Salvato in OCRA EDOCUMENT'.

*        init_data_from_xml( me->xmlcontentraw ).
        APPEND LINES OF me_obj->edocument_t TO me->edocument_t.
        APPEND LINES OF me_obj->edocumentfile_t TO me->edocumentfile_t.
        APPEND LINES OF me_obj->buffer_t TO me->buffer_t.

      ENDIF.
    ENDLOOP.


  ENDMETHOD.


  METHOD edoc_save_pdf_db.
    FIELD-SYMBOLS: <file> TYPE  zoe_edocfile.


    " agggiorno il record dell'XML PADRE sostituendo il contenuto di PDFDATA(copia di cortesia, se presente)
    "  con il pdf ricevuto

    buffer-unique_value = me->parent_edoc_guid.
    buffer-pdfdata = me->xcontent.

    " inserisco il file PDF ricevuto nel file ZIP
    DATA(lo_zip) = NEW cl_abap_zip( ).

    lo_zip->load(
   EXPORTING
     zip             = buffer-zipdata    ).


    lo_zip->add( name    = me->filename  content = me->xcontent ). " PDF
    buffer-zipdata = lo_zip->save( ).

    update_entity_buffer( ).

    LOOP AT edocumentfile_t ASSIGNING <file>.
      " creo  il record in EDOCUMENTFILE con il pdf ricevuto
      <file>-file_guid = me->parent_edoc_guid.
      <file>-zunique_value = me->parent_edoc_guid.
      <file>-seq_no = 1.
      <file>-pdfdata = me->xcontent.
    ENDLOOP.



    save_entity_edocufile( ).

  ENDMETHOD.
  METHOD update_entity_buffer.
    LOOP AT buffer_t INTO buffer.
      MODIFY ENTITIES OF zr_edoc_db
        ENTITY EdocDB
        UPDATE FROM VALUE #( (
*          %cid = 'CID_CREATE_EDOC'
          edocflow = buffer-edocflow
          UniqueValue = buffer-unique_value
          filename = buffer-filename
          filenamezip = buffer-filenamezip
          mimetypexml = buffer-mimetypexml
          xmldata = buffer-xmldata
          mimetypezip = buffer-mimetypezip
          zipdata = buffer-zipdata
          ernam = buffer-ernam
          erdat = buffer-erdat
          erzet = buffer-erzet
          tmstp = buffer-tmstp
          createdon = buffer-created_on
*          createdby = buffer-created_by
          creationuser = buffer-creation_user
*          lastchangedby = buffer-lastchangedby
*          locallastchanged = buffer-local_last_changed
*          lastchanged = buffer-last_changed
          mimetypepdf = buffer-mimetypepdf
          filenamepdf = buffer-filenamepdf
          pdfdata = buffer-pdfdata
          filesraw = buffer-file_sraw
          %control-edocflow = if_abap_behv=>mk-on
          %control-uniquevalue = if_abap_behv=>mk-on
          %control-filename = if_abap_behv=>mk-on
          %control-filenamezip = if_abap_behv=>mk-on
          %control-mimetypexml = if_abap_behv=>mk-on
          %control-xmldata = if_abap_behv=>mk-on
          %control-mimetypezip = if_abap_behv=>mk-on
          %control-zipdata = if_abap_behv=>mk-on
          %control-ernam = if_abap_behv=>mk-on
          %control-erdat = if_abap_behv=>mk-on
          %control-erzet = if_abap_behv=>mk-on
          %control-tmstp = if_abap_behv=>mk-on
          %control-createdon = if_abap_behv=>mk-on
*          %control-createdby = if_abap_behv=>mk-on
          %control-creationuser = if_abap_behv=>mk-on
*          %control-lastchangedby = if_abap_behv=>mk-on
*          %control-locallastchanged = if_abap_behv=>mk-on
*          %control-lastchanged = if_abap_behv=>mk-on
          %control-mimetypepdf = if_abap_behv=>mk-on
          %control-filenamepdf = if_abap_behv=>mk-on
          %control-pdfdata = if_abap_behv=>mk-on
          %control-filesraw = if_abap_behv=>mk-on
        ) )
        MAPPED DATA(edocdb_mapped)
        FAILED DATA(edocdb_failed)
        REPORTED DATA(edocdb_reported).
      COMMIT ENTITIES.
    ENDLOOP.

  ENDMETHOD.

  METHOD save_entity_buffer.
    LOOP AT buffer_t INTO buffer.
      MODIFY ENTITIES OF zr_edoc_db
        ENTITY EdocDB
        CREATE FROM VALUE #( (
          %cid = 'CID_CREATE_EDOC'
          edocflow = buffer-edocflow
          UniqueValue = buffer-unique_value
          filename = buffer-filename
          filenamezip = buffer-filenamezip
          mimetypexml = buffer-mimetypexml
          xmldata = buffer-xmldata
          mimetypezip = buffer-mimetypezip
          zipdata = buffer-zipdata
          ernam = buffer-ernam
          erdat = buffer-erdat
          erzet = buffer-erzet
          tmstp = buffer-tmstp
          createdon = buffer-created_on
*          createdby = buffer-created_by
          creationuser = buffer-creation_user
*          lastchangedby = buffer-lastchangedby
*          locallastchanged = buffer-local_last_changed
*          lastchanged = buffer-last_changed
          mimetypepdf = buffer-mimetypepdf
          filenamepdf = buffer-filenamepdf
          pdfdata = buffer-pdfdata
          filesraw = buffer-file_sraw
          %control-edocflow = if_abap_behv=>mk-on
          %control-uniquevalue = if_abap_behv=>mk-on
          %control-filename = if_abap_behv=>mk-on
          %control-filenamezip = if_abap_behv=>mk-on
          %control-mimetypexml = if_abap_behv=>mk-on
          %control-xmldata = if_abap_behv=>mk-on
          %control-mimetypezip = if_abap_behv=>mk-on
          %control-zipdata = if_abap_behv=>mk-on
          %control-ernam = if_abap_behv=>mk-on
          %control-erdat = if_abap_behv=>mk-on
          %control-erzet = if_abap_behv=>mk-on
          %control-tmstp = if_abap_behv=>mk-on
          %control-createdon = if_abap_behv=>mk-on
*          %control-createdby = if_abap_behv=>mk-on
          %control-creationuser = if_abap_behv=>mk-on
*          %control-lastchangedby = if_abap_behv=>mk-on
*          %control-locallastchanged = if_abap_behv=>mk-on
*          %control-lastchanged = if_abap_behv=>mk-on
          %control-mimetypepdf = if_abap_behv=>mk-on
          %control-filenamepdf = if_abap_behv=>mk-on
          %control-pdfdata = if_abap_behv=>mk-on
          %control-filesraw = if_abap_behv=>mk-on
        ) )
        MAPPED DATA(edocdb_mapped)
        FAILED DATA(edocdb_failed)
        REPORTED DATA(edocdb_reported).
      IF no_commit = abap_false.
        COMMIT ENTITIES.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
  METHOD update_entity_edocument.

    DATA: ls_edocument TYPE zr_oe_edocument.


    LOOP AT edocument_t INTO edocument.

      ls_edocument-UniqueValue = edocument-zunique_value.

      ls_edocument-Status = edocument-status.
      ls_edocument-Statusdescr = edocument-statusdescr.



      MODIFY ENTITIES OF zr_oe_edocument
            ENTITY Edocument
            UPDATE FROM VALUE #( (

               %data = ls_edocument
               %control = VALUE #(
*                 unique_value = if_abap_behv=>mk-on
*                 SeqNo = if_abap_behv=>mk-on
*                   Bukrs = if_abap_behv=>mk-on
*                 Land = if_abap_behv=>mk-on
*                 FileGuid = if_abap_behv=>mk-on
                 Status = if_abap_behv=>mk-on
                 Statusdescr = if_abap_behv=>mk-on
**                 Ernam = if_abap_behv=>mk-on
*                 Erdat = if_abap_behv=>mk-on
*                 Erzet = if_abap_behv=>mk-on
*                 Tmstp = if_abap_behv=>mk-on
*                 Vatcode = if_abap_behv=>mk-on
*                 Cedente = if_abap_behv=>mk-on
*                 DataFattura = if_abap_behv=>mk-on
*                 Importototaledocumento = if_abap_behv=>mk-on
   ) ) )
      MAPPED DATA(edocu_mapped)
      FAILED DATA(edocu_failed)
      REPORTED DATA(edocu_reported).
      IF no_commit = abap_false.
        COMMIT ENTITIES.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.




  METHOD save_entity_edocument.

    DATA: ls_edocument TYPE zr_oe_edocument.


    LOOP AT edocument_t INTO edocument.

      ls_edocument-UniqueValue = edocument-zunique_value.
      ls_edocument-SeqNo = edocument-seq_no.
      ls_edocument-Land = edocument-land.
      ls_edocument-FileGuid = edocument-file_guid.
      ls_edocument-Status = edocument-status.
      ls_edocument-Statusdescr = edocument-statusdescr.
      ls_edocument-Ernam = edocument-ernam.
      ls_edocument-Erdat = edocument-erdat.
      ls_edocument-Erzet = edocument-erzet.
      ls_edocument-Tmstp = edocument-tmstp.
      ls_edocument-Vatcode = edocument-vatcode.
      ls_edocument-Cedente = edocument-cedente.
      ls_edocument-DataFattura = edocument-data_fattura.
      ls_edocument-Importototaledocumento = edocument-importototaledocumento.


      MODIFY ENTITIES OF zr_oe_edocument
            ENTITY Edocument
            CREATE FROM VALUE #( (
               %cid = 'CID_CREATE_EDOC'
               %data = ls_edocument
               %control = VALUE #(
                 UniqueValue = if_abap_behv=>mk-on
                 SeqNo = if_abap_behv=>mk-on
*                   Bukrs = if_abap_behv=>mk-on
                 Land = if_abap_behv=>mk-on
                 FileGuid = if_abap_behv=>mk-on
                 Status = if_abap_behv=>mk-on
                 Statusdescr = if_abap_behv=>mk-on
                 Ernam = if_abap_behv=>mk-on
                 Erdat = if_abap_behv=>mk-on
                 Erzet = if_abap_behv=>mk-on
                 Tmstp = if_abap_behv=>mk-on
                 Vatcode = if_abap_behv=>mk-on
                 Cedente = if_abap_behv=>mk-on
                 DataFattura = if_abap_behv=>mk-on
                 Importototaledocumento = if_abap_behv=>mk-on      ) ) )
      MAPPED DATA(edocu_mapped)
      FAILED DATA(edocu_failed)
      REPORTED DATA(edocu_reported).
      IF no_commit = abap_false.
        COMMIT ENTITIES.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD save_entity_edocufile.
    DATA: ls_edocfile TYPE zr_oe_edocfile.

    LOOP AT edocumentfile_t INTO edocumentfile.
      ls_edocfile-FileGuid = edocumentfile-file_guid.
      ls_edocfile-ZuniqueValue = edocumentfile-zunique_value.
      ls_edocfile-SeqNo = edocumentfile-seq_no.
      ls_edocfile-Filename = edocumentfile-filename.
      ls_edocfile-Filenamezip = edocumentfile-filenamezip.
      ls_edocfile-Mimetypexml = edocumentfile-mimetypexml.
      ls_edocfile-Xmldata = edocumentfile-xmldata.
      ls_edocfile-Mimetypezip = edocumentfile-mimetypezip.
      ls_edocfile-Zipdata = edocumentfile-zipdata.
      ls_edocfile-CreatedOn = edocumentfile-created_on.
      ls_edocfile-CreatedBy = edocumentfile-created_by.
      ls_edocfile-Lastchangedby = edocumentfile-lastchangedby.
      ls_edocfile-LocalLastChanged = edocumentfile-local_last_changed.
      ls_edocfile-LastChanged = edocumentfile-last_changed.
      ls_edocfile-FileRaw = edocumentfile-file_raw.
      ls_edocfile-Mimetypepdf = edocumentfile-mimetypepdf.
      ls_edocfile-Filenamepdf = edocumentfile-filenamepdf.
      ls_edocfile-Pdfdata = edocumentfile-pdfdata.
      ls_edocfile-FileSraw = edocumentfile-file_sraw.



      MODIFY ENTITIES OF zr_oe_edocfile
            ENTITY EdocumentFile
            CREATE FROM VALUE #( (
                %cid = 'CID_CREATE_EDOC'
               %data = ls_edocfile
               %control = VALUE #(
               FileGuid = if_abap_behv=>mk-on
               ZuniqueValue = if_abap_behv=>mk-on
               SeqNo = if_abap_behv=>mk-on
               Filename = if_abap_behv=>mk-on
               Filenamezip = if_abap_behv=>mk-on
               Mimetypexml = if_abap_behv=>mk-on
               Xmldata = if_abap_behv=>mk-on
               Mimetypezip = if_abap_behv=>mk-on
               Zipdata = if_abap_behv=>mk-on
               CreatedOn = if_abap_behv=>mk-on
               CreatedBy = if_abap_behv=>mk-on
               Lastchangedby = if_abap_behv=>mk-on
               LocalLastChanged = if_abap_behv=>mk-on
               LastChanged = if_abap_behv=>mk-on
               FileRaw = if_abap_behv=>mk-on
               Mimetypepdf = if_abap_behv=>mk-on
               Filenamepdf = if_abap_behv=>mk-on
               Pdfdata = if_abap_behv=>mk-on
               FileSraw = if_abap_behv=>mk-on )   ) )
            MAPPED DATA(edocuf_mapped)
            FAILED DATA(edocuf_failed)
            REPORTED DATA(edocuf_reported).
      " Gestione degli errori
*      IF edocuf_failed IS NOT INITIAL.
*
*        RETURN.
*      ENDIF.
      IF no_commit = abap_false.
        COMMIT ENTITIES.
      ENDIF.
*      " Messaggio di successo
*      APPEND VALUE #( %msg = new_message_with_text(
*                       severity = if_abap_behv_message=>severity-success
*                       text     = 'Document created successfully in OCRA Edocument'
*                     ) ) TO edocuf_reported-EdocumentFile.
    ENDLOOP.


  ENDMETHOD.

  METHOD edoc_save_2_db.


    CHECK me->severity NE if_abap_behv_message=>severity-error.

    me->no_commit = no_commit.
    save_entity_buffer( ).
    save_entity_edocufile( ).
    save_entity_edocument( ).

  ENDMETHOD.



  METHOD a_unit_test.
    me->data_init_for_test(  ).
  ENDMETHOD.
  METHOD a_post.


    me->edocument-zunique_value = me->edoc_guid.
    me->edocument-status = 2. " xml postato in SAP
    me->edocument-statusdescr = 'xml postato in SAP'.
    APPEND me->edocument TO edocument_t.
    no_commit = abap_true.
    me->update_entity_edocument( ).


  ENDMETHOD.

  METHOD data_update.

    me->edocflow = edocflow.
    me->edoc_guid = edoc_guid.

*    SELECT SINGLE * FROM zedoc_db WHERE edocflow = @edocflow and unique_value = @me->edoc_guid INTO @me->buffer .
*    CHECK sy-subrc = 0.
    SELECT SINGLE * FROM zoe_edocument  WHERE zunique_value = @me->edoc_guid INTO @me->edocument.
*    SELECT SINGLE * FROM zoe_edocfile  WHERE file_guid = @me->edocument-file_guid INTO @me->edocumentfile.

*    me->file_guid  = me->edocumentfile-file_guid.
*    me->filename = me->edocumentfile-filename.
*    me->xcontent = me->buffer-xmldata.

  ENDMETHOD.


  METHOD data_init.

    me->edocflow = edocflow.
    me->xmlcontentraw = content.
    me->xcontent = xcontent.
    me->filename = filename.
    me->edoc_guid = edoc_guid.
    me->invoice = invoice.
    me->parent_edoc_guid = parent_edoc_guid.

    TRY.
        DATA(unique_value) = cl_system_uuid=>create_uuid_c36_static( )  .
      CATCH  cx_uuid_error .
        me->file_guid  = me->edoc_guid .
    ENDTRY.

    me->edoc_guid = unique_value.



  ENDMETHOD.

  METHOD  data_init_for_test.

    DELETE FROM zedoc_db.
    DELETE FROM zoe_edocument.
    DELETE FROM zoe_edocfile.
    DELETE FROM zoe_staging_file .



    DATA flow TYPE TABLE OF zedoc_flow.
    DATA group TYPE TABLE OF zedocgroup_db.

*    group  = VALUE #( (    edocgroup = 'INBOUND'  groupdescr = 'INCOMING INVOICES' )
*                           (  edocgroup = 'OUTBOUND'  groupdescr = 'OUTGOING INVOICES' ) ).
*
*    flow  = VALUE #( (    edocgroup = 'INBOUND'  edocflow = 'EDOCI' edocflowdescr = 'EDOCUMENT SUPPLIER INVOICE' )
*                        (  edocgroup = 'OUTBOUND'  edocflow = 'EDOCO' edocflowdescr = 'EDOCUMENT CUSTOMER INVOICE' ) ).
*
*    DELETE FROM zedocgroup_db.
*    DELETE FROM zedoc_flow.
*
*    MODIFY zedocgroup_db  FROM TABLE @group.
*    MODIFY zedoc_flow FROM TABLE @flow.

*** dummy xml ***

    me->xmlcontentraw = me->get_content_dummy(  ).
    DO 1 TIMES.
      me->filename  = 'artemest-passivo-unit-test_' && sy-index && '.xml'.
      CONDENSE  me->filename NO-GAPS.
      me->execute_action( 'CREATE' ).
    ENDDO.
  ENDMETHOD.

  METHOD xml_2_buffer.
    DATA ls_data TYPE zedoc_db.


    GET TIME STAMP FIELD DATA(tmstp).

    ls_data  = VALUE #( edocflow = me->edocflow   unique_value = me->edocumentfile-zunique_value
                  mimetypexml = me->edocumentfile-mimetypexml
                  xmldata = me->edocumentfile-xmldata
                  file_sraw = me->edocumentfile-file_sraw
                  filename = me->edocumentfile-filename
                  mimetypepdf = me->edocumentfile-mimetypepdf
                  pdfdata = me->edocumentfile-pdfdata
                  filenamepdf = me->edocumentfile-filenamepdf
                  mimetypezip = me->edocumentfile-mimetypezip
                  zipdata = me->edocumentfile-zipdata
                  filenamezip = me->edocumentfile-filenamezip
                  ernam = sy-uname erdat = sy-datum erzet = sy-uzeit tmstp = tmstp ).


    " COMMIT WORK..

    me->buffer = ls_data.

  ENDMETHOD.


  METHOD execute_action.


    CASE  iv_action.
      WHEN 'CREATE_FROM_REST_STAGING' OR 'CREATE_FROM_REST'  OR 'CREATE_PDF' OR 'CREATE_ZIP'.

        IF iv_action CS 'STAGING'. me->no_commit = abap_true. ENDIF.

        IF iv_action CS 'REST'. me->xml = abap_true. ENDIF.
        IF iv_action CS 'PDF'. me->pdf = abap_true. ENDIF.
        IF iv_action CS 'ZIP'. me->zip = abap_true. ENDIF.

        CASE me->edocflow.
          WHEN 'EDOCI'.
            a_create_from_rest(  ).
          WHEN 'EDOCO'.
            a_create_from_rest_out( ).
        ENDCASE.
      WHEN 'CREATE'.
        a_create( ).
      WHEN 'POST_FROM_STAGING'.
*        me->edocflow = 'EDOCI'.
        a_create_from_staging( ).
      WHEN 'IV_POST'  .
        a_post( ).
      WHEN 'CREATE_UNIT_TEST'.
        a_unit_test( ).

    ENDCASE.


  ENDMETHOD.
ENDCLASS.
