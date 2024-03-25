/**
 * @description       : 
 * @author            : HAVARD Julien
 * @group             : 
 * @last modified on  : 03-25-2024
 * @last modified by  : HAVARD Julien
**/
global class UpdateAccounts implements Database.Batchable<sObject>{
    private fflib_ISObjectUnitOfWork unitOfWork;

    global Database.QueryLocator start(Database.BatchableContext info){
        return Database.getQueryLocator('SELECT Id, Name, Chiffre_d_affaire__c, (SELECT Id, TotalAmount FROM Orders WHERE TotalAmount != 0) FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = \'Ordered\')');
    }
    
    global void execute(Database.BatchableContext info, List<Account> scope){  
        fflib_ISObjectUnitOfWork unitOfWork = Application.UOW.newInstance();

        for (Account acc : scope){
            acc.Chiffre_d_affaire__c = 0;
            for (Order order : acc.Orders){
                acc.Chiffre_d_affaire__c += order.TotalAmount;
            }
            unitOfWork.registerDirty(acc);
        }
        unitOfWork.commitWork();
    }    
    
    global void finish(Database.BatchableContext info){    
    } 
}