({
	fireComp : function(cmp, event, helper) {
		var compEvent = cmp.getEvent("SearchEv");
        var name1 = cmp.get("v.Name");
        console.log('mmm=---->'+name1);
        compEvent.setParams({
            "SearchName" : name1
        });
        console.log('done');
        compEvent.fire();
	}
})