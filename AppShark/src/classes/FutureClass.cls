public class FutureClass {
    @future
    public static void futureMethod(List<Id> recordIDs)
    {
        List<Account> listAcc = [SELECT Id, No_of_Con__c, (SELECT Id, Name  from Contacts) FROM Account where id=:RecordIDs];
        for(Account acct: listAcc)
        {
			List<Contact> listCon = acct.Contacts;
            acct.No_of_Con__c = listCOn.size();
        }
        update listAcc;
    }

}