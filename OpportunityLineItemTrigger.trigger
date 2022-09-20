trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert) {
//We have 
//to prevent user add more than 5 oppLineItem
//1) Consider if user trying to insert more than 5 records from user interface 
//2) If user trying to insert less than 5 records then allow if there is no existing records 

if(trigger.IsInsert && trigger.IsBefore){
    OpportunityLineItemTriggerHandler.preventOLIinsertonopp(trigger.new);
}
}