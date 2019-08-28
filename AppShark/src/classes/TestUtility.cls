public class TestUtility {
	public static List<Account> createData( )
    {
        List<Account> accot = new List<Account>();
     	Account acct = new Account();
        acct.Name = 'Indus Valley';
        acct.Industry = 'Agriculture';
        acct.Phone = '5103143183'; 
        accot.add(acct);
        return accot;
    }
}