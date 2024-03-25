/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-15-2024
 * @last modified by  : HAVARD Julien
**/
public with sharing class ListUtils {
    public static Set<Id> getSetIdFromFieldId (List<SObject> sobjectList, String fieldName){
        Set<Id> newSetId = new Set<Id>();

        if (!sobjectList.isEmpty() && (sobjectList[0].get(fieldName) instanceOf Id)){
            for (SObject sObjLoop : sobjectList){
                newSetId.add((Id) sObjLoop.get(fieldName));
            }
        }
        return newSetId;
    }
}