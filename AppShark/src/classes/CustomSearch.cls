public with sharing class CustomSearch {
    
    public class wrapperClass{
     @AuraEnabled Public List<Account> acntList  {get;set;}  
     @AuraEnabled Public List<Contact> cntList {get;set;}  
     @AuraEnabled Public List<Opportunity> opntyList {get;set;} 
        
        public wrapperClass(){}
    }   
        
    
    @AuraEnabled
    public static wrapperClass getValues(String nm)
    {
        wrapperClass wc = new wrapperClass(); 
        List<List<SObject>> results = [FIND :nm IN ALL FIELDS RETURNING Account(Name), Contact(Name), Opportunity(Name)];
        system.debug('------>'+nm);
        //List<String> nam = new List<String>();
        /*for(List<SObject> sobjs: results)
        {
            for(SObject sobj: sobjs)
            {
                wrapperClass wp = new wrapperClass();
                wp.ID = sobj.ID;
                wp.Name = sobj.Name;
            }
        }
			result nam;
		*/	
        List<Account> accList = ((List<Account>)results[0]);
        List<Contact> conList  = ((List<Contact>)results[1]);
        List<Opportunity> optyList = ((List<Opportunity>)results[2]);
        wc.acntList = accList;
        wc.cntList = conList;
        wc.opntyList = optyList;
        /*for(Account a: accList)
        {
            wrapperClass w = new wrapperClass();
            w.ID = a.Id;
            w.Name = a.Name;
            wc.add(w);
        }
        for(Contact c: conList)
        {
            wrapperClass w = new wrapperClass();
            w.ID = c.Id;
            w.Name = c.Name;
            wc.add(w);
        }
        for(Opportunity o: optyList)
        {
            wrapperClass w = new wrapperClass();
            w.ID = o.Id;
            w.Name = o.Name;
            wc.add(w);
        }*/
        system.debug('whdevuywehbj'+wc);
        return wc;
    }
}