({
	getcon : function(component, event) {
        var action = component.get("c.getcontacts");
        action.setCallback(this, function(a)
                           {
                               component.set("v.contactRows", a.getReturnValue());
                           });
		$A.enqueueAction(action);
	}
})