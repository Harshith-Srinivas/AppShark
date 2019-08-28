({           
    doinit : function(component, event, helper) {
        component.set("v.columns",[
            {label:'Name', fieldName:'Name', type:'text'},
            {label:'Product Code', fieldName:'ProductCode', type:'text'},
            {label:'Active', fieldName:'IsActive', type:'checkbox'},
            {label:'Description', fieldName:'Description', type:'text'},
        ]);
           var action = component.get("c.getProduct");
           action.setCallback(this, function(a)
           {
                component.set("v.data", a.getReturnValue());
           });
           $A.enqueueAction(action);
	}
})