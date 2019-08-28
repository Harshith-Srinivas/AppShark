public with sharing class stdObjects {
    public String strObject{get;set;}
    public Map<String, Schema.SobjectType> gd = schema.getGlobalDescribe();
    public Map<String, schema.SObjectField> MapOfFields;
    
    public list<SelectOption> getselectObject()
    {
        List<Schema.SObjectType> describe = schema.getGlobalDescribe().Values();
        List<SelectOption> objects = new List<SelectOption>();
        objects.add(new SelectOption('--None','--None'));
        for(Schema.SObjectType f: describe)
        {
            if(!(f.getDescribe().getName().contains('__c')))
			objects.add(new SelectOption(f.getDescribe().getName(), f.getDescribe().getName()));
		}
        objects.sort();
		return objects;
    }
    
    public List<String> getlstFields()
     { 
        system.debug('testing');
        List<String> st = new list<String>();
        MapOfFields = gd.get(strObject).getDescribe().fields.getMap();
        for(Schema.SObjectField field : MapOfFields.values())
        {
            Schema.DescribeFieldResult fr = field.getDescribe();
            st.add(String.valueOf(fr.getLabel()));
        }
         return st;
    }
     
}