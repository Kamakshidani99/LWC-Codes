public with sharing class OpportunityLineItemTriggerHandler {
    public static void preventOLIinsertonopp(List<OpportunityLineItem> oliList){
        //Set of Id to hold Opp Id set
        Set<Id> oppIdSet = new Set<Id>();
        Map<Id,Integer> oppIdoliCountMap = new Map<Id,Integer>();
        //have to update Map to count oppIdoliCountMap and how to prepare oppIdSet
        
        //preparation of Map for inserting OLI 
        for(OpportunityLineItem oli:oliList){
            oppIdSet.add(oli.OpportunityId);
            if(oppIdoliCountMap.get(oli.OpportunityId)!=null){
                oppIdoliCountMap.put(oli.OpportunityId,oppIdoliCountMap.get(oli.OpportunityId)+1);
            }
            else{
                oppIdoliCountMap.put(oli.OpportunityId,1);
            }
            
        }

        //Preparation or updating oppIdoliCountMap for existing line items
        for(AggregateResult agRes:[select count(id) oliCount, OpportunityId
                            from OpportunityLineItem where OpportunityId in:oppIdSet
                            group by OpportunityId]){
            if(oppIdoliCountMap.get((id)agRes.get('OpportunityId'))!=null){
                oppIdoliCountMap.put((id)agRes.get('OpportunityId'),
                 oppIdoliCountMap.get((id)agRes.get('OpportunityId'))+(integer)agRes.get('oliCount'));
            }
            else{
                oppIdoliCountMap.put((id)agRes.get('OpportunityId'),(integer)agRes.get('oliCount'));
            }
        }

        //Preventing starts
        for(OpportunityLineItem oli:oliList){
            if(oppIdoliCountMap.get(oli.OpportunityId)!=null && oppIdoliCountMap.get(oli.OpportunityId)>5){
               // oli.addError('You cannot add more than 5 Opportunity products');
               oli.addError(Label.OLI_Error);
            }
        }
    }
}