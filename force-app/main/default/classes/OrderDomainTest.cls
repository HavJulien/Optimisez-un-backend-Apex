/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-26-2024
 * @last modified by  : HAVARD Julien
**/
@isTest
public with sharing class OrderDomainTest {
    @IsTest
    static void testOnBeforeUpdate(){
        Account acc = TestDataFactory.generateAccount(true);
        List<Order> orderList = TestDataFactory.generateOrders(250, acc, true);
        for (Order orderLoop : orderList){
            orderLoop.ShipmentCost__c = 100;
        }
        Test.startTest();
        update orderList;
        Test.stopTest();
        
        List<Order> updatedOrderList = [SELECT Id, NetAmount__c FROM Order];
        Assert.areEqual(orderList.size(), updatedOrderList.size(), 'We should have the same amount of orders');
        for (Order orderLoop : updatedOrderList){
            Assert.areEqual(-100, orderLoop.NetAmount__c, 'The net amount should have been calculated and should be -100');
        }
    }
}