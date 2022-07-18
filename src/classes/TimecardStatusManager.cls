public with sharing class TimecardStatusManager {
    public TimecardStatusManager() {

    }

    public static void updateRejectionCount(List<Timecard__c> updatedTimecards, 
                                                Map<Id, Timecard__c> oldTimecardValues) {
                                           
        for(Timecard__c t : updatedTimecards) {
            if(t.Status__c == 'Rejected' 
                && oldTimecardValues.get(t.Id).Status__c != 'Rejected') {

                if(t.Number_of_Times_Rejected__c == null) {
                    t.Number_of_Times_Rejected__c = 0;
                }
                
                t.Number_of_Times_Rejected__c = t.Number_of_Times_Rejected__c + 1;
            }
        }
    }

    public static void closeRelatedTasks(List<Timecard__c> updatedTimecards) {
        List<Id> finalizedTimecardIds = new List<Id>();
        for(Timecard__c t : updatedTimecards) {
            if(t.Status__c == 'Submitted') {
                finalizedTimecardIds.add(t.Id);
            }
        }

        List<Task> relatedTasks = [SELECT Status 
                                    FROM Task
                                    WHERE WhatId IN :finalizedTimecardIds];
        
        for(Task t : relatedTasks) {
            t.Status = 'Completed';
        }                          
        
        update relatedTasks;
    }
}
