/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 02-16-2024
 * @last modified by  : HAVARD Julien
**/
trigger OrderTrigger on Order (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    fflib_SObjectDomain.triggerHandler(OrderDomain.class);
}