@EndUserText.label: 'Billing 夥伴地址'
@AbapCatalog:{ sqlViewName:'ZZ1_I_B_ADDRESS' }
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view ZZ1_I_billing_partner_address  as select from I_BillingDocumentPartnerBasic as Partner
{
                                                                            
      //--[ GENERATED:012:GlBfhyJl7kY4v5RWfCiSf0
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_BillingDocumentBasicStdVH',
                     element: 'BillingDocument' }
        }]
      // ]--GENERATED

  key BillingDocument,

  key Partner.PartnerFunction,

      Partner.Customer,

      Partner.Supplier,

      Partner.Personnel,
      Partner.AddressID,
      
      Partner._DfltAddrRprstn.OrganizationName1
      //Association
}
