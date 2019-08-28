public class attachPDF {
    private final Quote q;
	public attachPDF(ApexPages.StandardController stdController) {
		this.q = (Quote)stdController.getRecord();
        system.debug('qq'+q);
    }
    
      
    public PageReference attachPDFquote()
    {
        PageReference pdf = Page.CustomQuote;
		pdf.getParameters().put('id',q.ID);
        pdf.setRedirect(true);
		Blob b = pdf.getContentAsPdf();        
        //Email
    	Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Quote.pdf');
        efa.Body= b;
        //Disable Deveopment Mode in Profile Settings Advanced User Detail for sending or attaching attachments
        QuoteDocument attach = new QuoteDocument(QuoteID= q.Id, Document = b);
        insert attach;
        
        quote qu = [Select ID, OpportunityId, Name from Quote where ID =:q.ID];
        Attachment oppAttach = new Attachment(ParentId = qu.OpportunityId, Body = b, Name = qu.Name);
        system.debug('oppId'+qu.OpportunityId);
        insert oppAttach;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {q.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('New contact is created');         
        mail.plainTextBody = 'Name : '+q.Name+'\n'+'Mail Id : '+q.Email;        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
        return new PageReference('/'+q.Id);
    }
}