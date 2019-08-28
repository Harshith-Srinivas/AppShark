global class BatchTransfer implements Database.Batchable<sObject>
{
    global set<id> allIds=new set<id>();
    global set<id> allFailedId=new set<id>();
    global set<id> allSuccessId=new set<id>();

global Database.QueryLocator start(Database.BatchableContext bc)
{
    String query = 'Select FirstName, LastName, Email From Contact';
    return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext bc, List<Contact> scope)
{
    List<Custom_contact__c> newLstCon = new List<Custom_contact__c>();
    for(Contact con: scope)
    {
        Custom_contact__c customContact = new Custom_contact__c();
        customContact.Name = con.LastName;
        customContact.First_name__c = con.FirstName;
        customContact.Email__c = con.Email;
        newLstCon.add(customContact);
        system.debug('List'+newLstCon);
    }
    insert newLstCon;
    database.SaveResult[] myResult=database.update(scope,false);  
        for(Integer i=0; i < myResult.size(); i++) {
        if(myResult.get(i).isSuccess()) {
            System.debug('Records are updated Successfully');
            allSuccessId.add(myResult.get(i).Id);
        } 
        else if(!myResult.get(i).isSuccess()) {
            Database.Error errors =  myResult.get(i).getErrors().get(0);
            System.debug('Error Occurs While Processing The Record'+errors.getMessage());
           // System.debug('Failure Record Ids While Updating'+myResult.get(i).Id);
            allFailedId.add(newLstCon.get(i).Id);
        }
    }
}
global void finish(Database.BatchableContext bc)
{
    System.debug('All fails Ids===> ' +allFailedId);
	System.debug('All success Id---> ' +allSuccessId);
}
}