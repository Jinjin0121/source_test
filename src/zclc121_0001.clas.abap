class ZCLC121_0001 definition
  public
  final
  create public .

public section.

  methods GET_AIRLINE_INFO
    importing
      !PI_CARRID type SCARR-CARRID
    exporting
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100
    changing
      !ET_AIRLINE type ZC1TT21001 .
protected section.
private section.
ENDCLASS.



CLASS ZCLC121_0001 IMPLEMENTATION.


  method GET_AIRLINE_INFO.

    IF pi_carrid is INITIAL.
      pe_code = 'E'.
      pe_msg  = TEXT-e01.
      EXIT.
      endif.

      select carrid carrname currcode url
        INTO CORRESPONDING FIELDS OF TABLE et_airline
        FROM scarr
        WHERE carrid = pi_carrid.

        if sy-subrc = 0.
          pe_code = 'E'.
          pe_msg = text-e02.
          EXIT.

          else.
            pe_code = 'S'.
            endif.
  endmethod.
ENDCLASS.
