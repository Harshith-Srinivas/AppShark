@isTest
public class AccountssTest {
    static testmethod void testmethod1()
    {
        List<Account> lstAcc = TestUtility.createData();
        insert lstAcc;
        
        Contact objcon = new Contact();
        objcon.FirstName = 'Test';
        objcon.LastName = 'Testlname';
        objcon.AccountId = lstAcc[0].Id;
        objcon.email = 'test@gmail.com';
        insert objcon;
        
        Accountss acts1 = new Accountss();
        acts1.acct();
    }
}