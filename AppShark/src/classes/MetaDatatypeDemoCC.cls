public with sharing class MetaDatatypeDemoCC {

public list<Country_Setting__mdt>getCountrySetting(){

return [Select DeveloperName,MasterLabel, Country_Name__c from Country_Setting__mdt];

}

}