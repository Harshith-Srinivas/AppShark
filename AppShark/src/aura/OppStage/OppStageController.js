({
	doinit : function(component, event, helper) {
        component.set("v.columns",[
            {label:'Name', fieldName:'Name', type:'text'},
            {label:'Stage', fieldName:'StageName', type:'text'},
            {label:'Amount', fieldName: 'Amount', type: 'currency'},
        ]);
    },
    
    navigateToOpp : function(component, event, helper) {
        var rId = component.get("v.recordId");
        var oppoStage = event.target.getAttribute('data-recid');
        var action = component.get("c.basedOnStage");
        action.setParams({
            "accountId" : rId,
            "selectedStage" : oppoStage
        });
        action.setCallback(this, function(a)
         {
             var state = a.getState();
             if(state == "SUCCESS")
             {
                 component.set("v.data", a.getReturnValue());
             }
            else{
            	component.set("v.data", null);
            }
         });        
		$A.enqueueAction(action);
	} 
})