/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-25-2024
 * @last modified by  : HAVARD Julien
**/
@IsTest
public inherited sharing class AccountSelectorTest{
    @IsTest
    static void testGetSObjectType(){
        AccountSelector selector = new AccountSelector();
        
        Test.startTest();
        Schema.SObjectType objType = selector.getSObjectType();
        Test.stopTest();

        Assert.areEqual(Account.getSObjectType(), objType, 'The SObjectType type should be Account.SObjectType !');
    }

    @IsTest
    static void testSelectSObjectsById(){
        Account acc1 = TestDataFactory.generateAccount(true);
        Account acc2 = TestDataFactory.generateAccount(true);
        AccountSelector selector = new AccountSelector();

        Test.startTest();
        Set<Id> accountIdSet = new Set<Id>();
        accountIdSet.add(acc1.Id);
        accountIdSet.add(acc2.Id);
        List<Account> accountList = selector.selectSObjectsById(accountIdSet);
        Test.stopTest();

        Assert.isFalse(accountList.isEmpty(), 'We should have found and selected accounts');
        Assert.isTrue(accountList.size() == accountIdSet.size(), 'We should have selected 2 accounts');
        List<Id> accountIdList = new List<Id>(new Map<Id, Account>(accountList).keySet());
        for (Account acc :accountList){
            Assert.isTrue(accountIdSet.contains(acc.Id), 'The account Id from the selected list should be in the initial set');
        }
    }

    @isTest
    static void testSelectSObjectsByIdEmptySetId(){
        Account acc1 = TestDataFactory.generateAccount(true);
        Account acc2 = TestDataFactory.generateAccount(true);
        AccountSelector selector = new AccountSelector();
        List<String> additionalFields = new List<String>{
            'Chiffre_d_affaire__c'
        };

        Set<Id> accountIdSet = new Set<Id>();
        Test.startTest();
        List<Account> accountList = selector.selectSObjectsById(accountIdSet);
        Test.stopTest();

        Assert.isTrue(accountList.isEmpty(), 'With an empty setId the returning selected list should be null');
    }

    @IsTest
    static void testSelectSObjectsByIdWithFields(){
        Account acc1 = TestDataFactory.generateAccount(true);
        Account acc2 = TestDataFactory.generateAccount(true);
        AccountSelector selector = new AccountSelector();
        List<String> additionalFields = new List<String>{
            'Chiffre_d_affaire__c'
        };

        Test.startTest();
        Set<Id> accountIdSet = new Set<Id>();
        accountIdSet.add(acc1.Id);
        accountIdSet.add(acc2.Id);
        List<Account> accountList = selector.selectSObjectsById(accountIdSet, additionalFields);
        Test.stopTest();

        Assert.isFalse(accountList.isEmpty(), 'We should have found and selected accounts');
        Assert.isTrue(accountList.size() == accountIdSet.size(), 'We should have selected 2 accounts');
        List<Id> accountIdList = new List<Id>(new Map<Id, Account>(accountList).keySet());
        for (Account acc :accountList){
            Assert.isTrue(accountIdSet.contains(acc.Id), 'The account Id from the selected list should be in the initial set');
            Assert.isNotNull(acc.Chiffre_d_affaire__c, 'The additional queried field should be accessible and not null');
        }
    }

    @isTest
    static void testSelectSObjectsByIdWithFieldsEmptySetId(){
        Account acc1 = TestDataFactory.generateAccount(true);
        Account acc2 = TestDataFactory.generateAccount(true);
        AccountSelector selector = new AccountSelector();
        List<String> additionalFields = new List<String>{
            'Chiffre_d_affaire__c'
        };

        Set<Id> accountIdSet = new Set<Id>();
        Test.startTest();
        List<Account> accountList = selector.selectSObjectsById(accountIdSet, additionalFields);
        Test.stopTest();

        Assert.isTrue(accountList.isEmpty(), 'With an empty setId the returning selected list should be null');
    }

    @IsTest
    static void testAddAdditionalFieldsToSObjectFields(){
        AccountSelector selector = new AccountSelector();
        List<String> additionalFields = new List<String>{
            'Chiffre_d_affaire__c'
        };
        Test.startTest();
        Integer initialListSize = selector.additionalFields.size();
        selector.addAdditionalFieldsToSObjectFields(additionalFields);
        Test.stopTest();
        Assert.areNotEqual(initialListSize, selector.additionalFields.size(), 'The initial field size should be have been updated');
        Assert.areEqual(initialListSize + additionalFields.size(), selector.additionalFields.size(), 'We should have added ' + additionalFields.size() + ' to the field list');
    }

    @IsTest
    static void testGetSObjectAdditionalFields(){
        AccountSelector selector = new AccountSelector();
        Test.startTest();
        List<String> additionalFields = selector.getSObjectAdditionalFields();
        Test.stopTest();

        Assert.isNotNull(additionalFields, 'We should have a returned a list');
        Assert.isFalse(additionalFields.isEmpty(), 'We should not have an empty list from the additional field selector');
    }

    @IsTest
    static void testGetSObjectAdditionalFieldsAsString(){
        AccountSelector selector = new AccountSelector();
        List<String> additionalFields = new List<String>{
            'Chiffre_d_affaire__c'
        };
        selector.addAdditionalFieldsToSObjectFields(additionalFields);
        Test.startTest();
        String listAsString = selector.getSObjectAdditionalFieldsAsString();
        Test.stopTest();
        
        Assert.isNotNull(listAsString, 'We should have returned a String');
        Assert.areEqual('Id,Chiffre_d_affaire__c', listAsString, 'The field list as string should be matching');
    }
}
