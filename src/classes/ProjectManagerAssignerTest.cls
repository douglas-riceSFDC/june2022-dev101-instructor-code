@isTest
private class ProjectManagerAssignerTest {
    
    @isTest
    static void assignTimecardManagerFromProject_givenNewTimecard_shouldAssignProjectManager() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testProjectManager = new Contact();
        testProjectManager.AccountId = testAccount.Id;
        testProjectManager.LastName = 'Doe';
        insert testProjectManager;

        Project__c testProject = new Project__c();
        testProject.Name = 'Test Project';
        testProject.Project_Manager__c = testProjectManager.Id;
        insert testProject;

        Test.startTest();

        Timecard__c testTimecard = new Timecard__c();
        testTimecard.Project__c = testProject.Id;
        insert testTimecard; // ProjectManagerAssigner.assignTimecardManagerFromProject()

        Test.stopTest();

        List<Timecard__c> insertedTimecards = [SELECT Project_Manager__c 
                                                FROM Timecard__c
                                                WHERE Id = :testTimecard.Id];

        System.debug([SELECT count() FROM Task]);
        
        System.assertEquals(testProject.Project_Manager__c, 
                            insertedTimecards[0].Project_Manager__c, 
                            'The Project Manager field should be the same as on the Project');                                        

    }
}
