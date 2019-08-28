public class OpportunityStage {
	@AuraEnabled
    public static List<Opportunity> basedOnStage(String accountId,String selectedStage)
    {
        system.debug('ID'+accountId);
        system.debug('Stage'+selectedStage);
        List<Opportunity> lstOpp = [Select Id, Name,StageName, Amount from Opportunity where AccountId=:accountId and StageName=:selectedStage];
        system.debug('Stage'+lstOpp);
        return lstOpp;
    }
}