*&---------------------------------------------------------------------*
*& Include          ZC1R210007_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_100 INPUT.

  gcl_grid->free( ).
  gcl_con->free( ).
  FREE : gcl_grid, gcl_con.

  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE gv_okcode.
    WHEN 'SAVE'.
      CLEAR gv_okcode.
      PERFORM save.
  ENDCASE.

  CASE gv_okcode.
    WHEN 'CREATE'.
      CLEAR gv_okcode.
      PERFORM create_row.

    WHEN 'DELETE'.
      CLEAR gv_okcode.
      PERFORM delete_row.

  ENDCASE.

ENDMODULE.
