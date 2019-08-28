public class CollectionSet {
	public static void setExample()
    {
        Set<String> countrySet = new Set<String> {'Iraq' , 'Qatar' , 'Mozambique', 'Argentina' , 'Armenia'};
        countrySet.add('Iran');
        countrySet.add('Australia');
        countrySet.add('Tajikistan');
        countrySet.add('Belarus');
        countrySet.add('Belgium');
        countrySet.add('Pakistan');
        countrySet.add('Afghanistan');
        countrySet.add('Singapore');
        countrySet.add('Belize');
        countrySet.add('Andorra');
        countrySet.add('Azerbaijan');
        countrySet.add('Malaysia');
        countrySet.add('Mexico');
        countrySet.add('Mali');
        countrySet.add('Mayotte');    
        System.debug('Set of Countries:'+countrySet);
        System.debug('Size of Countries:'+countrySet.size());
        
        Set<String> countrySetA = new Set<String>{'Andorra','Afghanistan','Australia','Azerbaijan','Argentina','Armenia'};
        Set<String> countrySetB = new Set<String>{'Belarus','Belgium','Belize'};
        Set<String> countrySetM = new Set<String>{'Mayotte','Mali','Mexico','Malaysia','Mozambique'};
        Set<String> countrySetP = new Set<String>{'Pakistan'};
        Set<String> countrySetT = new Set<String>{'Tajikistan'};
        Set<String> countrySetI = new Set<String>{'Iraq','Iran'};
        Set<String> countrySetQ = new Set<String>{'Qatar'};
        Set<String> countrySetS = new Set<String>{'Singapore'};
        
        Map<String, Set<String>> mapCountry = new Map<String, Set<String>>();
        mapCountry.put('A', countrySetA);
        mapCountry.put('B', countrySetB);
        mapCountry.put('M', countrySetM);
        mapCountry.put('P', countrySetP);
        mapCountry.put('T', countrySetT);
        mapCountry.put('I', countrySetI);
        mapCountry.put('Q', countrySetQ);
        mapCountry.put('S', countrySetS);
        
        System.debug('Value of A'+mapCountry.get('A'));
        System.debug('Value of B'+mapCountry.get('B'));
        System.debug('Value of M'+mapCountry.get('M'));
        System.debug('Value of P'+mapCountry.get('P'));
        System.debug('Value of T'+mapCountry.get('T'));
        System.debug('Value of I'+mapCountry.get('I'));
        System.debug('Value of Q'+mapCountry.get('Q'));
        System.debug('Value of S'+mapCountry.get('S'));
    }
}