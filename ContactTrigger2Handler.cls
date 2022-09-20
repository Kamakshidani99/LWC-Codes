public class ContactTrigger2Handler {
    public ContactTrigger2Handler() {

    }
    public static void countContactonInsert(List<Contact> conList){
        Set<Id> accountIdSet = new Set<Id>();
        for(Contact con:conList){
           if(con.AccountId!=null){
            accountIdSet.add(con.AccountId);
           } 
        }
        //Abstract all contacts associate with the account 
        //update field on account 
        if(accountIdSet!=null && accountIdSet.size()>0){
            //Aggregate Query
            updateAccount(accountIdSet);
        }
    }
    public static void countContactonUpdate(Map<Id, Contact> conNewMap,Map<Id,Contact> conOldMap){
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Account> accountMap = new Map<Id,Account>();
        for(Contact con:conNewMap.values()){
            if(conNewMap.get(con.Id).AccountId!=conOldMap.get(con.Id).AccountId){
                if(conNewMap.get(con.Id).AccountId!=null){
                    accountIdSet.add(conNewMap.get(con.Id).AccountId);
                }
                if(conOldMap.get(con.Id).AccountId!=null){
                    accountIdSet.add(conOldMap.get(con.Id).AccountId);
                }
            }
        }
        if(accountIdSet!=null && accountIdSet.size()>0){
            //Aggregate Query
            updateAccount(accountIdSet);
        }
    }
    public static void countContactonDelete(List<Contact> conList){
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Account> accountMap = new Map<Id,Account>();
        Set<Id> contactIdSet = new Set<Id>();
        for(Contact con:conList){
            If(con.AccountId!=null){
                accountIdSet.add(con.AccountId);
                contactIdSet.add(con.Id);
            }
            
        }
        if(accountIdSet!=null && accountIdSet.size()>0){
            //Aggregate Query
            for(AggregateResult agRes:[select count(id) conCount,AccountId
                                From Contact where AccountId in:accountIdSet and id not in:contactIdSet
                                group by AccountId]){
                Account acc = new Account(id=(Id)agRes.get('AccountId'),
                    Contact_Count__c=(decimal)agRes.get('conCount'));
                accountMap.put(acc.Id,acc);
                }
                if(accountMap!=null && accountMap.size()>0){
                    update accountMap.values();
                }
        }

    }

    public static void updateAccount(Set<Id> accountIdSet){
        Map<Id,Account> accountMap = new Map<Id,Account>();
        //governer limits:- 50,000/1Bilon rows
        for(AggregateResult agRes:[select count(id) conCount,AccountId
                From Contact where AccountId in:accountIdSet
                group by AccountId]){
            Account acc = new Account(id=(Id)agRes.get('AccountId'),
            Contact_Count__c=(decimal)agRes.get('conCount'));
            accountMap.put(acc.Id,acc);
            }
            if(accountMap!=null && accountMap.size()>0){
            update accountMap.values();
            } 
    }
}