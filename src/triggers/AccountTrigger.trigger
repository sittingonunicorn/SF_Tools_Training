/**
 * Created by lina_ on 19.09.2020.
 */

trigger AccountTrigger on Account (before insert, before update, before delete, after insert,
        after update, after delete, after undelete) {
    if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHandler.beforeInsert(Trigger.new);
    } else if (Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.afterInsert(Trigger.new);
    } else if (Trigger.isBefore && Trigger.isUpdate) {
        AccountTriggerHandler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
    } else if (Trigger.isAfter && Trigger.isUpdate) {
        AccountTriggerHandler.afterUpdate(Trigger.newMap, Trigger.oldMap);
    } else if (Trigger.isBefore && Trigger.isDelete) {
        AccountTriggerHandler.beforeDelete(Trigger.oldMap);
    } else if (Trigger.isAfter && Trigger.isDelete) {
        AccountTriggerHandler.afterDelete( Trigger.old);
    } else if (Trigger.isUndelete) {
        AccountTriggerHandler.afterUndelete(Trigger.new);
    }
}