/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-25-2024
 * @last modified by  : HAVARD Julien
**/
public interface IOrderDomain extends fflib_ISObjects
{
	void onBeforeUpdate(Map<Id,SObject> existingRecords);
    void onAfterUpdate(Map<Id, SObject> existingRecords);
}