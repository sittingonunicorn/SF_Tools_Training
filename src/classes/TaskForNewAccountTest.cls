/**
 * Created by lina_ on 26.09.2020.
 */

@IsTest
public with sharing class TaskForNewAccountTest {
    static String accountName = 'TestTaskForNewAccount ';
    static String taskSubject = 'Negotiations with';
    static Integer recordNumber = 100;

    @TestSetup
    private static void init() {
        TestDataFactory.createAccountList(accountName, recordNumber);
    }

    @IsTest
    private static void shouldAddTaskWhenNewAccount() {
        List<Account> accs = [SELECT Id, Name FROM Account WHERE Name LIKE :accountName+'%'];
        List<TaskForNewAccount.InvocableVariablesWrapper> wrappers =
                new List<TaskForNewAccount.InvocableVariablesWrapper>();
        for (Account acc : accs) {
            initSingleWrapper(acc, wrappers, true);
        }

        Test.startTest();
        TaskForNewAccount.addTaskForUpsertedAccount(wrappers);
        Test.stopTest();

        List<Task> tasks = [SELECT Id, Subject FROM Task WHERE WhatId IN :accs];
        System.assert(tasks != null);
        System.assertEquals(recordNumber, tasks.size());
        for (Task task : tasks) {
            System.assert(task.Subject.contains(taskSubject));
        }
    }

    @IsTest
    private static void shouldReassignTasksWhenUpdatedAccount() {
        Account acc = [SELECT Id, Name FROM Account WHERE Name LIKE :accountName+'%' LIMIT 1];
        List<TaskForNewAccount.InvocableVariablesWrapper> wrappers =
                new List<TaskForNewAccount.InvocableVariablesWrapper>();
        initSingleWrapper(acc, wrappers, false);
        TestDataFactory.addAccountTasks(acc, [SELECT COUNT() FROM Task WHERE WhatId = :acc.Id], taskSubject);

        Test.startTest();
        TaskForNewAccount.addTaskForUpsertedAccount(wrappers);
        Test.stopTest();

        List<Task> accountTasks = [SELECT Id, Subject, OwnerId FROM Task WHERE WhatId = :acc.Id];
        System.assert(accountTasks != null);
        System.assertEquals(3, accountTasks.size());
        System.assertEquals(accountTasks.get(0).OwnerId, accountTasks.get(1).OwnerId);
    }

    private static void initSingleWrapper(Account acc, List<TaskForNewAccount.InvocableVariablesWrapper> wrappers,
            Boolean isNew) {
        TaskForNewAccount.InvocableVariablesWrapper wrapper = new TaskForNewAccount.InvocableVariablesWrapper();
        wrapper.account = acc;
        wrapper.IsNew = isNew;
        wrappers.add(wrapper);
    }
}