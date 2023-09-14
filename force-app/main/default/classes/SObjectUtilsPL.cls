public with sharing class SObjectUtilsPL {
    public final SObjectUtils_ComparisonTypes comparisonTypes = new SObjectUtils_ComparisonTypes();
    public SObjectUtilsPL() {
    }
    public class SObjectUtils_ComparisonTypes {
        public final String EQUAL = 'EQUAL';
        public final String NOT_EQUAL = 'NOT EQUAL';
        public final String GREATER_THAN_OR_EQUAL = 'GREATER THAN OR EQUAL';
        public final String LESS_THAN_OR_EQUAL = 'LESS THAN OR EQUAL';
        public final String AFTER = 'AFTER';
        public final String BEFORE = 'BEFORE';
    }
}
