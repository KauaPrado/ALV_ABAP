*&---------------------------------------------------------------------*
*& Report Z_NOVOALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_gerar_alv.

TABLES: spfli, scarr, sflight.

TYPES: BEGIN OF ty_estrutura,
         mandt      TYPE spfli-mandt,
         carrid     TYPE spfli-carrid,
         connid     TYPE spfli-connid,
         countryfr  TYPE spfli-countryfr,
         cityfrom   TYPE spfli-cityfrom,
         airpfrom   TYPE spfli-airpfrom,
         countryto  TYPE spfli-countryto,
         cityto     TYPE spfli-cityto,
         airpto     TYPE spfli-airpto,
         fltime     TYPE spfli-fltime,
         deptime    TYPE spfli-deptime,
         arrtime    TYPE spfli-arrtime,
         distance   TYPE spfli-distance,
         distid     TYPE spfli-distid,
         fltype     TYPE spfli-fltype,
         period     TYPE spfli-period,
         carrname   TYPE scarr-carrname,
         fldate     TYPE sflight-fldate,
         price      TYPE sflight-price,
         currency   TYPE sflight-currency,
         planetype  TYPE sflight-planetype,
         seatsmax   TYPE sflight-seatsmax,
         seatsocc   TYPE sflight-seatsocc,
         paymentsum TYPE sflight-paymentsum,
         seatsmax_b TYPE sflight-seatsmax_b,
         seatsocc_b TYPE sflight-seatsocc_b,
         seatsmax_f TYPE sflight-seatsmax_f,
         seatsocc_f TYPE sflight-seatsocc_f,
       END OF ty_estrutura.

DATA: it_estrutura TYPE TABLE OF ty_estrutura,
      wa_estrutura TYPE ty_estrutura,
      lo_alv       TYPE REF TO cl_salv_table.

START-OF-SELECTION.

  SELECT-OPTIONS: countr FOR spfli-countryfr,
                  cityfrom FOR spfli-cityfrom,
                  fldate   FOR sflight-fldate.

  SELECT a~mandt, a~carrid, a~connid, a~countryfr, a~cityfrom,
         a~airpfrom, a~countryto, a~cityto, a~airpto,
         a~fltime, a~deptime, a~arrtime, a~distance,
         a~distid, a~fltype, a~period,
         b~carrname, c~fldate, c~price, c~currency,
         c~planetype, c~seatsmax, c~seatsocc, c~paymentsum,
         c~seatsmax_b, c~seatsocc_b, c~seatsmax_f, c~seatsocc_f
    INTO TABLE @it_estrutura
    FROM spfli AS a
    INNER JOIN scarr AS b ON a~carrid = b~carrid
    INNER JOIN sflight AS c ON a~carrid = c~carrid AND a~connid = c~connid
    WHERE a~countryfr IN @countr
      AND a~cityfrom IN @cityfrom
      AND c~fldate IN @fldate.

  IF sy-subrc = 0.
    cl_salv_table=>factory( IMPORTING r_salv_table = lo_alv
                           CHANGING  t_table      = it_estrutura ).

    lo_alv->display( ).
  ELSE.
    WRITE: 'Nenhum dado encontrado para os critérios selecionados.'.
  ENDIF.
