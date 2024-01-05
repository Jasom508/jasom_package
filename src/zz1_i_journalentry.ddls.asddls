@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'JOURNALENTRY'
@AbapCatalog.extensibility.extensible: true
define root view entity ZZ1_I_JOURNALENTRY
  as select from I_JournalEntry
{

  key  CompanyCode,

  key  FiscalYear,
  key  AccountingDocument,
       ReferenceDocumentType,
       OriginalReferenceDocument
}
