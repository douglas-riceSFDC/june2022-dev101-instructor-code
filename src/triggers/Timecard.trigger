trigger Timecard on Timecard__c (before update, before insert, after update) {
    if(Trigger.isBefore && Trigger.isUpdate) {
        TimecardStatusManager.updateRejectionCount(Trigger.new, Trigger.oldMap);
    } else if(Trigger.isBefore && Trigger.isInsert) {
        ProjectManagerAssigner.assignTimecardManagerFromProject(Trigger.new);
    } else if(Trigger.isAfter && Trigger.isUpdate) {
        TimecardStatusManager.closeRelatedTasks(Trigger.new);
    }
}
