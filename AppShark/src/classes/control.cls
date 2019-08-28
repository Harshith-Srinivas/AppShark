public with sharing class control {
    
    public Custom_Order__c customObject{get; set;}
    
    public Control(ApexPages.StandardController stdController){
      customObject = new Custom_Order__c();
	}
	
    public pageReference direct()
    {
        system.debug('hjkl----->'+customObject.Name);
        insert customObject;
        system.debug('hjkl----->'+customObject.Name);   
        return null;
    }
}