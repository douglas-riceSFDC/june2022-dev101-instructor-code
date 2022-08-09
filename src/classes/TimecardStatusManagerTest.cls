@isTest
private class TimecardStatusManagerTest {

    private static Project__c generateProject(String projectName) {
        Project__c testProject = new Project__c();
        testProject.Name = projectName;
        return testProject;
    }

    private static Timecard__c generateTimecard(Id projectId, String status) {
        Timecard__c testTimecard = new Timecard__c();
        testTimecard.Project__c = projectId;
        testTimecard.Status__c = status;
        return testTimecard;
    }

    @TestSetup
    static void createTimecardData(){
        Project__c testProject = generateProject('Unit Test Project');
        insert testProject;

        Timecard__c testTimecard = generateTimecard(testProject.Id, 'Draft');
        insert testTimeCard;
    }

    @isTest
    static void updateRejectionCount_givenRejectedTimecard_shouldIncrement() {
        List<Timecard__c> testTimecards = [SELECT Status__c FROM Timecard__c];

        Test.startTest();

        testTimecards[0].Status__c = 'Rejected';
        update testTimecards[0];

        Test.stopTest();

        List<Timecard__c> updatedTimecards = [SELECT Number_of_Times_Rejected__c FROM Timecard__c];

        System.assertEquals(1, updatedTimecards[0].Number_of_Times_Rejected__c, 
                                'Rejection number should have been incremented');
    }

    @isTest
    static void updateRejectionCount_givenSubmitted_shouldNotIncrement() {
        List<Timecard__c> testTimecards = [SELECT Status__c FROM Timecard__c];

        Test.startTest();

        testTimecards[0].Status__c = 'Submitted';
        update testTimecards[0];

        Test.stopTest();

        List<Timecard__c> updatedTimecards = [SELECT Number_of_Times_Rejected__c FROM Timecard__c];

        System.assertEquals(null, updatedTimecards[0].Number_of_Times_Rejected__c, 
                                'Rejection number should not have been incremented');
    }

    @isTest
    static void updateRejectionCount_givenAlreadyRejectedTimecard_shouldNotIncrementAgain() {
        List<Timecard__c> testTimecards = [SELECT Status__c FROM Timecard__c];

        testTimecards[0].Status__c = 'Rejected';
        update testTimecards[0];

        Test.startTest();

        update testTimecards[0];

        Test.stopTest();

        List<Timecard__c> updatedTimecards = [SELECT Number_of_Times_Rejected__c FROM Timecard__c];

        System.assertEquals(1, updatedTimecards[0].Number_of_Times_Rejected__c, 
                                'Rejection number should not have been incremented more than once');
    }
}