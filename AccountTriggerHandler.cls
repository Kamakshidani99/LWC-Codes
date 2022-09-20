public with sharing class AccountTriggerHandler {
    public AccountTriggerHandler() {

    }
    //This method validates Account Record
    public static void validateAccountBeforeInsert(List<Account> accountList){
        for(Account acc:accountList){
            if(acc.Rating=='Hot' && acc.Type==null){
                acc.addError('Account Type is mandaotry when Rating is Hot.');
            }
        }
    }
    //This method inserts a contact when account is inserted
    public static void insertContact(List<Account> accountList){
        List<Contact> conList = new List<Contact>();
        for(Account acc:accountList){
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.AccountId = acc.Id;
            //for single record insert
            //insert con;
            //for more than 100 records insert in contact
            conList.add(con);
        }
        if(conList!=null && conList.size()>0){
            insert conList;
        }
    }
    //This method insert Opportunty when account Rating is updated to Hot
    //trigger.newMap will be in the format Map<id,sObject>
    public static void createOpportunity(Map<id,Account> acctNewMap, Map<id,Account> acctOldMap){
        List<Opportunity> oppList = new List<Opportunity>();
        //fetching the values in a list
        for(Account acc:acctNewMap.values()){
            //compare old value of Rating with new value of Rating 
            //check weather Rating is Hot or not
            //it is giving account record but old version of account
            if(acctNewMap.get(acc.Id).Rating!=acctOldMap.get(acc.Id).Rating
             && acctNewMap.get(acc.Id).Rating=='Hot'){
                Opportunity opp = new Opportunity();
                opp.AccountId = acc.Id;
                opp.Name = acc.Name;
                opp.StageName = 'Need Analysis';
                opp.CloseDate = System.today().addDays(3);
                oppList.add(opp);
             }
        }
        if(!oppList.isEmpty()){
            try{
                insert oppList;
            }
            catch(Exception e){
                System.debug('eg:' +e.getMessage());
            }
            
        }
    }
    public static void preventAccountDeletion(List<Account> accList){
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,boolean> accountIdisPrimaryMap = new Map<Id,boolean>();
        //Preparation of accountIdSet
        for(Account acc:accList){
            accountIdSet.add(acc.Id);
        }
        //prepaaration of Map
        if(accountIdSet!=null && accountIdSet.size()>0){
            //accountIdSet for seperate, if we put accList it means all account list/records
            for(Contact con:[Select id, AccountId, isPrimary__c From Contact 
                where accountId in: accountIdSet and isPrimary__c = true]){
                    accountIdisPrimaryMap.put(con.AccountId, con.isPrimary__c);
                }
        }
        //start validating and prevent
        for(Account acc:accList){
            if(accountIdisPrimaryMap.get(acc.Id)!=null && accountIdisPrimaryMap.get(acc.Id)==true){
                acc.addError('you cannot delete account');
            }
        }
    }
}