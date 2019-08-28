({
	fireComp : function(cmp, event, helper) {
		var compEvent = cmp.getEvent("compEvent");
        var name1 = cmp.get("v.Name");
        compEvent.setParams({
            "AccountName" : name1
        });
        compEvent.fire();
	}
})