public class InvokerBatchesAddressCopier implements Schedulable {
    public void execute(SchedulableContext ctx) {
        AddressCopierIterable copierIterable = new AddressCopierIterable();
        AddressCopierQueryLocator copierQueryLocator = new AddressCopierQueryLocator();
        Database.executeBatch(copierIterable);
        Database.executeBatch(copierQueryLocator);
    }
}