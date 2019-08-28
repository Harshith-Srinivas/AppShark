global class DeleteDuplicateEmail implements Database.Batchable<sObject>, Database.Stateful
{

    global Map<String , Custom_contact__c> EmailContactmap = new Map<String, Custom_contact__c>();
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query = 'select Email__c from Custom_contact__c';
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext bc, List<Custom_contact__c> scope)
    {
        List<Custom_contact__c> duplicateLst = new List<Custom_contact__c>();
        for(Custom_contact__c custCon : scope)
        {
            if(!EmailContactmap.containskey(custCon.Email__c))
            {
                EmailContactmap.put(custCon.Email__c, custCon);
                system.debug('Put'+EmailContactmap);
            }
            else
            {
                duplicateLst.add(custCon);
                system.debug('Dupe'+duplicateLst);
            }
        }
        system.debug(duplicateLst);
        if(duplicateLst.size() > 0)
            delete duplicateLst;
      }
      
      global void finish(Database.BatchableContext bc)
      {

      }
}