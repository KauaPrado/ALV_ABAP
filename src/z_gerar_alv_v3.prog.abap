
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


DATA: go_alv        TYPE REF TO cl_salv_table.
DATA: lr_columns    TYPE REF TO cl_salv_columns_table.
DATA: lr_column     TYPE REF TO cl_salv_column_table.
DATA: lr_functions  TYPE REF TO cl_salv_functions_list.
DATA: gr_display    TYPE REF TO cl_salv_display_settings.
DATA cx_salv      TYPE REF TO cx_salv_msg.
DATA cx_not_found TYPE REF TO cx_salv_not_found.
data gr_msg  type string.


DATA wa_spfli TYPE spfli.

DATA wa_sflight TYPE sflight.


DATA: it_multiplica TYPE TABLE OF zmulti,
      wa_multiplica TYPE zmulti.

PARAMETERS: p1 RADIOBUTTON GROUP grp1 DEFAULT 'X',
            p2 RADIOBUTTON GROUP grp1.

SELECTION-SCREEN COMMENT /1(20) text_001 FOR FIELD p1.
SELECTION-SCREEN COMMENT /1(20) text_002 FOR FIELD p2.

INITIALIZATION.
  text_001 = 'p1 - Fluxo Origina'.
  text_002 = '02- Fluxo OO'.


  SELECT-OPTIONS: countr FOR wa_spfli-countryfr,
                  cityfrom FOR wa_spfli-cityfrom,
                  fldate   FOR wa_sflight-fldate.


START-OF-SELECTION.

  PERFORM zf_seleciona_dados.

  PERFORM zf_processa_dados.

  IF p1 = 'X'.

    PERFORM zf_monta_alv_original.
  ELSEIF p2 = 'X'.
    PERFORM zf_monta_alv_oo.
  ENDIF.



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
        id_airp   = wa_estrutura-airpfrom
      IMPORTING
        nome_airp = wa_estrutura-apt_origem.

    CALL FUNCTION 'ZF_AEROPORTO'
      EXPORTING
        id_airp   = wa_estrutura-airpto
      IMPORTING
        nome_airp = wa_estrutura-apt_destino.




    READ TABLE it_multiplica INTO wa_multiplica WITH KEY cidade = wa_estrutura-cityfrom.
    IF sy-subrc = 0.

      wa_estrutura-price = wa_estrutura-price * wa_multiplica-multiplica.
      wa_estrutura-multiplicado ='x'.

    ENDIF.
    MODIFY it_estrutura FROM wa_estrutura.
  ENDLOOP.
ENDFORM.

FORM zf_monta_fieldcat USING i_fieldname TYPE c
                             i_text TYPE c.
  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = i_fieldname.
  wa_fieldcat-seltext_m = i_text  .
  APPEND wa_fieldcat TO it_fieldcat.

ENDFORM.
FORM zf_monta_alv_original.

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
FORM zf_monta_alv_oo.

  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = it_estrutura ). "Internal Table

    CATCH cx_salv_msg.
      gr_msg = cx_salv->get_text( ).
      message gr_msg type 'E'.
  ENDTRY.

  TRY.
      lr_columns ?= go_alv->get_columns( ).
      lr_column  ?= lr_columns->get_column( 'MANDT' ).
      lr_column->set_long_text( 'MANDANTE' ).

      lr_column  ?= lr_columns->get_column('CONNID').
      lr_column->set_long_text( 'ID do voo' ).
      lr_column  ?= lr_columns->get_column( 'COUNTRYFR' ).
      lr_column->set_long_text( 'País de origem' ).
      lr_column  ?= lr_columns->get_column( 'CITYFROM' ).
      lr_column->set_long_text( 'Cidade de origem' ).
      lr_column  ?= lr_columns->get_column( 'AIRPFROM' ).
      lr_column->set_long_text( 'Aeroporto de origem' ).
      lr_column  ?= lr_columns->get_column( 'COUNTRYTO' ).
      lr_column->set_long_text( 'País de destino' ).
      lr_column  ?= lr_columns->get_column( 'CITYTO' ).
      lr_column->set_long_text( 'Cidade de destino' ).
      lr_column  ?= lr_columns->get_column( 'AIRPTO' ).
      lr_column->set_long_text( 'Aeroporto de destino' ).
      lr_column  ?= lr_columns->get_column( 'FLTIME' ).
      lr_column->set_long_text( 'Tempo de voo' ).
      lr_column  ?= lr_columns->get_column( 'DEPTIME' ).
      lr_column->set_long_text( 'Hora de partida' ).
      lr_column  ?= lr_columns->get_column( 'ARRTIME' ).
      lr_column->set_long_text( 'Hora de chegada' ).
      lr_column  ?= lr_columns->get_column( 'DISTANCE' ).
      lr_column->set_long_text( 'Distância' ).
      lr_column  ?= lr_columns->get_column( 'DISTID' ).
      lr_column->set_long_text( 'Unidade de medida' ).
      lr_column  ?= lr_columns->get_column( 'FLTYPE' ).
      lr_column->set_long_text( 'Tipo de voo' ).
      lr_column  ?= lr_columns->get_column( 'PERIOD' ).
      lr_column->set_long_text( 'Período do voo' ).
      lr_column  ?= lr_columns->get_column( 'CARRNAME' ).
      lr_column->set_long_text( 'Nome da companhia aérea' ).
      lr_column  ?= lr_columns->get_column( 'FLDATE' ).
      lr_column->set_long_text( 'Data do voo' ).
      lr_column  ?= lr_columns->get_column( 'PRICE' ).
      lr_column->set_long_text( 'Preco' ).
      lr_column  ?= lr_columns->get_column( 'CURRENCY' ).
      lr_column->set_long_text( 'Moeda' ).
      lr_column  ?= lr_columns->get_column( 'PLANETYPE' ).
      lr_column->set_long_text( 'Tipo de aeronave' ).
      lr_column  ?= lr_columns->get_column( 'SEATSMAX' ).
      lr_column->set_long_text( 'Assentos máximos' ).
      lr_column  ?= lr_columns->get_column( 'SEATSOCC' ).
      lr_column->set_long_text( 'Assentos ocupados' ).
      lr_column  ?= lr_columns->get_column( 'PAYMENTSUM' ).
      lr_column->set_long_text( 'Soma dos pagamentos' ).
      lr_column  ?= lr_columns->get_column( 'SEATSMAX_B' ).
*      lr_column->set_long_text( 'Assentos máximos (econômica)' ).
*      lr_column  ?= lr_columns->get_column( 'Assentos máximos (econômica' ).
*      lr_column->set_long_text( 'Assentos ocupados (econômica)' ).
*      lr_column  ?= lr_columns->get_column( 'SEATSMAX_F' ).
*      lr_column->set_long_text( 'Assentos máximos (primeira classe)' ).
*      lr_column  ?= lr_columns->get_column( 'SEATSOCC_F' ).
*      lr_column->set_long_text( 'Assentos ocupados (primeira classe)' ).
*      lr_column  ?= lr_columns->get_column( 'MULTIPLICADO' ).
*      lr_column->set_long_text( 'MULTIPLICADO' ).
*      lr_column  ?= lr_columns->get_column( 'APT_ORIGEM' ).
*      lr_column->set_long_text( 'Aeroporto de origem' ).
*      lr_column  ?= lr_columns->get_column( 'APT_DESTINO' ).
*      lr_column->set_long_text( 'Aeroporto de destino' ).

    CATCH  cx_salv_msg INTO cx_salv.
      gr_msg = cx_salv->get_text( ).
      message gr_msg type 'E'.
    catch  cx_salv_not_found into cx_not_found.
       gr_msg = cx_not_found->get_text( ).
      message gr_msg type 'E'.
  ENDTRY.

  go_alv->display( ).


ENDFORM.
