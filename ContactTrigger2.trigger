trigger ContactTrigger2 on Contact (before insert,after insert, after update, before delete) {
    /*if(trigger.IsInsert && trigger.IsBefore){
        for(Contact con:trigger.new){
            con.LeadSource = 'Web';
        }
    }
    if(trigger.IsAfter){
        if(trigger.IsInsert){
            ContactTrigger2Handler.countContactonInsert(trigger.new);
        }
        if(trigger.IsUpdate){
            ContactTrigger2Handler.countContactonUpdate(trigger.newMap,trigger.oldMap);
        }
    }
    /*if(trigger.IsDelete && trigger.IsBefore){
        ContactTrigger2Handler.countContactonDelete(trigger.old);
    }*/

    //try to use in if statement
    /*if(trigger.operationType == TriggerOperation.BEFORE_DELETE){
        ContactTrigger2Handler.countContactonDelete(trigger.old);
    }*/

    switch on trigger.operationType {
        when BEFORE_INSERT {
            for(Contact con:trigger.new){
                con.LeadSource = 'Web';
            }
        }
        //if you have same business logic and multiple events (when After_INSERT,After_Update)
        when After_INSERT{
            ContactTrigger2Handler.countContactonInsert(trigger.new);
        }
        when BEFORE_DELETE {
            ContactTrigger2Handler.countContactonDelete(trigger.old);
        }
        when AFTER_UPDATE {
            ContactTrigger2Handler.countContactonUpdate(trigger.newMap,trigger.oldMap);
        }
        when else {
            
        }
    }
}