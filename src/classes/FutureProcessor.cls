public class FutureProcessor {
@future
    public static void setProcessedFuture(){
        List<Account> accounts = [Select Id, Name, BillingAddress,
                              (Select Id, LastName, Is_Synced__c, Processed_By_Future__c  from Contacts) From Account limit 150];
        List<Contact> contacts = new List<Contact>();
        for(Account account:accounts){
            if(account.BillingAddress != null){
                contacts.addAll(account.Contacts);
            }
        }
        for(Contact contact:contacts){
            contact.Is_Synced__c = false;
            contact.Processed_By_Future__c = true;
        }
        update(contacts);
    }
}