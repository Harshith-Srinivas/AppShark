public with sharing class SearchStore {

	@AuraEnabled
    public static List<Cart_Item__c> store()
    {
        return [Select Id, Name from Cart_Item__c];
    }

}