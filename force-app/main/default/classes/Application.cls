/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-25-2024
 * @last modified by  : HAVARD Julien
**/
public with sharing class Application {
    public static final fflib_Application.UnitOfWorkFactory UOW = new fflib_Application.UnitOfWorkFactory(new List<SObjectType>{
        Account.SObjectType,
        Order.SObjectType
    });
    
    public static final fflib_Application.SelectorFactory SELECTOR = new fflib_Application.SelectorFactory(new Map<SObjectType, Type>{
        Account.SObjectType => AccountSelector.class
    });

    public static final fflib_Application.DomainFactory DOMAIN = new fflib_Application.DomainFactory(selector, new Map<SObjectType,Type>{
        Order.SObjectType => OrderDomain.Constructor.class
    });
}