public class CollectionList {
    public static void listExample()
    {
        List<String> lstcountry = new List<String>();
        lstcountry.add('India');
        lstcountry.add('USA');
        lstcountry.add('UK');
        lstcountry.add('Australia');
        lstcountry.add('New Zealand');
        System.debug('List Countries'+lstcountry);
        lstcountry.add('Sri Lanka');
       	lstcountry.set(1,'Bangladesh');
        System.debug('List1:'+lstcountry);
        List<String> lstcountry2 = new List<String> { 'CA' , 'MA', 'FL', 'IL', 'NY'};  
        System.debug('List2:'+lstcountry2);
        List<String> lstcountry12 = new List<String>();
        lstcountry12.addAll(lstcountry);
        lstcountry12.addAll(lstcountry2);
        System.debug('Combined List:'+lstcountry12);
        List<String> lstcountry3 = new List<String>();
        lstcountry3 = lstcountry.clone();
        System.debug('Cloned List3:'+lstcountry3);
        List<String> lstcountry4 = new List<String>();
        lstcountry4 = lstcountry3.clone();
        lstcountry4.remove(0);
        lstcountry4.remove(4);
        System.debug('List4:'+lstcountry4);
        lstcountry.sort();
        System.debug('Sorted List:'+lstcountry);
        lstcountry2.sort();
        System.debug('Sorted List1:'+lstcountry2);
        lstcountry12.sort();
        System.debug('Sorted List2:'+lstcountry12);
        lstcountry3.sort();
        System.debug('Sorted List3:'+lstcountry3);
        lstcountry4.sort();
        System.debug('Sorted List4:'+lstcountry4);
        System.debug('Size List:'+lstcountry.size());
        System.debug('Size List2:'+lstcountry2.size());
        System.debug('Size List of cloned:'+lstcountry12.size());
        System.debug('Size List3:'+lstcountry3.size());
        System.debug('Size List4:'+lstcountry4.size());

        
    }
}