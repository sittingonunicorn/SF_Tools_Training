public class AddressCopierIterable implements Database.Batchable<SObject> {
    public Iterable<SObject> start(Database.BatchableContext bc) {
        return [
                SELECT Id, MailingStreet, MailingCity,
                        MailingState, MailingPostalCode, Is_Synced__c,
                        Account.Id, Account.BillingStreet, Account.BillingCity, Account.BillingState,
                        Account.BillingPostalCode, Account.Updated_By_Contact__c
                FROM Contact
                WHERE Is_Synced__c = FALSE
        ];
    }
    public void execute(Database.BatchableContext bc, List<Contact> contacts) {
        List<Account> accounts = new List<Account>();
        for (Contact contact : contacts) {
            Account account = contact.Account;
            contact.MailingStreet = account.BillingStreet;
            contact.MailingCity = account.BillingCity;
            contact.MailingState = account.BillingState;
            contact.MailingPostalCode = account.BillingPostalCode;
            contact.Is_Synced__c = true;
            account.Updated_By_Contact__c = true;
            if (!accounts.contains(account)) {
                accounts.add(account);
            }
        }
        update(accounts);
        update(contacts);
    }
    public void finish(Database.BatchableContext bc) {
    }
}