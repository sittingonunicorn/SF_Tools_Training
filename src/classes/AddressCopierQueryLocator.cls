public class AddressCopierQueryLocator implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('Select Id, MailingStreet, MailingCity, '
                +'MailingState, MailingPostalCode, Is_Synced__c, '
                +'Account.ID, Account.BillingAddress, Account.BillingStreet, Account.BillingCity, Account.BillingState, '
                +'Account.BillingPostalCode, Account.Updated_By_Contact__c '
                +'from Contact where Is_Synced__c = false');
    }
    public void execute(Database.BatchableContext bc, List<Contact> contacts) {
        List<Account> accounts = new List<Account>();
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