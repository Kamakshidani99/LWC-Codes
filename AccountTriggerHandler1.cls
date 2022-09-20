public with sharing class AccountTriggerHandler1 {
    public AccountTriggerHandler1() {

    }
    //This method validates Account record
    public static void validateAccountBeforeInsert(List<Account> accountList){
        for(Account acc:accountList){
            if(acc.Type=='Prospect' && acc.Rating==null){
                acc.addError('Please Fill the Rating field if Type is Prospect.');
            }
        }
    }
    //This method inserts Oportunity when account record is created.
    public static void insertOpportunity(List<Account> accountList){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Account acc:accountList){
            Opportunity opp = new Opportunity();
            opp.Name = acc.Name;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.today();
            opp.AccountId = acc.Id;
            oppList.add(opp);
        }
        if(oppList!=null && oppList.size()>0){
            insert oppList;
        }
    }
}