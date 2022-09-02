*&---------------------------------------------------------------------*
*& Report ZBC401_A21_CL_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a21_cl_02.

INTERFACE inter_a21.

  DATA num1 TYPE i.
  DATA num2 TYPE i.

  "선언만 interface안에.. 구현은 class implementaion안에.
  METHODS imet1.

ENDINTERFACE.

CLASS cl1 DEFINITION.

  PUBLIC SECTION.

    INTERFACES inter_a21.

ENDCLASS.

CLASS cl1 IMPLEMENTATION.

  METHOD inter_a21~imet1.

    DATA rel TYPE i.
    rel = inter_a21~num1 + inter_a21~num2.

    WRITE : / 'reuslt + :', rel.
  ENDMETHOD.

ENDCLASS.

CLASS cl2 DEFINITION.

  PUBLIC SECTION.

    INTERFACES inter_a21.

ENDCLASS.

CLASS cl2 IMPLEMENTATION.

  METHOD inter_a21~imet1.

    DATA rel TYPE i.
    rel = inter_a21~num1 * inter_a21~num2.

    WRITE : / 'reuslt * :', rel.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA cl1obj TYPE REF TO cl1.

  CREATE OBJECT cl1obj.

  cl1obj->inter_a21~num1 = 10.
  cl1obj->inter_a21~num2 = 20.

  CALL METHOD cl1obj->inter_a21~imet1.

  DATA cl2obj TYPE REF TO cl2.

  CREATE OBJECT cl2obj.

  cl2obj->inter_a21~num1 = 10.
  cl2obj->inter_a21~num2 = 20.

  CALL METHOD cl2obj->inter_a21~imet1.
