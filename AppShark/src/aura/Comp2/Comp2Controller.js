({
	handleComponentEvent : function(cmp, event, helper) {
        
        var message = event.getParam("message");
        console.log(message);
        cmp.set("v.messageFromEvent", message);
        var numEventsHnadled = parseInt(cmp.get("v.numEvents"))+2;
        cmp.set("v.numEvents",  numEventsHnadled);
	}
})