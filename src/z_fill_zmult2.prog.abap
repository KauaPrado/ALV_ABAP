*&---------------------------------------------------------------------*
*& Report Z_FILL_ZMULT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_fill_zmult2.

TABLES: zmulti.

* Declaração da tabela interna e estrutura
TYPES: BEGIN OF ty_zmulti,
         cidade     TYPE zmulti-cidade,
         multiplica TYPE zmulti-multiplica,
       END OF ty_zmulti.

DATA: it_zmulti TYPE TABLE OF ty_zmulti,
      wa_zmulti TYPE ty_zmulti.

* Populando a tabela interna com valores previamente cadastrados
INITIALIZATION.
  wa_zmulti-cidade = 'SINGAPORE'.
  wa_zmulti-multiplica = 7.
  APPEND wa_zmulti TO it_zmulti.

  INITIALIZATION.
  wa_zmulti-cidade = 'TOKYO'.
  wa_zmulti-multiplica = 7.
  APPEND wa_zmulti TO it_zmulti.

  INITIALIZATION.
  wa_zmulti-cidade = 'NEW YORK'.
  wa_zmulti-multiplica = 7.
  APPEND wa_zmulti TO it_zmulti.

INITIALIZATION.
  wa_zmulti-cidade = 'ROME'.
  wa_zmulti-multiplica = 13.
  APPEND wa_zmulti TO it_zmulti.

START-OF-SELECTION.
  " Remover todos os registros da tabela zmulti
  DELETE FROM zmulti.

  LOOP AT it_zmulti INTO wa_zmulti.
    INSERT INTO zmulti VALUES wa_zmulti.
  ENDLOOP.
