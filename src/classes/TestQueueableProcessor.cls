/**
 * Created by lina_ on 27.09.2020.
 */
@IsTest
public with sharing class TestQueueableProcessor {
    static String recordsName = 'TestQueueable';
    static String city = 'SF';
    static Integer recordsNumber = 150;

    @TestSetup
    public static void init() {
        TestDataFactory.createContactList(recordsName, recordsNumber);
        Account account = new Account(Name = recordsName, BillingCity = city);
        insert account;
        TestDataFactory.updateContactsAddAccountSynced(account, recordsName, true);
    }


    @IsTest
    public static void shouldCopyAddressSyncedUpdated() {

        Test.startTest();
        QueueableProcessor testedInstance = new QueueableProcessor();
        System.enqueueJob(testedInstance);
        Test.stopTest();

        List<Contact> contacts = [
                SELECT Id, MailingCity, Is_Synced__c, Processed_By_Queue__c
                FROM Contact
                WHERE Is_Synced__c = FALSE AND Processed_By_Queue__c = TRUE
        ];
        System.debug(contacts.size());
        System.assert(contacts.size()==recordsNumber);
    }
}