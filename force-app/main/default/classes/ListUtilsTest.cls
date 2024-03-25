/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-17-2024
 * @last modified by  : HAVARD Julien
**/
@isTest
public with sharing class ListUtilsTest {
    @IsTest
    static void testGetSetIdFromFieldId(){
        Account account1 = TestDataFactory.generateAccount(1, false);
        account1.Id = fflib_IdGenerator.generate(Account.SObjectType);
        Account account2 = TestDataFactory.generateAccount(2, false);
        account2.Id = fflib_IdGenerator.generate(Account.SObjectType);

        List<Orders> orderList = TestDataFactory.generateOrders(3, account1, false);
        orderList.add(TestDataFactory.generateOrders(2, account2, false));

        Set<Id> accountSetId = new Set<Id>();
        Test.startTest();
            accountSetId.add(ListUtils.getSetIdFromFieldId(orderList, 'AccountId'));
        Test.stopTest();
        
        Assert.isFalse(accountSetId.isEmpty(), 'The account set id shouldn\'t be empty');
        Assert.isTrue(2, accountSetId.size(), 'We should have 2 discincts Ids');
        Assert.isTrue(accountSetId.contains(account1.Id), 'The first account Id should be in the set');
        Assert.isTrue(accountSetId.contains(account2.Id), 'The second account Id should be in the set');
    }
}