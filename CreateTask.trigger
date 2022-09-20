trigger CreateTask on Due_Diligence__c (After insert,After Update) {    
    List<Task> insertTask = new List<Task>();    
    for(Due_Diligence__c newDeligence : Trigger.new){
        Task newTask = new Task();
        newTask.subject = 'New Due Deligence is Created Follow Up';
        newTask.whatId = newDeligence.Id;
    //    newTask.ownerId = newDeligence.OwnerId;
        newTask.Status = 'In progress';
        insertTask.add(newTask);
    }
    if(insertTask.size() > 0)
        insert insertTask;
}