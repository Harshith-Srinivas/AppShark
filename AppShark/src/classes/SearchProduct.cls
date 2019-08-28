public class SearchProduct {
    @AuraEnabled
    public static List<CustomProduct__c> getproduct(String PName, String PFName)
    {
            system.debug('GetName is'+PFName);
            String ProdName = '%'+Pname+'%';
        	if(Pname!=NULL)
            {
            	List<CustomProduct__c> listProducts = [Select ID, Name, Price__c, Images__c From CustomProduct__c where Name LIKE : ProdName AND Product_Category__c=:PFName];
                System.debug(listProducts);
            	System.debug('Name'+PName);
        		System.debug('PFName'+PFName);
          		return listProducts;
            }
        	else if(PFName!=NULL)
        	{
                    List<CustomProduct__c> listProducts = [Select ID, Name, Price__c, Images__c From CustomProduct__c where Product_Category__c=:PFName];
                    System.debug(listProducts);
                    System.debug('Name1'+PName);
                    System.debug('PFName1'+PFName);
                    return listProducts;
			}
        	else if(PFName=='All'&& PNAME==NULL)
            {
                	List<CustomProduct__c> listProducts = [Select ID, Name, Price__c, Images__c From CustomProduct__c];
                    System.debug(listProducts);
                    return listProducts;
            }
        	else
            {
                return null;
            }
        
    }
   
    @AuraEnabled
    public static void storeinProd(Id productId)
    {
        List<Cart__c> cart = new List<Cart__c>();
        List<CustomProduct__c> listProducts = [Select ID, Name, Price__c, Product_Category__c From CustomProduct__c where ID =:productId];
        List<Cart_Item__c> listProd = new List<Cart_Item__c>();
        Map<Id,List<Cart_Item__c>> mapProd = new Map<Id,List<Cart_Item__c>>();
        Integer i=0;
        for(CustomProduct__c cp: listProducts)
        {
            Cart__c ca = new Cart__c ();
            ca.Name = 'Cart '+i;
            cart.add(ca);
            system.debug('cart'+cart);
        	Database.SaveResult[] srList = Database.insert(cart, false);
        	Id rId;
        	for (Database.SaveResult sr : srList) {
    			if (sr.isSuccess()) {
        			rID= sr.getId(); 
        			System.debug('Successfully inserted account. Account ID: ' + rId);
    			}
        	}
        	for(CustomProduct__c ct: listProducts)
        	{
            	Cart_Item__c co = new Cart_Item__c ();
				co.Cart__c = rId;
            	co.Product_Name__c = ct.Name;
            	co.Price__c = ct.Price__c;
            	co.Category__c = ct.Product_Category__c;
            	listProd.add(co);
                mapProd.put(rId,listProd);
            	system.debug('listProd'+mapProd);
        	}
            List<Cart_Item__c> listcart = mapProd.get(rID);
            system.debug(listcart);
                insert listcart;
        	i++;
        }
    }
}