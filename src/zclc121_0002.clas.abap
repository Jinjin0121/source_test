class ZCLC121_0002 definition
  public
  final
  create public .

public section.

  methods GET_MAKT_TEXT
    importing
      !PI_MATNR type MAKT-MATNR
    exporting
      !PE_MAKTX type MAKT-MAKTX
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100 .
protected section.
private section.
ENDCLASS.



CLASS ZCLC121_0002 IMPLEMENTATION.


  METHOD get_makt_text.
if pi_matnr is INITIAL.
  pe_code = 'E'.
  ps_msg = text-e03.
  exit.
  endif.

    SELECT SINGLE maktx
      INTO pe_maktx
      FROM makt
      WHERE matnr = pi_matnr
        AND spras = sy-langu.

if sy-subrc ne 0.
  pe_code = 'E'.
  pe_msg = TEXT-e02.
  else.
    pe_code = 'S'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
