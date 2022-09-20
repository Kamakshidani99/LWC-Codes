trigger AccountTrigger1 on Account(before insert,after insert){

    if(trigger.IsInsert && trigger.IsBefore){
        AccountTriggerHandler1.validateAccountBeforeInsert(trigger.new);
    }
    if(trigger.IsInsert && trigger.IsAfter){
        AccountTriggerHandler1.insertOpportunity(trigger.new);
    }
}