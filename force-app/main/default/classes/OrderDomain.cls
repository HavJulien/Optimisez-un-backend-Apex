/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-25-2024
 * @last modified by  : HAVARD Julien
**/
public with sharing class OrderDomain extends fflib_SObjectDomain implements IOrderDomain{
    public OrderDomain(List<Order> sObjectList){
		super(sObjectList);
	}

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList){
            return new OrderDomain(sObjectList);
        }
    }

    @TestVisible
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords){
        OrderService service = new OrderService();
        service.updateOrdersNetAmount(Records);
    }

    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
        OrderService service = new OrderService();
        service.updateAccountsGrossRevenueWhenOrdered(new Map<Id, SObject>(Records), existingRecords);
        service.commitUnitOfWork();
    }
}