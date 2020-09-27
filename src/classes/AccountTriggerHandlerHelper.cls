/**
 * Created by lina_ on 19.09.2020.
 */

public with sharing class AccountTriggerHandlerHelper {
    public static void copyBillingAddressToShippingAddress(List<Account> accounts) {
        if (TriggerContext.isBeforeRepeatedRun()) {
            return;
        }
        TriggerContext.setBeforeRepeatedRunTrue();
        for (Account account : accounts) {
            if (account.Fax != null && account.Phone == null) {
                account.Phone = account.Fax;
            }
        }
    }

    public static void createNewOpportunity(List<Account> accounts) {
        if (TriggerContext.isAfterRepeatedRun()) {
            return;
        }
        TriggerContext.setAfterRepeatedRunTrue();
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Account account : accounts) {
            Opportunity opportunity = new Opportunity(
                    CloseDate = System.today()+7,
                    Name = account.Name,
                    StageName = 'Prospecting',
                    AccountId = account.Id);
            opportunities.add(opportunity);
        }
        insert opportunities;
        Account account = new Account(Name = 'TestTriggerApexOneAdditional',
                Fax = '33333333', ParentId = accounts.get(0).Id
        );
        insert account;
    }

    public static void updateDescription(Map<Id, Account> newAccountsByIds, Map<Id, Account> oldAccountsByIds) {
        if (TriggerContext.isBeforeRepeatedRun()) {
            return;
        }
        TriggerContext.setBeforeRepeatedRunTrue();
        for (Account account : newAccountsByIds.values()) {
            if (account.Description != null) {
                account.Description = account.Description+'\n updated '+System.now();
            } else {
                account.Description = 'updated '+System.now();
            }
        }
    }

    public static void createNewTaskForHighPriority(
            Map<Id, Account> newAccountsByIds, Map<Id, Account> oldAccountsByIds) {
        if (TriggerContext.isAfterRepeatedRun()) {
            return;
        }
        TriggerContext.setAfterRepeatedRunTrue();
        List<Task> tasks = new List<Task>();
        List <User> activeUsers = [SELECT Id FROM User WHERE IsActive = TRUE];
        for (Account account : newAccountsByIds.values()) {
            if (account.CustomerPriority__c == 'High' &&
                    oldAccountsByIds.get(account.Id).CustomerPriority__c != 'High') {
                Task newTask = new Task(WhatId = account.Id, Subject = 'Negotiations with High priority Account'
                        +account.Name, OwnerId = TaskForNewAccount.getRandomUser(activeUsers).Id);
                tasks.add(newTask);
            }
        }
        insert tasks;
        update [SELECT Id FROM Account WHERE Id IN :newAccountsByIds.values()];
    }

    public static void restrictDeletionWithOpenTasks(Map<Id, Account> oldAccountsByIds) {
        if (TriggerContext.isBeforeRepeatedRun()) {
            return;
        }
        TriggerContext.setBeforeRepeatedRunTrue();
        List<Task> openTasks = [
                SELECT Id, Status, WhatId
                FROM Task
                WHERE WhatId IN :oldAccountsByIds.keySet()
                AND IsClosed = FALSE
        ];
        for (Account account : oldAccountsByIds.values()) {
            for (Task task : openTasks) {
                if (task.WhatId == account.Id) {
                    account.addError('Close all Tasks before deleting Account');
                }
            }
        }
    }

}