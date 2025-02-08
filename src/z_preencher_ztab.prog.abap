*&---------------------------------------------------------------------*
*& Report Z_PREENCHER_ZTAB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_preencher_ztab.

TYPES: BEGIN OF ty_estrutura,
         mandt  TYPE spfli-mandt,
         carrid TYPE spfli-carrid,
         connid TYPE spfli-connid,
       END OF ty_estrutura.

DATA: it_estrutura TYPE TABLE OF ty_estrutura,
      wa_estrutura TYPE ty_estrutura.

START-OF-SELECTION.

select mandt, carrid, connid INTO TABLE @it_estrutura
  FROM spfli.

  LOOP AT it_estrutura into wa_estrutura.
    INSERT into ztab values wa_estrutura.

  ENDLOOP.
