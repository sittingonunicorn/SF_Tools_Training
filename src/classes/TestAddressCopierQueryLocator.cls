/**
 * Created by lina_ on 27.09.2020.
 */

@IsTest
public with sharing class TestAddressCopierQueryLocator {
    static String recordsName = 'TestQueryLocator';
    static String city = 'LA';
    static Integer batchSize = 200;

    @TestSetup
    public static void init() {
        TestDataFactory.createContactList(recordsName, batchSize);
        Account account = new Account(Name = recordsName, BillingCity = city);
        insert account;
        TestDataFactory.updateContactsAccountSynced(account, recordsName, false);
    }

    @IsTest
    public static void shouldCopyAddressSyncedUpdated() {

        Test.startTest();
        AddressCopierQueryLocator testedInstance = new AddressCopierQueryLocator();
        Database.executeBatch(testedInstance);
        Test.stopTest();

        List<Contact> contacts = [
                SELECT Id, MailingCity, Is_Synced__c,
                        Account.Id, Account.Updated_By_Contact__c
                FROM Contact
                WHERE Is_Synced__c = TRUE AND Account.Updated_By_Contact__c = TRUE
        ];
        System.debug(contacts.size());
        System.assert(contacts.size()==batchSize);
        for(Contact contact : contacts){
            System.assert(contact.MailingCity== city);
        }
    }
}