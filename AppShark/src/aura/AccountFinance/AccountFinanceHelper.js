({
	fetchData : function(component, event, helper) {
		var action = component.get("c.getContact");
        action.setParams({"accountId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
                component.set("v.data", response.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})