/**
 * Created by lina_ on 27.09.2020.
 */

@IsTest
public with sharing class TestDataFactory {
    public static void createAccountList(String accountName, Integer recordNumber) {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < recordNumber; i++) {
            Account acc = new Account(Name = accountName+i);
            accs.add(acc);
        }
        insert accs;
    }

    public static void createContactList(String lastName, Integer recordNumber) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < recordNumber; i++) {
            Contact contact = new Contact(LastName = lastName+i);
            contacts.add(contact);
        }
        insert contacts;
    }

    public static void createSingleAccount(String accountName) {
        Account acc = new Account(Name = accountName);
        insert acc;
    }

    public static void addAccountTasks(Account account, Integer tasksNumber, String taskSubject) {
        List <User> activeUsers = [SELECT Id FROM User WHERE IsActive = TRUE];
        List<Task> tasks = new List<Task>();
        if (tasksNumber >= 3 || tasksNumber < 0) {
            return;
        } else {
            for (Integer i = 0; i < (3-tasksNumber); i++) {
                Task newTask = new Task(WhatId = account.Id, Subject = taskSubject+account.Name,
                        OwnerId = activeUsers.get(Math.mod(activeUsers.size(), i+1)).Id);
                tasks.add(newTask);
            }
            insert tasks;
        }
    }
}