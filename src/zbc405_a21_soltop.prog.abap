*&---------------------------------------------------------------------*
*& Include ZBC405_A21_SOLTOP                        - Report ZBC405_A21_SOL
*&---------------------------------------------------------------------*
REPORT zbc405_a21_sol.

DATA gs_flight TYPE dv_flights.

SELECT-OPTIONS: so_car FOR gs_flight-carrid MEMORY ID car1,
                so_con FOR gs_flight-connid.

SELECT-OPTIONS so_fdt FOR gs_flight-fldate NO-EXTENSION.


SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME TITLE TEXT-t02.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 2(5) text-001.
    PARAMETERS pa_rad1 RADIOBUTTON GROUP rbg1.

    SELECTION-SCREEN COMMENT pos_low(8) text-002.
    PARAMETERS pa_rad2 RADIOBUTTON GROUP rbg1.

    SELECTION-SCREEN COMMENT pos_high(14) text-003.
    PARAMETERS pa_rad3 RADIOBUTTON GROUP rbg1 DEFAULT 'X'.

  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK radio.
