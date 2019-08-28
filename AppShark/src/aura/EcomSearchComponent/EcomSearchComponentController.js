({
    fireFilterComp : function(cmp, event, helper) {
        var compEvent = cmp.getEvent("ProductSearch");
        var ProdName = cmp.get("v.Name");
        var ProdCategory = cmp.get("v.Category");
		compEvent.setParams({
            "ProductName" : ProdName,
            "ProductCategory" : ProdCategory            
		});
		compEvent.fire();
	}
})