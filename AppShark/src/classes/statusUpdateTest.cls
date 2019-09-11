@isTest
public class statusUpdateTest {
    @IsTest
    static void statusTest(){
        Group gr = [select Id, Name from Group where Name = 'Automation Group'];
        List<GroupMember> userId = [Select UserOrGroupId from GroupMember where GroupId =:gr.Id];
        String uid1 = userId[0].UserOrGroupId;
        String uid2 = userId[1].UserOrGroupId;
        Account acct = new Account(Name='Test Account');
        insert acct;
        Opportunity opp = new Opportunity(Name=acct.Name + ' Opportunity',
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acct.Id);
        insert opp;
        List<Task> lstTsk = new List<Task>();
        Task tsk1 = new Task(Subject='Call Them', WhatId = opp.Id, Status='Not Started', OwnerId = uid1);
        insert tsk1;
        Task tsk2 = new Task(Subject='Call Them', WhatId = opp.Id, Status='Completed', OwnerId = uid2);
        insert tsk2;
        tsk1.Status = tsk2.Status;
        lstTsk.add(tsk1);
        Test.startTest();
        update lstTsk;
        Test.stopTest();
    }
}