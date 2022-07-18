public with sharing class ProjectManagerAssigner {
    public ProjectManagerAssigner() {

    }

    public static void assignTimecardManagerFromProject(List<Timecard__c> insertedTimecards) {
        List<Id> projectIds = new List<Id>();

        for(Timecard__c t : insertedTimecards) {
            if(t.Project__c != null) {
                projectIds.add(t.Project__c);
            }
        }

        Map<Id, Project__c> queriedProjectMap = new Map<Id, Project__c>(
                                        [SELECT Id, Project_Manager__c, Name
                                            FROM Project__c
                                            WHERE Id IN :projectIds]);

        for(Timecard__c t : insertedTimecards) {
            if(queriedProjectMap.containsKey(t.Project__c)) {
                t.Project_Manager__c = queriedProjectMap.get(t.Project__c).Project_Manager__c;
            }
        }
    }
}
