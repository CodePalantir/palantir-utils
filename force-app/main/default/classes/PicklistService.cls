public with sharing class PicklistService {
    private static PicklistService instance;
    private PicklistService() {
    }

    public static PicklistService getInstance() {
        if (instance == null) {
            instance = new PicklistService();
        }
        return instance;
    }
    public final SObjectUtilsPL sObjectUtils = new SObjectUtilsPL();
}
