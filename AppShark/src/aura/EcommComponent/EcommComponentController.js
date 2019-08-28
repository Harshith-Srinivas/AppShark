({
	doinit : function(component, event, helper) {
		var action = component.get("c.store");
        action.setCallback(this,function(a)
                           {
                              	component.set("v.items",a.getReturnValue());
                           });
		$A.enqueueAction(action);
    	}
})