/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-22-2024
 * @last modified by  : HAVARD Julien
**/
public inherited sharing class AccountSelector extends fflib_SObjectSelector implements IAccountSelector {
    @TestVisible
    private List<String> additionalFields = new List<String>{
        'Id'
    };

    public Schema.SObjectType getSObjectType() {
      return Account.SObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
      return new List<Schema.SObjectField>{
        Account.Id
      };
    }

    public override List<SObject> selectSObjectsById(Set<Id> idSet){
      if (idSet.isEmpty()) {
        return new List<SObject>();
      }
      return Database.query('SELECT Id FROM Account WHERE Id IN :idSet');
    }

    //Voir utiliser QueryFactory
    public List<SObject> selectSObjectsById(Set<Id> idSet, List<String> additionalFields){
        if (idSet.isEmpty()) {
          return new List<SObject>();
        }
        addAdditionalFieldsToSObjectFields(additionalFields);
        String query = 'SELECT ' + getSObjectAdditionalFieldsAsString() + ' FROM Account WHERE Id IN :idSet';
        return Database.query(query);
    }

    @TestVisible
    private void addAdditionalFieldsToSObjectFields(List<String> additionalFields){
        this.additionalFields.addAll(additionalFields);
    }

    @TestVisible
    private List<String> getSObjectAdditionalFields(){
        return this.additionalFields;
    }

    @TestVisible
    private String getSObjectAdditionalFieldsAsString(){
        return String.join(getSObjectAdditionalFields(), ',');
    }
}
