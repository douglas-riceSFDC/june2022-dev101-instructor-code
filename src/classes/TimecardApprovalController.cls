public with sharing class TimecardApprovalController {

    @AuraEnabled
    public static List<Timecard__c> getRelatedTimecards(Id projectId) {
        try {
            return [
                SELECT Id, Name, Status__c, Number_of_Times_Rejected__c
                FROM Timecard__c
                WHERE Project__c = :projectId
            ];
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static Timecard__c createNewTimecard(Id projectId) {
        try {
            Timecard__c generatedTimecard = new Timecard__c(Project__c = projectId);
            insert generatedTimecard;
            return generatedTimecard;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}