FUNCTION zf_aeroporto.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(AIRPFROM) TYPE  SPFLI-AIRPFROM
*"     REFERENCE(AIRPTO) TYPE  SPFLI-AIRPTO
*"  EXPORTING
*"     REFERENCE(APT_ORIGEM) TYPE  SAIRPORT-NAME
*"     REFERENCE(APT_DESTINO) TYPE  SAIRPORT-NAME
*"----------------------------------------------------------------------

   SELECT single name
   INTO apt_origem
     FROM sairport
     WHERE id = airpfrom.


SELECT single name
   INTO apt_destino
     FROM sairport
     WHERE id = airpfrom.




ENDFUNCTION.
