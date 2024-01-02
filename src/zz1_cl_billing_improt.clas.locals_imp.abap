CLASS lhc_zz1_i_billing_improt DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zz1_i_billing_improt RESULT result.

    METHODS change_xblnr_determination FOR DETERMINE ON SAVE
      IMPORTING keys FOR zz1_i_billing_improt~change_xblnr_determination.

ENDCLASS.

CLASS lhc_zz1_i_billing_improt IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD change_xblnr_determination.
    DATA lt_billing_imp TYPE TABLE FOR UPDATE ZZ1_I_BILLING_IMPROT.
    DATA lwa_billing_imp  TYPE STRUCTURE FOR UPDATE ZZ1_I_BILLING_IMPROT.
    DATA t_del TYPE TABLE FOR UPDATE ZZ1_I_BILLING_IMPROT.
    DATA t_del2 TYPE STANDARD TABLE OF ZZ1_I_BILLING_IMPROT.
    DATA t_billing TYPE STANDARD TABLE OF zz1_i_order_billing.
    DATA wa_billing LIKE LINE OF t_billing.
    DATA t_billing2 TYPE STANDARD TABLE OF zz1_i_order_billing.

    DATA: wa_acc TYPE i_journalentry,
          t_acc  TYPE STANDARD TABLE OF i_journalentry.

    DATA: lt_je              TYPE TABLE FOR ACTION IMPORT i_journalentrytp~change,
          lwa_je             TYPE STRUCTURE FOR ACTION IMPORT i_journalentrytp~change,
          lv_cid             TYPE abp_behv_cid,
          lwa_header_control LIKE lwa_je-%param-%control..

    SELECT * FROM ZZ1_I_BILLING_IMPROT INTO CORRESPONDING FIELDS OF TABLE @t_del.
    MOVE-CORRESPONDING t_del TO t_del2.
    LOOP AT t_del INTO DATA(wa_del).
      MODIFY ENTITIES OF ZZ1_I_BILLING_IMPROT IN LOCAL MODE
      ENTITY ZZ1_I_BILLING_IMPROT DELETE FROM VALUE #( ( billing_uuid = wa_del-billing_uuid ) ).
    ENDLOOP.

    READ ENTITIES OF ZZ1_I_BILLING_IMPROT IN LOCAL MODE
        ENTITY ZZ1_I_BILLING_IMPROT
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_result)
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).
    SELECT * FROM zz1_i_order_billing INTO CORRESPONDING FIELDS OF TABLE @t_billing .
    SORT t_billing BY billingdocument billingdocumentitem ASCENDING.
    LOOP AT lt_result INTO DATA(lwa_result).
      t_billing2 = t_billing.
      DELETE t_billing2 WHERE billingdocument NE lwa_result-billing_id.
      CLEAR lwa_billing_imp.
      MODIFY ENTITIES OF i_billingdocumenttp
      ENTITY billingdocument
         UPDATE FROM VALUE #( ( %key-billingdocument = lwa_result-billing_id
                                yy1_xblnr_bdh = lwa_result-xblnr
                                %control-yy1_xblnr_bdh = if_abap_behv=>mk-on
                            ) )
      REPORTED DATA(ls_reported_modify)
      MAPPED DATA(ls_mapped)
      FAILED   DATA(ls_failed_modify).

      lwa_billing_imp = CORRESPONDING #( lwa_result ).
      CLEAR wa_billing.
      READ TABLE t_billing2 INTO wa_billing INDEX 1.
      lwa_billing_imp-reference = wa_billing-purchaseorderbycustomer.
      IF ls_failed_modify IS NOT INITIAL.
        "wa_test = CORRESPONDING #( lwa_test2 ).
        lwa_billing_imp-status = 'E'.
        lwa_billing_imp-message = ls_failed_modify-billingdocument[ 1 ]-%fail-cause.
      ELSE.
        lwa_billing_imp-status = 'S'.
      ENDIF.

      CLEAR: t_acc, lwa_header_control, lt_je, lwa_je.
      SELECT * FROM zz1_i_journalentry
       WHERE referencedocumenttype = 'VBRK' AND originalreferencedocument = @lwa_result-billing_id
       INTO CORRESPONDING FIELDS OF TABLE @t_acc.
      CLEAR: wa_acc .
      READ TABLE t_acc INTO wa_acc INDEX 1.
      IF  sy-subrc = 0.
* Header Control
        lwa_header_control-documentreferenceid          = if_abap_behv=>mk-on.

        lwa_je-accountingdocument = wa_acc-accountingdocument.
        lwa_je-fiscalyear         = wa_acc-fiscalyear.
        lwa_je-companycode        = wa_acc-companycode.
        lwa_je-%param = VALUE #(  documentreferenceid          = lwa_result-xblnr
            %control                     =  lwa_header_control
         ).
        APPEND lwa_je TO lt_je.

        MODIFY ENTITIES OF i_journalentrytp
         ENTITY journalentry
         EXECUTE change FROM lt_je
           FAILED DATA(ls_failed_deep)
           REPORTED DATA(ls_reported_deep)
           MAPPED DATA(ls_mapped_deep).
        IF ls_failed_deep IS NOT INITIAL.
          lwa_billing_imp-status = 'E'.
          lwa_billing_imp-message = ls_failed_deep-journalentry[ 1 ]-%fail-cause.
        ELSE.

        ENDIF.

      ENDIF.
      APPEND lwa_billing_imp TO lt_billing_imp.

    ENDLOOP.

    MODIFY ENTITIES OF ZZ1_I_BILLING_IMPROT IN LOCAL MODE
    ENTITY ZZ1_I_BILLING_IMPROT UPDATE SET FIELDS WITH lt_billing_imp
    MAPPED DATA(lt_mapp_mod)
    FAILED DATA(failed_mod)
    REPORTED DATA(report_mod).
  ENDMETHOD.

ENDCLASS.
