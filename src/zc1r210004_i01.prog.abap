*&---------------------------------------------------------------------*
*& Include          ZC1R210004_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CALL METHOD : gcl_grid->free( ), gcl_container->free( ).

  FREE : gcl_grid, gcl_container.

  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_101 INPUT.

  call METHOD : gcl_grid_pop->free( ), gcl_container_pop->free( ).

  free : gcl_grid_pop.
LEAVE to SCREEN 0.
ENDMODULE.
