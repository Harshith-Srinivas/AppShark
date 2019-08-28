public class RelatedContact {
		@AuraEnabled
    public static list<Contact> getcontact(String accName)
    {
        system.debug('hi'+accName);
        List<Account> acc = new List<Account>();
        List<Id> accId = new List<Id>();
        acc = [Select Id from Account where Name=:accName ];
        system.debug('a'+acc);
        for(Account a: acc)
        {
            accId.add(a.id);
        }
        
        List<Contact> Con = [Select Id, FirstName, LastName, Email, Phone from Contact where AccountId=:accId];
        System.debug('Server side action-->'+con);
        return con;
    }
}