public class Accountss {
	public void acct()
    {
        /*List<Account> acctList = [SELECT Name, (SELECT Name, Id from Contacts) FROM Account WHERE Name='Appshark'];
        for(Account acct: acctList)
        {
        	 Integer numberOfContacts = acct.Contacts.size();
			 System.debug(acct.Name +' account has ' +numberOfContacts+ 'Records');
        }
        List<Opportunity> oppList = [SELECT Name, StageName FROM Opportunity WHERE CreatedDate < THIS_MONTH AND StageName IN ('Closed Won','Negotiation/Review') ORDER BY Name asc ];
        System.debug(oppList);
        List<Contact> conList = [SELECT Name, Account.Name, Account.ID From Contact Where LastName Like 'ST%'];
        System.debug(conList);
        List<Account> industryList = [SELECT Name From Account Where Industry IN ('Agriculture', 'Hospitality')];
        System.debug(industryList);
        List<AggregateResult> revlst = [SELECT SUM(AnnualRevenue) FROM Account WHERE CreatedDate = Today and Industry = 'Agriculture'];
        System.debug(revlst);*/
        List<AggregateResult> indGreat2 = [Select Count(Name), Industry From Account Group BY Industry Having COUNT(Name) > 100 ];
    	System.debug(indGreat2);
    }
}