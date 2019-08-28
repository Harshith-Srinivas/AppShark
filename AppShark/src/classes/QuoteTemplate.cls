public class QuoteTemplate {
    public String OfficeAddress{get; set;}
    public List<QuoteLineItem> QuoteLinItem{get;set;}
    
    public QuoteTemplate(ApexPages.StandardController stdController)
    {
        OfficeAddress = '13601 Preston Rd #400W, Dallas, TX 75240';
        QuoteLinItem = [Select ID, Product2.Name, ListPrice, UnitPrice, Quantity, TotalPrice,QuoteID  from QuoteLineItem where QuoteID = :ApexPages.currentPage().getParameters().get('id')];
        system.debug('-->'+QuoteLinItem);    
    }   
}