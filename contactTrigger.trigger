trigger ContactTrigger on Contact (before insert) {
    if(trigger.IsInsert && trigger.IsBefore){
        Contact con = trigger.new[0];
        con.LeadSource = 'Web';
    }
}