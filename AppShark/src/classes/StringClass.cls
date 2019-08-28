public class StringClass {
	public static void StringExample()
    {
        String myStr = 'i. dont. have. any. plans';
        System.debug('String: '+myStr);
        System.debug('Length of string is: '+myStr.length());
        System.debug('First character to title case: '+myStr.capitalize());
        System.debug('Character at 3rd position: '+myStr.substring(3,4));
        System.debug('Reversing the string: '+myStr.reverse());
       	String[] arrTest = myStr.split('\\.');
        System.debug('Splitting: '+arrTest);
        System.debug('Word count: '+arrTest.size());
        String[] arr = new List<String>();
        Integer i;
            try{
                arr[i] = arrTest[i];
            }
            catch(Exception ec)
            {
                System.debug('Error:'+ec);
            }
        for(i=0; i<arrTest.size(); i++)
        {
            System.debug('Size of "'+arrTest[i]+'" is:'+arrTest[i].length());            
        }
        for(i=0; i<arrTest.size(); i++)
        {
            System.debug('Without whitespaces "'+arrTest[i]+'" has:'+arrTest[i].trim().length());
        }
    }
}