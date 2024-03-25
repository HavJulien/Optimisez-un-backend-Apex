/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-22-2024
 * @last modified by  : HAVARD Julien
**/
public interface IAccountSelector extends fflib_ISObjectSelector {
    Schema.SObjectType sObjectType();
	List<SObject> selectSObjectsById(Set<Id> idSet);	
}