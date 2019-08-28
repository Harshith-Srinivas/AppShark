public class ProductClass {
	@AuraEnabled
    public static List<Product2> getProduct()
    {
        List<Product2> lstProd =  [SELECT Id, Name, ProductCode, Description, IsActive FROM Product2];
        system.debug('list'+lstProd);
        return lstProd;
    }
}