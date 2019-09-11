trigger statusUpdate on Task (before Update, after Update) {
    if(Trigger.isUpdate){
        List<Task> listOldTask = new List<Task>();
        List<Task> currentTask = new List<Task>();
        list<Task> listTask = new List<Task>();
        Set<Id> taskIds = new Set<ID>();
        for(Task s: Trigger.old)
        {
           taskIds.add(s.Id);
        }
        currentTask =  [Select ID, Status, Subject, WhatId, OwnerId, Related_ID__c from Task where ID IN : taskIds];
        system.debug('Current-->'+currentTask);
        listOldTask = [Select ID, Status, Subject, WhatId, OwnerId, Related_ID__c from Task]; 
        system.debug('Old-->'+listOldTask);
        for(Task c: currentTask)
        {
           for(Task o: listOldTask)
           {
               if(c.ID != o.ID && c.Subject == o.Subject && c.WhatId == o.WhatID && c.Status != o.Status 
                  && c.Status == 'Completed' && o.Status != 'Completed' && c.OwnerID != o.OwnerID && c.Related_ID__c == o.Related_ID__c)
               {
                   o.Status = c.status;
                   system.debug('old Record ID'+o.ID);
                   system.debug('old Record Status'+o.Status);
                   listTask.add(o);
               }
           }
        }
        update listTask;
    }
}