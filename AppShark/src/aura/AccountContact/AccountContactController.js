({
	myAction : function(component, event, helper) {
        var accountName = component.get("v.Name");
        console.log('Name'+accountName);
        var action = component.get("c.getcontact");
        action.setParams({accName: accountName});
		action.setCallback(this, function(a)
         {
             var state = a.getState();
             if(state == "SUCCESS")
             {
                 component.set("v.contactNames", a.getReturnValue());
             }
         });        
		$A.enqueueAction(action);				
	},
    pageloadAction : function(component, event, helper) {
    component.set("v.headervalue", 'Search Account Related Contacts');
    }
})