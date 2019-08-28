({
	handlComponentEvent: function(cmp, event, helper) {
		var nm = event.getParam("AccountName");
        var action = cmp.get("c.getcontact");
        action.setParams({accName: nm});
		action.setCallback(this, function(a)
         {
             var state = a.getState();
             if(state == "SUCCESS")
             {
                 cmp.set("v.contactNames", a.getReturnValue());
             }
         });        
		$A.enqueueAction(action);				
    }
})