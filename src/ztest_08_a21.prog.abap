*&---------------------------------------------------------------------*
*& Report ZTEST_08_A21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_08_a21.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  PARAMETERS: pa_wer TYPE mkal-werks DEFAULT '1010',
              pa_ber TYPE pbid-berid DEFAULT '1010',
              pa_pbd TYPE pbid-pbdnr,
              pa_ver TYPE pbid-versb DEFAULT '00'.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.

  "유저 커멘드를 통해 이벤트 발생
  PARAMETERS: ra_crt  RADIOBUTTON GROUP rd_1 DEFAULT 'X' USER-COMMAND mod,
              ra_disp RADIOBUTTON GROUP rd_1.

SELECTION-SCREEN END OF BLOCK b2.

TABLES: mara, marc.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.

  SELECT-OPTIONS: so_manr  FOR  mara-matnr MODIF ID  mar,
                  so_mtrt  FOR  mara-mtart MODIF ID  mar,
                  so_makl  FOR  mara-matkl MODIF ID  mar,
                  so_ekrp  FOR  marc-ekgrp MODIF ID  mac.

  PARAMETERS : pa_dipo TYPE marc-dispo MODIF ID mac,
               pa_dimm TYPE marc-dismm MODIF ID  mac.

SELECTION-SCREEN END OF BLOCK b3.

AT SELECTION-SCREEN OUTPUT. "PBO
  PERFORM modify_screen.
*&---------------------------------------------------------------------*
*& Form modify_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_screen .

  " 스크린은 항상 루프를 타야한다.
  LOOP AT SCREEN.

    CASE screen-name.
      WHEN 'PA_PBD' OR 'PA_VER'.
        screen-input = 0.
        MODIFY SCREEN.
      WHEN OTHERS.
    ENDCASE.

    CASE 'X'.
      WHEN ra_crt.

        CASE screen-group1.
          WHEN 'MAC'.
            screen-active = 0.
            MODIFY SCREEN.
        ENDCASE.

     WHEN ra_disp.
        CASE screen-group1.
          WHEN 'MAR'.
            screen-active = 0.
            MODIFY SCREEN.
        ENDCASE.

    ENDCASE.

  ENDLOOP.
ENDFORM.
