({
    rerender : function(cmp, helper){
        this.superRerender();

        if(cmp.get("v.Name")) {
            var reader = new FileReader();
        reader.onload = function() {
        node.value = "";
        qrcode.callback = (this,function(res){
            //your logics

            //Finally set the needToProcessReRenderLogic to false, since rerender will be called multiple times
            cmp.set("v.needToProcessReRenderLogic",false); // this will not fire rerender again
        });
	}
         $A.enqueueAction(qrcode);
    }
    }
})