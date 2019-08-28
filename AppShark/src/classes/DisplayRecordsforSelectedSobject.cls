global class DisplayRecordsforSelectedSobject
 {
   //Holds list of sobjects 
   public list<selectoption> lstobjects {set;get;} //Holds List of Objects   
   
   //Create picklist with list of custom object  
   public DisplayRecordsforSelectedSobject()
    {
        lstobjects=new list<selectoption>();
        //lstRecords=new list<Sobject>();
        //fetching the list of objecs from salesforce account      
        List<Schema.SobjectType> lstobj = Schema.getGlobalDescribe().Values();        
        lstobjects .add(new selectoption('None','None'));
        //Iterate through objects and creating picklist                  
        for(Schema.SobjectType objSobject: lstObj)
        {
           //Checks whether object is custom or not if yes it added to list
           if(!string.valueOf(objSobject).contains('__c'))
           {   
               lstobjects .add(new selectoption(string.valueOf(objSobject),string.valueOf(objSobject)));                 
           }
        }        
     }
     
     @RemoteAction
     //Getting records of object which is selected in picklist and object name getting from visualforce page 
     global static list<sobject> getdata(string objectName)
     {          
        list<Sobject> lstRecords= new list<Sobject>();     
        string Query='';
        //Passing query dynamically
        Query='Select Id, Name From '+ objectName;
        //executing query and added records to list        
        lstRecords=Database.query(Query);
        return lstRecords;        
    } 
}