public class AddressCopierIterable implements Database.Batchable<SObject> {
    public Iterable<SObject> start(Database.BatchableContext bc) {
        return [
                SELECT Id, MailingStreet, MailingCity,
                        MailingState, MailingPostalCode, MailingAddress, Is_Synced__c,
                        Account.Id, Account.BillingAddress, Account.BillingStreet, Account.BillingCity, Account.BillingState,
                        Account.BillingPostalCode, Account.Updated_By_Contact__c
                FROM Contact
                WHERE Is_Synced__c = FALSE
        ];
    }
    public void execute(Database.BatchableContext bc, List<Contact> contacts) {
        Set<Account> accounts = new Set<Account>();
        for (Contact contact : contacts) {
            Account account = contact.Account;
            if (account.BillingAddress != null) {
                contact.MailingStreet = account.BillingStreet;
                contact.MailingCity = account.BillingCity;
                contact.MailingState = account.BillingState;
                contact.MailingPostalCode = account.BillingPostalCode;
            }
            contact.Is_Synced__c = true;
            account.Updated_By_Contact__c = true;
            accounts.add(account);
        }
        update(new List<Account> (accounts));
        update(contacts);
    }
    public void finish(Database.BatchableContext bc) {
    }
}