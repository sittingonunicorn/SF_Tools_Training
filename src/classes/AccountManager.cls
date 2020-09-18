/**
 * Created by lina_ on 16.09.2020.
 */
@RestResource(UrlMapping = '/Account/*')
global with sharing class AccountManager {

    @HttpGet
    global static Account getAccountById() {
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        return [
                SELECT Id, Name, Phone, Active__c, (SELECT Id, Name FROM Contacts)
                FROM Account
                WHERE Account.Id = :accId
        ];
    }

    @HttpPost
    global static Id createAccount() {
        RestRequest request = RestContext.request;
        Account acc = new Account();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());
        for (String fieldName : params.keySet()) {
            acc.put(fieldName, params.get(fieldName));
        }
        insert acc;
        return acc.Id;
    }

    @HttpDelete
    global static void deleteAccount() {
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account acc = [SELECT Id FROM Account WHERE Account.Id = :accId];
        delete acc;
    }

    @HttpPut
    global static Id upsertAccount(String name, String phone, String id) {
        Account acc = new Account(Id = id, Name = name, Phone = phone);
        upsert acc;
        return acc.Id;
    }

    @HttpPatch
    global static Id updateAccount() {
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account acc = [SELECT Id FROM Account WHERE Account.Id = :accId];
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());
        for (String fieldName : params.keySet()) {
            acc.put(fieldName, params.get(fieldName));
        }
        update acc;
        return acc.Id;
    }

}