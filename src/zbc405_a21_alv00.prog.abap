*&---------------------------------------------------------------------*
*& Report ZBC405_A21_ALV00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC405_A21_ALV00.

DATA gs_flt TYPE sflight.
DATA gt_flt TYPE TABLE OF sflight.
DATA ok__code LIKE sy-ucomm.

SELECT-OPTIONS: so_car FOR gs_flt-carrid MEMORY ID car,
                so_con FOR gs_flt-connid MEMORY ID con,
                so_dat FOR gs_flt-fldate.

START-OF-SELECTION.

  SELECT *
    FROM sflight
    INTO TABLE gt_flt
    WHERE carrid IN so_car AND
          connid IN so_con AND
          fldate IN so_dat.

  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
