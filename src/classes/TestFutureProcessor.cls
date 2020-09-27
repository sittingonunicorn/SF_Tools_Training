/**
 * Created by lina_ on 27.09.2020.
 */

@IsTest
public with sharing class TestFutureProcessor {
    static String recordsName = 'TestFuture';
    static String city = 'LA';
    static Integer recordsNumber = 150;


    @TestSetup
    public static void init(){
        TestDataFactory.createContactList(recordsName, recordsNumber);
        Account account = new Account(Name = recordsName, BillingCity = city);
        insert account;
        TestDataFactory.updateContactsAddAccountSynced(account, recordsName, true);
    }

    @IsTest
    public static void shouldSetSyncedTrue() {

        Test.startTest();
        FutureProcessor.setProcessedFuture();
        Test.stopTest();

        List<Contact> contacts = getContacts();
        for(Contact contact: contacts){
            System.assert(contact.Is_Synced__c==false);
            System.assert(contact.Processed_By_Future__c==true);
        }
    }

    private static List<Contact> getContacts() {
        List<Account> accounts = [
                SELECT Id, Name, BillingAddress,
                (SELECT Id, LastName, Is_Synced__c, Processed_By_Future__c FROM Contacts)
                FROM Account
                LIMIT 150
        ];
        List<Contact> contacts = new List<Contact>();
        for (Account account : accounts) {
            if (account.BillingAddress != null) {
                contacts.addAll(account.Contacts);
            }
        }
        return contacts;
    }
}