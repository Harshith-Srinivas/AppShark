public class QRclass {
    public String returnString{get; set;}
	public QRClass(ApexPages.StandardController controller)
    {
    	String caseId = ApexPages.currentPage().getParameters().get('id');
        system.debug('Text->'+returnString);   
    }
    
    public PageReference actionInController ()
    {
    // Read your returnString here using this.returnString
    	String caseId = ApexPages.currentPage().getParameters().get('id');
    	List<Case> currentCase = [Select ID, Description from Case Where ID=:caseId];
    	system.debug('TextinAction->'+returnString);
        system.debug('Case ID->'+caseId);
        system.debug('List Case->'+caseId);
        List<Case> newCase = new List<Case>();
     	for(Case c: currentCase)
     	{
         	c.Description = returnString;
            newCase.add(c);
     	}
        system.debug('cccc'+newCase);
        update newCase;
        PageReference pf = new PageReference('/'+caseId);
        pf.setRedirect(true);
        return pf;
	}
}