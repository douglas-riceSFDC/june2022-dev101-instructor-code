public with sharing class TaskGenerator {
    
    public static void handleTimecardReminders(List<Timecard__c> insertedTimecards) {
        Contact c = null;
        c.LastName = 'Doug';

        List<Id> timecardIds = new List<Id>();
        for(Timecard__c t : insertedTimecards) {
            timecardIds.add(t.Id);
        }

        generateTimecardReminders(timecardIds);
    }

    // have to be static
    // have to be void
    // must take in primative data types (or collections of primatives)
    
    @future
    public static void generateTimecardReminders(List<Id> timecardIds) {
        List<Task> timecardReminders = new List<Task>();
        for(Id i : timecardIds) {
            Task reminder = new Task();
            reminder.WhatId = i;
            reminder.Subject = 'Submit Your Timecard!';
            reminder.ActivityDate = Date.today().addDays(7);

            timecardReminders.add(reminder);
        }

        insert timecardReminders;
    }

    
}
