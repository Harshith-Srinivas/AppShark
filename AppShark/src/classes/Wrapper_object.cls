global class Wrapper_object implements Database.Batchable<wrapperClass>
{    

    global List<wrapperClass> start(Database.BatchableContext bc)
    {
        List<Account> listAccount = [Select Id, Name, (Select LastName from Contacts where Primary_Contact__c= true) from Account];
        List<wrapperClass> listWrapper = new List<wrapperClass>();
        for(Account a: listAccount)
        {
            for(Contact c: a.Contacts)
            {
                listWrapper.add(new wrapperClass(a.Name, c.LastName));
            }
        }
        system.debug('Wrapper'+listWrapper);
        return listWrapper;
    }
    
    global void execute(Database.BatchableContext bc, List<wrapperClass> scope)
    {
		List<AccountContact__c> listAccContact = new List<AccountContact__c>();
        system.debug('List of Acc'+listAccContact);
        for(wrapperClass wc: scope)
        {
            AccountContact__c acCon = new AccountContact__c();
            system.debug('Ac'+acCon);
            system.debug('Account Name'+wc.AccName);
            system.debug('Contact Last Name'+wc.ConLName);
           // acCon.Account__c = wc.AccName;
           // acCon.Contact__c = wc.ConLName;
            system.debug('Account Name'+wc.AccName);
            system.debug('Contact Last Name'+wc.ConLName);
            listAccContact.add(acCon);
        }
        Insert listAccContact;
        system.debug('List is'+listAccContact);
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
    
    global class wrapperClass
    {
        global String AccName;
   		global String ConLName;
        public wrapperClass(String ac, String ct)
        {
            this.AccName = ac;
            this.ConLName = ct;
        }
    }
}