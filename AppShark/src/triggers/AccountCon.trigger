trigger AccountCon on Account (after insert) {
    
    List<Contact> lstCon = new List<Contact>();
    for(Account objAcc: Trigger.New)
    {
        Contact con = new Contact();
        con.LastName = objAcc.Name;
        con.AccountId = objAcc.Id;
  		lstCon.add(con);
    }
	if(!lstCon.isEmpty())
        insert lstCon;
}