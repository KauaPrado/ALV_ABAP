*&---------------------------------------------------------------------**
*& Report Z_NOVOALV
*&---------------------------------------------------------------------**
*&
*&---------------------------------------------------------------------*
REPORT z_novoalv.


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
      lt_fieldcat  TYPE slis_t_fieldcat_alv,
      ls_fieldcat  TYPE slis_fieldcat_alv.



TYPES: BEGIN OF ty_multiplica,
         cidade     TYPE char25,
         multiplica TYPE i,
       END OF ty_multiplica.

DATA: it_multiplica TYPE TABLE OF ty_multiplica,
      wa_multiplica TYPE ty_multiplica.


wa_multiplica-cidade = 'ROME'.
wa_multiplica-multiplica = 1.
APPEND wa_multiplica TO it_multiplica.

wa_multiplica-cidade = 'TOKYO'.
wa_multiplica-multiplica = 3.
APPEND wa_multiplica TO it_multiplica.








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

  LOOP AT it_estrutura INTO wa_estrutura.
    READ TABLE it_multiplica INTO wa_multiplica WITH KEY cidade = wa_estrutura-cityfrom.
    IF sy-subrc = 0.
      wa_estrutura-price = wa_estrutura-price * wa_multiplica-multiplica.
      MODIFY it_estrutura FROM wa_estrutura.
    ENDIF.

  ENDLOOP.


  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'MANDT'.
  ls_fieldcat-seltext_m = 'Cliente'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CARRID'.
  ls_fieldcat-seltext_m = 'ID da companhia aérea'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CONNID'.
  ls_fieldcat-seltext_m = 'ID do voo'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'COUNTRYFR'.
  ls_fieldcat-seltext_m = 'País de origem'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CITYFROM'.
  ls_fieldcat-seltext_m = 'Cidade de origem'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'AIRPFROM'.
  ls_fieldcat-seltext_m = 'Aeroporto de origem'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'COUNTRYTO'.
  ls_fieldcat-seltext_m = 'País de destino'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CITYTO'.
  ls_fieldcat-seltext_m = 'Cidade de destino'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'AIRPTO'.
  ls_fieldcat-seltext_m = 'Aeroporto de destino'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'FLTIME'.
  ls_fieldcat-seltext_m = 'Tempo de voo'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'DEPTIME'.
  ls_fieldcat-seltext_m = 'Hora de partida'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'ARRTIME'.
  ls_fieldcat-seltext_m = 'Hora de chegada'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'DISTANCE'.
  ls_fieldcat-seltext_m = 'Distância'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'DISTID'.
  ls_fieldcat-seltext_m = 'Unidade de medida '.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'FLTYPE'.
  ls_fieldcat-seltext_m = 'Tipo de voo'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'PERIOD'.
  ls_fieldcat-seltext_m = 'Período do voo'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CARRNAME'.
  ls_fieldcat-seltext_m = 'Nome da companhia aérea'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'FLDATE'.
  ls_fieldcat-seltext_m = 'Data do voo'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'PRICE'.
  ls_fieldcat-seltext_m = 'Preço'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CURRENCY'.
  ls_fieldcat-seltext_m = 'Moeda'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'PLANETYPE'.
  ls_fieldcat-seltext_m = 'Tipo de aeronave'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'SEATSMAX'.
  ls_fieldcat-seltext_m = 'Assentos máximos'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'SEATSOCC'.
  ls_fieldcat-seltext_m = 'Assentos ocupados'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'PAYMENTSUM'.
  ls_fieldcat-seltext_m = 'Soma dos pagamentos'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'SEATSMAX_B'.
  ls_fieldcat-seltext_m = 'Assentos máximos (econômica)'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'SEATSOCC_B'.
  ls_fieldcat-seltext_m = 'Assentos ocupados (econômica)'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'SEATSMAX_F'.
  ls_fieldcat-seltext_m = 'Assentos máximos (primeira classe)'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'SEATSOCC_F'.
  ls_fieldcat-seltext_m = 'Assentos ocupados (primeira classe)'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat = lt_fieldcat
    TABLES
      t_outtab    = it_estrutura
    EXCEPTIONS
      OTHERS      = 1.
