/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-26-2024
 * @last modified by  : HAVARD Julien
**/
@IsTest
public with sharing class OrderServiceTest {  
    @IsTest
    static void testCalculateNetAmount(){
        OrderService service = new OrderService();

        Order orderTest = TestDataFactory.generateOrder(false);

        orderTest = setOrderTotalAmount(orderTest, 1000);
        orderTest.ShipmentCost__c = 100;

        Test.startTest();
        Decimal netAmount = service.calculateNetAmount(orderTest);
        Test.stopTest();

        Assert.areEqual((orderTest.TotalAmount - orderTest.ShipmentCost__c), netAmount, 'Net amount calculation is wrongly calculated');
    }

    @IsTest
    static void testUpdateOrdersNetAmount(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        OrderService service = new OrderService();
        List<Order> orderList = TestDataFactory.generateOrders(200, false);

        Test.startTest();
        service.updateOrdersNetAmount(orderList);
        Test.stopTest();

        for (Order order : orderList){
            ((OrderService)mocks.verify(service, 1)).calculateNetAmount(order);
        }     
    }

    @IsTest
    static void testIsStatusChangedToOrdered(){
        OrderService service = new OrderService();
        Order newOrder = TestDataFactory.generateOrder(false);
        Order oldOrder = newOrder.clone();
        newOrder.Status = 'Ordered';

        Test.startTest();
        Boolean statusNotChangedToOrdered = service.isStatusChangedToOrdered(newOrder, newOrder);
        Boolean statusChangedToOrdered = service.isStatusChangedToOrdered(newOrder, oldOrder);
        Test.stopTest();

        Assert.isFalse(statusNotChangedToOrdered, 'The Order status didn\'t change so it should be false');
        Assert.isTrue(statusChangedToOrdered, 'The Order status changed so it should be true');

    }

    @IsTest
    static void testUpdateAccountsGrossRevenueWhenOrdered(){
        OrderService service = new OrderService();
        AccountSelector accSelector = new AccountSelector();

        Integer orderSize = 250;
        Decimal amount = 1000;
        Account acc = TestDataFactory.generateAccount(true);

        List<Order> newOrderList = new List<Order>();
        List<Order> oldOrderList = TestDataFactory.generateOrders(orderSize, acc, true);

        for (Order orderLoop : oldOrderList){
            orderLoop = setOrderTotalAmount(orderLoop, amount);

            Order newOrder = orderLoop.clone(true, true, true, true);
            newOrder.Status = 'Ordered';
            newOrderList.add(newOrder);
        }

        Test.startTest();
        service.updateAccountsGrossRevenueWhenOrdered(new Map<Id, SObject>(newOrderList), new Map<Id, SObject>(oldOrderList));
        service.commitUnitOfWork();
        Test.stopTest();

        acc = (Account) accSelector.selectSObjectsById(new Set<Id>{acc.Id}, new List<String>{'Chiffre_d_affaire__c'})[0];
        Assert.areEqual(orderSize * amount, acc.Chiffre_d_affaire__c, 'The Chiffre_d_affaire__c should have been updated to ' + (orderSize * amount));
    }

    @IsTest
    static void testFailCommitUnitOfWork(){
        Order order = new Order();
        OrderService service = new OrderService();
        Boolean exceptionThrown = false;
        Test.startTest();
        service.unitOfWork.registerNew(order);
        try{
            service.commitUnitOfWork();
        } catch (Exception e){
            exceptionThrown = true;
        }
        Test.stopTest();
        Assert.isTrue(exceptionThrown, 'We should have thrown an exception');
    }

    private static Order setOrderTotalAmount(Order myOrder, Decimal amount){
        return (Order) fflib_ApexMocksUtils.setReadOnlyFields(myOrder, Order.class,
                new Map<SObjectField, Object>{Order.TotalAmount => amount});
    }
}