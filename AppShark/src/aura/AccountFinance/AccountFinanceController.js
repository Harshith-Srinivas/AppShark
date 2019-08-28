({
	doinit : function(component, event, helper) {
        component.set("v.columns",[
            {label:'Name', fieldName:'Name', type:'text', editable:true},
            {label:'Phone', fieldName:'Phone', type:'text', editable:true},
            {label:'Email', fieldName:'Email', type:'email', editable:true}
        ]);
        helper.fetchData(component,event,helper)
    },
    handleSave: function(component, event, helper){
        var draftValues = event.getParam('draftValues');
        console.log(draftValues);
        var action = component.get("c.updateContact");
        action.setParams({"con" : draftValues});
        action.setCallback(this,function(response)
                           {
                               var state = response.getState();
                               $A.get('e.force:refreshView').fire();
                           });
        $A.enqueueAction(action);  
    }
})