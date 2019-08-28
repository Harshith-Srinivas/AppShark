@isTest
public class TestaccConRelTrg {
	public static testMethod void TestAccountContact()
    {
        Account acct = new Account(Name= 'Test Account' );
        insert acct;
        Contact con = New Contact(LastName = 'Contact',
                                 FirstName = 'Test',
                                 AccountId = acct.Id);
        insert con;
        AccountContactRelation a = new AccountContactRelation(AccountId = acct.id,
                                                             ContactId = '0032E00002Sf16sQAB');
        insert a;
        List<AccountContactRelation> acc = new List<AccountContactRelation>();
        acc = [Select ID, Roles From AccountContactRelation where AccountID = :acct.Id];
        system.debug('aa'+acc);
    }
}