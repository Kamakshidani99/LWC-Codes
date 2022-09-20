trigger AccountTrigger on Account (before insert,after insert, after update, before delete) {

    if(trigger.IsInsert && trigger.IsBefore){
        AccountTriggerHandler.validateAccountBeforeInsert(trigger.new);
    }
    if(trigger.IsInsert && trigger.IsAfter){
        AccountTriggerHandler.insertContact(trigger.new);
    }
    if(trigger.IsUpdate && trigger.IsAfter){
        AccountTriggerHandler.createOpportunity(trigger.newMap, trigger.oldMap);
    }
    if(trigger.IsDelete && trigger.IsBefore){
        AccountTriggerHandler.preventAccountDeletion(trigger.old);
    }

}