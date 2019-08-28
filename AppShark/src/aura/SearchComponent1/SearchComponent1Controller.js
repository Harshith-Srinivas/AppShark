({
	handlComponentEvent : function(component, event, helper) {
		//console.debug('hrfjlmx');
		component.set('v.myColumns', [
			{ label: 'Account Name', fieldName: 'Name', type: 'text', editable: true}
		]);
		var Schnm = event.getParam("SearchName");
		console.debug('--->'+Schnm);
		var action = component.get("c.getValues");
		action.setParams({nm : Schnm});
		action.setCallback(this, function(response)
		{
			var state = response.getState();
			if(state == "SUCCESS")
			{
					component.set("v.List", response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	}
})