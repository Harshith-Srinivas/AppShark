public with sharing class DisplayContact {
    public List<Contact> conList {get;set;}
    public DisplayContact(ApexPages.StandardSetController controller) {
    }
    
    public PageReference ContactLists()
    {
	//Checking account id is not null.
    if(ApexPages.currentPage().getParameters().get('id') != null)
      conList = [Select id,Name,Phone,Email from contact where accountId =: ApexPages.currentPage().getParameters().get('id')];
    return null;
    }   
}