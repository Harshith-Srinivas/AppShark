public with sharing class accountSummaryController {

    @AuraEnabled
    public static List<Contact> getContact(Id accountId) {
        List<Contact> lstCon = [SELECT Name, Email, Phone FROM Contact WHERE AccountId = :accountId ];
        system.debug(lstCon);
        return lstCon;
    }
    @AuraEnabled
    public static void updateContact(List<Contact> con ){
    	 Database.update(con);
    }
}