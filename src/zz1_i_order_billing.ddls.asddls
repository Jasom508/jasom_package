@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '讀取訂單客戶參考供轉檔使用'
define root view entity ZZ1_I_order_billing  as select from I_BillingDocumentItemBasic as a
inner join I_SalesDocument as b on a.SalesDocument = b.SalesDocument
{
   key  a.BillingDocument,
        a.BillingDocumentItem,
        b.PurchaseOrderByCustomer
}
