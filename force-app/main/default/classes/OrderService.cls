/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-25-2024
 * @last modified by  : HAVARD Julien
**/
public with sharing class OrderService {
    @TestVisible
    private fflib_ISObjectUnitOfWork unitOfWork;

    public OrderService(){
        this.unitOfWork = Application.UOW.newInstance();
    }

    public Decimal calculateNetAmount(Order order){
        Decimal shipmentCost = order?.ShipmentCost__c != null ? order.ShipmentCost__c : 0;
        Decimal totalAmount = order?.TotalAmount != null ? order.TotalAmount : 0;
        return totalAmount - shipmentCost;
    }

    public void updateOrdersNetAmount(List<Order> orderList){
        for(Order order : orderList){
            order.NetAmount__c = calculateNetAmount(order);
        }
    }

    public void updateAccountsGrossRevenueWhenOrdered(Map<Id, SObject> newRecordMap, Map<Id, SObject> oldRecordMap){
        Order oldOrder = new Order();
        Set<Id> accountIds = ListUtils.getSetIdFromFieldId(newRecordMap.values(), 'AccountId');
        Map<Id, Account> accountIdMap = new Map<Id, Account>([SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds]);
        
        for (Order newOrder : (List<Order>) newRecordMap.values()){
            oldOrder = (Order) oldRecordMap.get(newOrder.Id);
            if (isStatusChangedToOrdered(newOrder, oldOrder)){
                Account acc = accountIdMap.get(newOrder.AccountId);
                acc.Chiffre_d_affaire__c += newOrder.TotalAmount;
                this.unitOfWork.registerDirty(acc);
            }
        }

    }

    public Boolean isStatusChangedToOrdered(Order newOrder, Order oldOrder){
        return (newOrder.Status == 'Ordered' && oldOrder.Status != 'Ordered');
    }

    public void commitUnitOfWork(){
            this.unitOfWork.commitWork();
    }
}