global class TaskOwner implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
           	String query =  'Select ID, Subject, Status, ActivityDate, OwnerID, CreatedDate, Priority from Task where CreatedDate = Today';
            return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Task> scope)
    {     
            List<Task> lstUpTask = new List<Task>();
            for(task t: scope)
            {
                    User usId = [Select ManagerID from User where ID = :t.OwnerID];
                    User userEmail = [Select Name, Email from User where ID = :usId.ManagerID];
                    if(t.Status != 'Completed')
                    {
                        system.debug('UserID'+t.OwnerId);
                        t.OwnerID = usId.ManagerId;
                        lstUpTask.add(t);
                        system.debug('lst'+lstUpTask);
                    }
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[]{userEmail.Email};
                    mail.setToAddresses(toAddresses);
                    mail.setSubject('0 business day');         
                    mail.setHtmlBody('<h1>Task</h1><p>To: '+userEmail.Name+'</p><p>Subject: '+t.Subject+'</p><p>Due Date: '+t.ActivityDate+'</p><p>Priority: '+t.Priority+'</p><p>For more details, click the following link: a href=https://na1.salesforce.com/');
                    Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
              }
				update lstUpTask;
    }

    global void finish(Database.BatchableContext bc)
    {
                
    }
}