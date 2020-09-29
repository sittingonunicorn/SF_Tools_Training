/**
 * Created by lina_ on 27.09.2020.
 */

@IsTest
public with sharing class AccountTriggerTest {
    static String accountName = 'TestTrigger';
    static String faxNumber = '12345678';
    static String descriptionPart = 'updated';
    static String subjectPattern = 'Negotiations with High priority%';
    static String priority = 'High';

    @IsTest
    public static void shouldCopyFaxWhenInsert() {
        Account account = new Account(Name = accountName, Fax = faxNumber);

        Test.startTest();
        Database.SaveResult result = Database.insert(account, false);
        Test.stopTest();

        System.assert(result.isSuccess());
        System.assertEquals(faxNumber, [SELECT Id, Phone FROM Account WHERE Id = :result.getId()].Phone);
    }

    @IsTest
    public static void shouldCreateOpportunityWhenInsert() {
        Account account = new Account(Name = accountName);

        Test.startTest();
        Database.SaveResult result = Database.insert(account, false);
        Test.stopTest();

        System.assert(result.isSuccess());
        System.assertEquals(1, [SELECT Id FROM Opportunity WHERE AccountId = :result.getId()].size());
    }

    @IsTest
    public static void shouldCreateChildAccountWhenInsert() {
        Account account = new Account(Name = accountName);

        Test.startTest();
        Database.SaveResult result = Database.insert(account, false);
        Test.stopTest();

        System.assert(result.isSuccess());
        System.assertEquals(1, [SELECT Id FROM Account WHERE ParentId = :result.getId()].size());
    }

    @IsTest
    public static void shouldUpdateDescriptionWhenUpdate() {
        Account account = new Account(Name = accountName);
        insert account;
        account.Fax = faxNumber;

        Test.startTest();
        Database.SaveResult result = Database.update(account, false);
        Test.stopTest();

        System.assert(result.isSuccess());
        System.assert([SELECT Id, Description FROM Account WHERE Id = :result.id]
                .Description.contains(descriptionPart));
    }

    @IsTest
    public static void shouldCreateTaskWhenUpdateHighPriority() {
        Account account = new Account(Name = accountName);
        insert account;
        account.CustomerPriority__c = priority;

        Test.startTest();
        Database.SaveResult result = Database.update(account, false);
        Test.stopTest();

        List<Task> tasks = [
                SELECT Id, Subject, OwnerId
                FROM Task
                WHERE WhatId = :account.Id
                AND Subject LIKE :subjectPattern
        ];
        System.assert(result.isSuccess());
        System.assert(tasks != null);
        System.assert(tasks.size() == 1);
    }
}