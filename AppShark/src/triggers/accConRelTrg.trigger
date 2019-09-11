trigger accConRelTrg on AccountContactRelation (before insert, before update) {
    if(Trigger.isInsert || Trigger.isUpdate)
    {
    List<AccountContactRelation> listAc = new List<AccountContactRelation>();
    List<AccountContactRelation> acoldTr = new List<AccountContactRelation>();
    List<ID> lstIds = new List<ID>();
    for(AccountContactRelation acr: Trigger.new)
    {
        lstIds.add(acr.AccountID);
        system.debug('ids'+lstIds);
    }
    acoldTr = [Select Id,Roles from AccountContactRelation where AccountId =:lstIds];
    system.debug('acold'+acoldTr);
    for(AccountContactRelation a: Trigger.new)
    {
        for(AccountContactRelation ar: acoldTr)
        {
            if(a.Roles == Null)
            {
                listAc.add(a);
                a.roles = 'Billing Contact';
            }
            else if(a.Roles != Null && ar.Roles == 'Billing Contact')
            {
                AccountContactRelation ac = new AccountContactRelation();
                a.Roles = ac.Roles;
                listAc.add(a);
            }    
        }
    }
    }
}