public class multiAccountInsert{

    public Account at { get; set; }
    public String AccountName{get;set;}

    public PageReference Save()
    {
    	at = new Account();
    	at.Name=AccountName;
      	insert at;
		return null;
    }


    
}