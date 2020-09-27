/**
 * Created by lina_ on 19.09.2020.
 */

public with sharing class AccountTriggerHandler {
    public static void beforeInsert(List<Account> accounts) {
        AccountTriggerHandlerHelper.copyFaxToPhone(accounts);
    }

    public static void afterInsert(List<Account> accounts) {
        AccountTriggerHandlerHelper.createNewOpportunity(accounts);
        AccountTriggerHandlerHelper.createChildAccount(accounts);
    }

    public static void beforeUpdate(Map<Id, Account> newAccountsByIds) {
        AccountTriggerHandlerHelper.updateDescription(newAccountsByIds);
    }

    public static void afterUpdate(Map<Id, Account> newAccountsByIds, Map<Id, Account> oldAccountsByIds) {
        AccountTriggerHandlerHelper.createNewTaskForHighPriority(newAccountsByIds, oldAccountsByIds);
    }
    public static void beforeDelete(Map<Id, Account> oldAccountsByIds) {
       // AccountTriggerHandlerHelper.restrictDeletionWithOpenTasks(oldAccountsByIds);
    }

    public static void afterDelete(List<Account> accounts) {
        //AccountTriggerHandlerHelper.sendEmailAfterDelete(accounts);
    }

    public static void afterUndelete(List<Account> accounts) {
        //AccountTriggerHandlerHelper.renewDescriptionUndelete(accounts);
    }
}