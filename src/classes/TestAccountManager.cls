/**
 * Created by lina_ on 27.09.2020.
 */

@IsTest
public with sharing class TestAccountManager {
    public static String ENDPOINT_URL = 'https://eu27.salesforce.com/services/apexrest/Account/';
    public static String accountName = 'TestAccountManager';
    public static String accountPhone = '12345678';

    @TestSetup
    public static void init() {
        Account account = new Account(Name = accountName);
        insert account;
    }
    @IsTest
    private static void shouldReturnAccountWhenGivenId() {
        Account account = [SELECT Id, Name FROM Account WHERE Name = :accountName];
        RestRequest request = new RestRequest();
        request.requestURI = ENDPOINT_URL+account.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;
        Test.startTest();
        Account result = AccountManager.getAccountById();
        Test.stopTest();
        System.assert(result != null);
        System.assertEquals(accountName, result.Name);
    }

    @IsTest
    private static void shouldReturnIdWhenCreateRecord() {
        RestRequest request = new RestRequest();
        request.requestURI = ENDPOINT_URL;
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{"name":"'+accountName+'", "phone":"'+accountPhone+'"}');
        RestContext.request = request;
        Test.startTest();
        Id accountId = AccountManager.createAccount();
        Test.stopTest();
        Account account = [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId];
        System.assert(account!=null);
        System.assertEquals(accountName, account.Name);
        System.assertEquals(accountPhone, account.Phone);
    }

    @IsTest
    private static void shouldDeleteAccountWhenGivenId(){
        Account account = [SELECT Id, Name FROM Account WHERE Name = :accountName];
        RestRequest request = new RestRequest();
        request.requestURI = ENDPOINT_URL+account.Id;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        Test.startTest();
        AccountManager.deleteAccount();
        Test.stopTest();
        List<Account> result = [SELECT Id, Name, Phone FROM Account WHERE Id = :account.Id];
        System.assert(result.size()==0);
    }

    @IsTest
    private static void shouldCreateAccountWhenPutId (){
        Test.startTest();
        Id accountId = AccountManager.upsertAccount(accountName, accountPhone, null);
        Test.stopTest();
        System.assert(accountId!=null);
        Account account = [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId];
        System.assert(account!=null);
        System.assert(account.Name == accountName);
    }

    @IsTest
    private static void shouldUpdateAccountWhenPut (){
        Account account = [SELECT Id, Name FROM Account WHERE Name = :accountName];
        Test.startTest();
        Id accountId = AccountManager.upsertAccount(accountName+'1', accountPhone, account.Id);
        Test.stopTest();
        System.assertEquals(account.Id, accountId);
        Account result = [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId];
        System.assert(result!=null);
        System.assert(result.Name == accountName+'1');
    }

    @IsTest
    private static void shouldUpdateAccountWhenPatch (){
        Account account = [SELECT Id, Name FROM Account WHERE Name = :accountName];
        RestRequest request = new RestRequest();
        request.requestURI = ENDPOINT_URL+account.Id;
        request.httpMethod = 'PATCH';
        request.requestBody = Blob.valueOf('{"name":"'+accountName+'1'+'", "phone":"'+accountPhone+'"}');
        RestContext.request = request;
        Test.startTest();
        Id accountId = AccountManager.updateAccount();
        Test.stopTest();
        System.assert(accountId!=null);
        Account result = [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId];
        System.assert(result!=null);
        System.assert(result.Name == accountName+'1');
    }
}