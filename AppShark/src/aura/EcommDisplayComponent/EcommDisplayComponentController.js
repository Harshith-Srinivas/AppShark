({
	handleComponentEvent : function(cmp, event, helper){
		var nm = event.getParam("ProductName");
        var filterNm = event.getParam("ProductCategory");
        console.log(filterNm);
		var action = cmp.get("c.getproduct");
		action.setParams({
            PName: nm,
        	PFName: filterNm
        });
		action.setCallback(this, function(response)
		{
			var state = response.getState();
			if(state = "SUCCESS")
			{
				cmp.set("v.ProductNames", response.getReturnValue());
            }	
		});
		$A.enqueueAction(action);
	},
    /*doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
                
        // Create the action
        var action = component.get("c.getItemById");
        action.setParams({
            "recordId":  recordId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state == "SUCCESS")
            {
                component.set("v.product", response.getReturnValue());
            }
            else
            {
                console.log("Data load failed with state: ", state);
                console.log("response: ", response);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },*/
    handleClick : function(cmp, event, helper){
        var rId = event.target.id;
        var action = cmp.get("c.storeinProd");
        action.setParams({ 'productId': rId });
        console.log(rId);
        action.setCallback(this, function(response)
		{
			var state = response.getState();
			if(state = "SUCCESS")
			{
				console.log('SUCCESS');
            }	
		});
		$A.enqueueAction(action);
    },
    cartHandle: function(component, event,helper){
         var evt = $A.get("e.force:navigateToComponent");      
		 evt.setParams({
             componentDef:"c:EcommComponent",
    	});
		evt.fire();
    }
})