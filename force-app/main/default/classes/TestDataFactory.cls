/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-22-2024
 * @last modified by  : HAVARD Julien
**/
@IsTest
public with sharing class TestDataFactory {
    private static List<SObject> sObjectListToCreate = new List<SObject>();

    public static Account generateAccount(Boolean isInserted){
        return generateAccount('', isInserted);
    }

    public static Account generateAccount(String name, Boolean isInserted){
        Account acc = new Account(
            Name = 'Test Account ' + name,
            Chiffre_d_affaire__c = 0
        );
        if (isInserted){
            insert acc;
        }
        return acc;
    }

    public static Order generateOrder(Boolean isInserted){
        return generateOrder('', new Account(), isInserted);
    }

    public static Order generateOrder(String name, Boolean isInserted){
        return generateOrder(name, new Account(), isInserted);
    }

    public static Order generateOrder(String name, Account acc, Boolean isInserted){
        Order order = new Order(
            Name = 'Test Order ' + name,
            Status = 'Draft',
            AccountId = acc?.Id,
            EffectiveDate = Date.today()
        );
        if (isInserted){
            insert order;
        }
        return order;
    }

    public static List<Order> generateOrders(Integer orderListSize, Boolean isInserted){
        return generateOrders(orderListSize, new Account(), isInserted);
    }

    public static List<Order> generateOrders(Integer orderListSize, Account acc, Boolean isInserted){
        List<Order> orderList = new List<Order>();
        for (Integer orderNumber = 1; orderNumber < orderListSize + 1; orderNumber ++){
            orderList.add(generateOrder(String.valueOf(orderNumber), acc, false));
        }
        if (isInserted){
            insert orderList;
        }
        return orderList;
    }
}