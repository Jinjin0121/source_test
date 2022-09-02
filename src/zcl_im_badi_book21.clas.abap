class ZCL_IM_BADI_BOOK21 definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_BOOK21 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BADI_BOOK21 IMPLEMENTATION.


  METHOD if_ex_badi_book21~change_vline.

c_pos = c_pos + 25.

  ENDMETHOD.


  method IF_EX_BADI_BOOK21~OUTPUT.

  DATA name TYPE s_custname.
  DATA odata TYPE s_bdate.
    SELECT SINGLE name
      FROM scustom
      INTO name
      WHERE id = i_booking-customid.

    WRITE : name ,i_booking-ORDER_DATE.

  endmethod.
ENDCLASS.
