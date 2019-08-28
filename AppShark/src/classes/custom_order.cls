public  with sharing class custom_order {
   public String SelectedProduct{get;set;}
   public Decimal productPrice {get; set;}
   public String SelectedState{get; set;}
   public Decimal stateTax{get;set;}
   public Decimal dis;
   public Decimal discount {get; set;}
   public Decimal total{get; set;}
    
   public list<SelectOption> getListProductName()
    {
        List<SelectOption> listProdValues = new List<SelectOption>();
        for(Product__mdt p: [Select Product_Name__c from Product__mdt])
        {
            listProdValues.add(new SelectOption(p.Product_Name__c,p.Product_Name__c));
        }
        return listProdValues;
    }
    public void SelectedProductFunction()
    {
        Product__mdt valueofProd = [Select Price__c from Product__mdt where MasterLabel=:SelectedProduct];
        productPrice = valueofProd.Price__c;
        Discount__c ds = [Select Discount_Price__c from Discount__c where SetupOwnerId = :UserInfo.getUserId()];
        dis = ds.Discount_Price__c;
        discount = productPrice * (dis/100);
    }
    
    
    public list<SelectOption> getListStateName()
    {
        List<SelectOption> listStateValues = new List<SelectOption>();
        for(Tax__mdt t: [Select State__c from Tax__mdt])
        {
            listStateValues.add(new SelectOption(t.State__c,t.State__c));
        }
        return listStateValues;
    }
    public void SelectedStateFunction()
    {
        Tax__mdt Tax = [Select Tax__c from Tax__mdt where MasterLabel=:SelectedState];
        stateTax = Tax.Tax__c;      
    }
    
    public pagereference calculate()
    {
        Total =  (productPrice - discount) + ((productPrice - discount) *(stateTax/100));
        system.debug('value'+stateTax);
        return null;    
    }
}