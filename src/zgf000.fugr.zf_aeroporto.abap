FUNCTION zf_aeroporto.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(ID_AIRP) TYPE  CHAR3
*"  EXPORTING
*"     REFERENCE(NOME_AIRP) TYPE  SAIRPORT-NAME
*"----------------------------------------------------------------------

  SELECT SINGLE name
  INTO nome_airp
    FROM sairport
    WHERE id = id_airp.


ENDFUNCTION.
