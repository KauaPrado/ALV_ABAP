*&---------------------------------------------------------------------*
*& Report Z_GERAR_NOVO_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_gerar_novo_alv.

TYPES: BEGIN OF ty_estrutura,
         mandt  TYPE spfli-mandt,
         carrid TYPE spfli-carrid,
         connid TYPE spfli-connid,
       END OF ty_estrutura.

DATA: it_estrutura TYPE TABLE OF ty_estrutura,
      wa_estrutura TYPE ty_estrutura.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.

START-OF-SELECTION.
select mandt, carrid, connid from spfli into table @it_estrutura.

CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = ' MANDT'.
  wa_fieldcat-seltext_m = ' mandante ' .
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = ' CARRID '.
  wa_fieldcat-seltext_m = ' CARRID ' .
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = ' CONNID '.
  wa_fieldcat-seltext_m = ' CONNID ' .
  APPEND wa_fieldcat TO it_fieldcat.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat = it_fieldcat
    TABLES
      t_outtab    = it_estrutura
    EXCEPTIONS
      OTHERS      = 1.
