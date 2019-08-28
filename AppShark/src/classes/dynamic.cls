public class dynamic {
    list<account> lstacc{get;set;}
    string searchName{get;set;}
    public string getsearchName(){
        return searchName;
    }
    public void setsearchName(string sname){
        searchName = sname;
    }
    
    string strquery = 'Select Id, Name FROM ACCOUNT WHERE';
        public pagereference stacc(){
        if(searchname != null || searchname != '')
        {
            strquery = strquery + ' name=:'+ 'searchName' +'';
            system.debug('result is' +strquery);
        }
            lstacc = database.query(strquery);
            system.debug(lstacc);
            return null;
}
}