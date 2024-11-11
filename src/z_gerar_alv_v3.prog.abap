*&---------------------------------------------------------------------*
*& Report Z_GERAR_ALV_V3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_gerar_alv_v3.



TYPES: BEGIN OF ty_estrutura,
         mandt        TYPE spfli-mandt,
         carrid       TYPE spfli-carrid,
         connid       TYPE spfli-connid,
         countryfr    TYPE spfli-countryfr,
         cityfrom     TYPE spfli-cityfrom,
         airpfrom     TYPE spfli-airpfrom,
         countryto    TYPE spfli-countryto,
         cityto       TYPE spfli-cityto,
         airpto       TYPE spfli-airpto,
         fltime       TYPE spfli-fltime,
         deptime      TYPE spfli-deptime,
         arrtime      TYPE spfli-arrtime,
         distance     TYPE spfli-distance,
         distid       TYPE spfli-distid,
         fltype       TYPE spfli-fltype,
         period       TYPE spfli-period,
         carrname     TYPE scarr-carrname,
         fldate       TYPE sflight-fldate,
         price        TYPE sflight-price,
         currency     TYPE sflight-currency,
         planetype    TYPE sflight-planetype,
         seatsmax     TYPE sflight-seatsmax,
         seatsocc     TYPE sflight-seatsocc,
         paymentsum   TYPE sflight-paymentsum,
         seatsmax_b   TYPE sflight-seatsmax_b,
         seatsocc_b   TYPE sflight-seatsocc_b,
         seatsmax_f   TYPE sflight-seatsmax_f,
         seatsocc_f   TYPE sflight-seatsocc_f,
         multiplicado TYPE char1,
         apt_origem   TYPE sairport-name,
         apt_destino  TYPE sairport-name,
       END OF ty_estrutura.

DATA: it_estrutura TYPE TABLE OF ty_estrutura,
      wa_estrutura TYPE ty_estrutura.


DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.




DATA wa_spfli TYPE spfli.

DATA wa_sflight TYPE sflight.


DATA: it_multiplica TYPE TABLE OF zmulti,
      wa_multiplica TYPE zmulti.


SELECT-OPTIONS: countr FOR wa_spfli-countryfr,
                cityfrom FOR wa_spfli-cityfrom,
                fldate   FOR wa_sflight-fldate.

START-OF-SELECTION.
  PERFORM zf_seleciona_dados.

  PERFORM zf_processa_dados.



  PERFORM zf_monta_alv.

FORM zf_seleciona_dados.

  SELECT * FROM zmulti INTO TABLE it_multiplica.

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

ENDFORM.

FORM zf_processa_dados.
  LOOP AT it_estrutura INTO wa_estrutura.

    CALL FUNCTION 'ZF_AEROPORTO'
      EXPORTING
        airpfrom    = wa_estrutura-airpfrom
        airpto      = wa_estrutura-airpfrom
      IMPORTING
        apt_origem  = wa_estrutura-apt_origem
        apt_destino = wa_estrutura-apt_destino.




    READ TABLE it_multiplica INTO wa_multiplica WITH KEY cidade = wa_estrutura-cityfrom.
    IF sy-subrc = 0.

      wa_estrutura-price = wa_estrutura-price * wa_multiplica-multiplica.
      wa_estrutura-multiplicado ='x'.
      MODIFY it_estrutura FROM wa_estrutura.

    ENDIF.
  ENDLOOP.
ENDFORM.

FORM zf_monta_fieldcat USING i_fieldname TYPE c
                             i_text TYPE c.
  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = i_fieldname.
  wa_fieldcat-seltext_m = i_text  .
  APPEND wa_fieldcat TO it_fieldcat.

ENDFORM.
FORM zf_monta_alv.

  PERFORM zf_monta_fieldcat USING 'MANDT' 'Cliente'.
  PERFORM zf_monta_fieldcat USING 'CARRID' 'ID da companhia áerea'.
  PERFORM zf_monta_fieldcat USING 'CONNID' 'ID do voo'.
  PERFORM zf_monta_fieldcat USING 'COUNTRYFR' 'País de origem'.
  PERFORM zf_monta_fieldcat USING 'CITYFROM' 'Cidade de origem'.
  PERFORM zf_monta_fieldcat USING 'AIRPFROM' 'Aeroporto de origem'.
  PERFORM zf_monta_fieldcat USING 'COUNTRYTO' 'País de destino'.
  PERFORM zf_monta_fieldcat USING 'CITYTO' 'Cidade de destino'.
  PERFORM zf_monta_fieldcat USING 'AIRPTO' 'Aeroporto de destino'.
  PERFORM zf_monta_fieldcat USING 'FLTIME' 'Tempo de voo'.
  PERFORM zf_monta_fieldcat USING 'DEPTIME' 'Hora de partida'.
  PERFORM zf_monta_fieldcat USING 'ARRTIME' 'Hora de chegada'.
  PERFORM zf_monta_fieldcat USING 'DISTANCE' 'Distância'.
  PERFORM zf_monta_fieldcat USING 'DISTID' 'Unidade de medida'.
  PERFORM zf_monta_fieldcat USING 'FLTYPE' 'Tipo de voo'.
  PERFORM zf_monta_fieldcat USING 'PERIOD' 'Período do voo'.
  PERFORM zf_monta_fieldcat USING 'CARRNAME' 'Nome da companhia aérea'.
  PERFORM zf_monta_fieldcat USING 'FLDATE' 'Data do voo'.
  PERFORM zf_monta_fieldcat USING 'PRICE' 'Preço'.
  PERFORM zf_monta_fieldcat USING 'CURRENCY' 'Moeda'.
  PERFORM zf_monta_fieldcat USING 'PLANETYPE' 'Tipo de aeronave'.
  PERFORM zf_monta_fieldcat USING 'SEATSMAX' 'Assentos máximos'.
  PERFORM zf_monta_fieldcat USING 'SEATSOCC' 'Assentos ocupados'.
  PERFORM zf_monta_fieldcat USING 'PAYMENTSUM' 'Soma dos pagamentos'.
  PERFORM zf_monta_fieldcat USING 'SEATSMAX_B' 'Assentos máximos (econômica'.
  PERFORM zf_monta_fieldcat USING 'SEATSOCC_B' 'Assentos ocupados (econômica)'.
  PERFORM zf_monta_fieldcat USING 'SEATSMAX_F' 'Assentos máximos (primeira classe)'.
  PERFORM zf_monta_fieldcat USING 'SEATSOCC_F' 'Assentos ocupados (primeira classe)'.
  PERFORM zf_monta_fieldcat USING 'MULTIPLICADO' 'MULTIPLICADO'.
  PERFORM zf_monta_fieldcat USING 'APT_ORIGEM' 'Aeroporto de origem'.
  PERFORM zf_monta_fieldcat USING 'APT_DESTINO' 'Aeroporto de destino'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat = it_fieldcat
    TABLES
      t_outtab    = it_estrutura
    EXCEPTIONS
      OTHERS      = 1.

ENDFORM.
