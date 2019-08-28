public class StringMeths {
    public static void meths()
    {
        String s = 'Hello Maximillian';
		String s2 = s.abbreviate(8);
		System.assertEquals('Hello...', s2);
		System.assertEquals(8, s2.length());
        String s3 = 'hello';
		String s4 = s3.center(9);
		System.assertEquals('  hello  ',s4);
    }

}