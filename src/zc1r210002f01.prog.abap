*&---------------------------------------------------------------------*
*& Include          ZC1R210002F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  CLEAR: gs_mara, gt_mara.

  SELECT a~matnr a~mtart a~matkl a~meins a~tragr
         b~pstat b~dismm b~ekgrp
    FROM       mara AS a
    INNER JOIN marc AS b
            ON a~matnr = b~matnr
    INTO CORRESPONDING FIELDS OF TABLE gt_mara
    WHERE b~werks = pa_wer
      AND a~matnr IN so_mat
      AND a~mtart IN so_mta
      AND b~ekgrp IN so_ekg.

  IF sy-subrc NE 0.
    MESSAGE s001.
    STOP.
  ENDIF.

ENDFORM.
