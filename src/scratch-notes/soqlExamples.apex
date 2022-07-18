
// Two Ways
// Static Query
List<Account> accounts = [SELECT Id, Name, CreatedDate 
                            FROM Account
                            WHERE CreatedDate = :Date.today() LIMIT 1];

// Dynamic Query
// Database.query('SELECT Id, Name, CreatedDate FROM Account WHERE CreatedDate = ' + Date.today());


List<Contact> contacts = [SELECT Id, Name, AccountId, Account.Name, Account.Owner.FirstName
                            FROM Contact];
for(Contact c : contacts) {
    System.debug(c.Account.Name);
    System.debug(c.Account.Owner.FirstName);
    // System.debug(c.Account.MailingStreet);

}

List<Timecard__c> timecards = [SELECT Id, Name, Project__r.Name
                                FROM Timecard__c];
for(Timecard__c t : timecards) {
    System.debug(t.Project__c);
    System.debug(t.Project__r.Name);
}

List<Project__c> projects = [SELECT Id, Name, (SELECT Name FROM Timecards__r) 
                                FROM Project__c];
for(Project__c p : projects) {
    System.debug(p.Name);
    
    for(Timecard__c t : p.Timecards__r) {
        System.debug(t.Name);
    }
}

/////////

System.debug([SELECT Id, Name, Subject 
                FROM Case 
                WHERE CreatedDate < :Date.today()]);



System.debug([SELECT Id, Email, Owner.Name, Owner.Email 
                FROM Lead 
                WHERE Rating = 'Hot']);



System.debug([SELECT count() 
                FROM Account 
                WHERE LastModifiedDate = :Date.today()])



System.debug([SELECT Id, Name, Amount, 
                (SELECT ListPrice, Quantity 
                    FROM OpportunityLineItems) 
                FROM Opportunity
                WHERE Amount > 1000]);



System.debug([SELECT QuoteId, ListPrice, UnitPrice 
                FROM QuoteLineItem 
                WHERE ListPrice > 10]);



String queryString = 'SELECT Id, ';
if(currentUser.isFromEU) {
    queryString = queryString + 'FirstName ';
} else {
    queryString = queryString + 'LastName ';
}

queryString += 'FROM Contact';
Database.query(queryString);



System.debug(Database.query('SELECT Id, FirstName, LastName FROM Contact'));



System.debug(Date.today());
System.debug(Database.query('SELECT Id, Industry, Name FROM Account WHERE LastModifiedDate = ' + Date.today()));

