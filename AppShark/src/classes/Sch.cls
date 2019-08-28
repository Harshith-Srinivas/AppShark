public class Sch {
    String searchText { get; set; }    
    public String getsearchText()
    {
        return searchText;
    }
    
    public void setsearchText(String st)
    {
        searchText = st;
    }
    
    String searchEmail { get; set; }
    public String getsearchEmail()
    {
        return searchEmail;
    }
    
    public void setsearchEmail(String se)
    {
        searchEmail = se;
    }
    
    String searchPhone { get; set; }
    public String getsearchPhone()
    {
        return searchPhone;
    }
    
    public void setsearchPhone(String sp)
    {
        searchPhone = sp;
    }
    
    List<Contact> resultsCn;    
    public List<Contact> getresultsCn()
    {
        return resultsCn;
    }
    String Query = 'Select Id, Name, Email, Phone FROM Contact WHERE';
    public PageReference search() {
        if(searchText != null || searchText != '')
        {
            Query = Query + ' Name=:'+'searchText'+'';
            system.debug('result is' +Query);
        }
        if(searchText != null || searchText != '')
        {
            Query = Query + ' And Email=:'+'searchEmail'+'';
            system.debug('result is' +Query);
        }
        if(searchText != null || searchText != '')
        {
            Query = Query + ' And Phone=:'+'searchPhone'+'';
            system.debug('result is' +Query);
        }
      resultsCn = database.query(Query);
      System.debug(resultsCn);
      return null;
    }
}