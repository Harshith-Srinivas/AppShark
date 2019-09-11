trigger Acc on Account (after insert, after update) 
{
    List<Account> lstAcc = new List<Account>();
    Set<Id> accountSet = new Set<ID>();
    for(Account a: Trigger.new)
    {
        accountSet.add(a.ID);
    }
    system.debug('ID'+accountSet);
    List<Account> lstAc = [Select Id, Name, Site from Account where ID=: accountSet];
    system.debug('list'+lstAc);
    for(Account ac: lstAc)
    {
        if(ac.site == Null)
        {
            ac.Site = 'aaaa';
            lstAcc.add(ac);
            update lstAcc;
        }
    }
    system.debug('l'+lstAcc);
    
}