@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: false
@EndUserText.label: 'Billing 客製欄位匯入程式 的Projection view'
@Search.searchable: true
@ObjectModel.semanticKey: [ 'billing_id' ]
@AbapCatalog.extensibility.extensible: true
define root view entity ZZ1_PV_BILLING_IMPROT  
 provider contract transactional_query as projection on ZZ1_I_BILLING_IMPROT
{
   @UI.hidden: true
    key billing_uuid,
     @UI: { lineItem:       [ { position: 10, importance: #HIGH } ],
           identification: [ { position: 10 } ] }
     @EndUserText.label: 'BILLING 單號'
     @Search.defaultSearchElement: true
     @UI.selectionField: [{ position: 10 }]
     billing_id,
    @UI: { lineItem:       [ { position: 20, importance: #HIGH } ],
           identification: [ { position: 20 } ] }
    @EndUserText.label: '客製參考欄位號碼'
    @UI.selectionField: [{ position: 20 }]
     xblnr,
    @UI: { lineItem:       [ { position: 30, importance: #HIGH } ],
           identification: [ { position: 30 } ] }
    @EndUserText.label: '客戶參考'
    @UI.selectionField: [{ position: 30 }]
     reference,
    @UI: { lineItem:       [ { position: 40, importance: #HIGH } ],
           identification: [ { position: 40 } ] }
    @EndUserText.label: '狀態'
    @UI.selectionField: [{ position: 40 }]
    status,
    @UI: { lineItem:       [ { position: 50, importance: #HIGH } ],
           identification: [ { position: 50 } ] }
    @EndUserText.label: '訊息'
    @UI.selectionField: [{ position: 50 }]
    message

}
