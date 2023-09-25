/**
 * SObjectUtils
 * This utility class provides a set of methods to facilitate common SOQL operations.
 * It allows for querying, counting, and other SObject-related operations using a streamlined approach.
 */
public class SObjectUtils{
    //class level static variable that is accesible from all the methods
    private static List<Id> bindRecordIds;
    /**
     * Retrieves the object type name based on the provided record ID.
     *
     * @param recordId The ID of the record.
     * @return The name of the object type.
     */
    public static String getObjectTypeBasedOnId(Id recordId){
        Schema.SObjectType objectType = recordId.getSObjectType();
        return objectType.getDescribe().getName();
    }

    /**
     * Retrieves the total count of records for a specific object type, with optional filters.
     *
     * @param request The query request containing object name and optional filters.
     * @return The total count of records.
     */
    public static Long getTotalCount(QueryRequest request){
        bindRecordIds = null; // Reset the bind variable for each query
        SoqlBuilder builder = new SoqlBuilder(request);
        String query = builder.buildCountQuery();
        List<AggregateResult> aggResult = Database.query(query);
        return (Long) aggResult[0].get('result');
    }

    /**
     * Performs a SOQL query based on the provided query request.
     *
     * @param request The query request containing details like object name, fields to select, filters, etc.
     * @return A list of SObjects that match the query criteria.
     */
    public static List<SObject> performQuery(QueryRequest request){
        bindRecordIds = null; // Reset the bind variable for each query
        SoqlBuilder builder = new SoqlBuilder(request);
        String query = builder.buildQuery();
        System.debug(query);
        return Database.query(query);
    }

    /**
     * Casts and compares two objects based on the specified comparison type.
     * Supports comparison for Integer, Decimal, String, Date, and DateTime types.
     *
     * @param objectOne The first object to compare.
     * @param comparisonType The type of comparison to perform (e.g., EQUAL, NOT_EQUAL).
     * @param objectTwo The second object (as a string) to compare against.
     * @return Boolean indicating the result of the comparison.
     * @throws IllegalArgumentException If either object is null or if an unsupported comparison type is provided.
     */
    public static Boolean castAndCompareObjects(Object objectOne, String comparisonType, String objectTwo){
        Boolean result;

        if (objectOne == null){
            throw new IllegalArgumentException('Object one of comparison can\'t be NULL');
        }

        if (objectTwo == null){
            throw new IllegalArgumentException('Object two of comparison can\'t be NULL');
        }

        if (objectOne instanceof Integer){
            Integer valueOne = (Integer) objectOne;
            Integer valueTwo = Integer.valueOf(objectTwo);
            result = compareIntegers(valueOne, valueTwo, comparisonType);
        } else if (objectOne instanceof Decimal){
            Decimal valueOne = (Decimal) objectOne;
            Decimal valueTwo = Decimal.valueOf(objectTwo);
            result = compareDecimals(valueOne, valueTwo, comparisonType);
        } else if (objectOne instanceof String){
            String valueOne = (String) objectOne;
            result = compareStrings(valueOne, objectTwo, comparisonType);
        } else if (objectOne instanceof Date){
            Date valueOne = (Date) objectOne;
            Date valueTwo = Date.valueOf(objectTwo);
            result = compareDates(valueOne, valueTwo, comparisonType);
        } else if (objectOne instanceof DateTime){
            DateTime valueOne = (DateTime) objectOne;
            DateTime valueTwo = DateTime.valueOf(objectTwo);
            result = compareDateTimes(valueOne, valueTwo, comparisonType);
        } else{
            throw new IllegalArgumentException('Unsupported object type for objectOne');
        }

        return result;
    }

    /**
     * Compares two integers based on the specified comparison type.
     *
     * @param valueOne The first integer value.
     * @param valueTwo The second integer value.
     * @param comparisonType The type of comparison to perform.
     * @return Boolean indicating the result of the comparison.
     * @throws IllegalArgumentException If an unsupported comparison type is provided.
     */
    private static Boolean compareIntegers(Integer valueOne, Integer valueTwo, String comparisonType){
        if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.EQUAL){
            return valueOne == valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.NOT_EQUAL){
            return valueOne != valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.GREATER_THAN_OR_EQUAL){
            return valueOne >= valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.LESS_THAN_OR_EQUAL){
            return valueOne <= valueTwo;
        } else{
            throw new IllegalArgumentException('Unsupported comparison type: ' + comparisonType);
        }
    }

    /**
     * Compares two decimals based on the specified comparison type.
     *
     * @param valueOne The first decimal value.
     * @param valueTwo The second decimal value.
     * @param comparisonType The type of comparison to perform.
     * @return Boolean indicating the result of the comparison.
     * @throws IllegalArgumentException If an unsupported comparison type is provided.
     */
    private static Boolean compareDecimals(Decimal valueOne, Decimal valueTwo, String comparisonType){
        if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.EQUAL){
            return valueOne == valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.NOT_EQUAL){
            return valueOne != valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.GREATER_THAN_OR_EQUAL){
            return valueOne >= valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.LESS_THAN_OR_EQUAL){
            return valueOne <= valueTwo;
        } else{
            throw new IllegalArgumentException('Unsupported comparison type: ' + comparisonType);
        }
    }

    /**
     * Compares two strings based on the specified comparison type.
     *
     * @param valueOne The first string value.
     * @param valueTwo The second string value.
     * @param comparisonType The type of comparison to perform.
     * @return Boolean indicating the result of the comparison.
     * @throws IllegalArgumentException If an unsupported comparison type is provided.
     */
    private static Boolean compareStrings(String valueOne, String valueTwo, String comparisonType){
        if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.EQUAL){
            return valueOne == valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.NOT_EQUAL){
            return valueOne != valueTwo;
        } else{
            throw new IllegalArgumentException('Unsupported comparison type: ' + comparisonType);
        }
    }

    /**
     * Compares two dates based on the specified comparison type.
     *
     * @param valueOne The first date value.
     * @param valueTwo The second date value.
     * @param comparisonType The type of comparison to perform.
     * @return Boolean indicating the result of the comparison.
     * @throws IllegalArgumentException If an unsupported comparison type is provided.
     */
    private static Boolean compareDates(Date valueOne, Date valueTwo, String comparisonType){
        if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.EQUAL){
            return valueOne == valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.NOT_EQUAL){
            return valueOne != valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.AFTER ){
            return valueOne > valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.BEFORE ){
            return valueOne < valueTwo;
        } else{
            throw new IllegalArgumentException('Unsupported comparison type: ' + comparisonType);
        }
    }

    /**
     * Compares two date-times based on the specified comparison type.
     *
     * @param valueOne The first date-time value.
     * @param valueTwo The second date-time value.
     * @param comparisonType The type of comparison to perform.
     * @return Boolean indicating the result of the comparison.
     * @throws IllegalArgumentException If an unsupported comparison type is provided.
     */
    private static Boolean compareDateTimes(DateTime valueOne, DateTime valueTwo, String comparisonType){
        if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.EQUAL){
            return valueOne == valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.NOT_EQUAL){
            return valueOne != valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.AFTER ){
            return valueOne > valueTwo;
        } else if (comparisonType == PicklistService.getInstance().sObjectUtils.comparisonTypes.BEFORE ){
            return valueOne < valueTwo;
        } else{
            throw new IllegalArgumentException('Unsupported comparison type: ' + comparisonType);
        }
    }

    /** Method for creating fake Salesforce Ids.
     *  Usage example:
     *  Account a = new Account(Id=getFakeId(Account.SObjectType));
     * @param sot The SObject type, eg. Account.SObjectType or Projekt__c.SObjectType
     * @return A fake Salesforce Id
     */
    public static String getFakeId(Schema.SObjectType sot){
        Integer randomNumber = Integer.valueof((Math.random() * 9));
        String result = String.valueOf(randomNumber);
        return sot.getDescribe().getKeyPrefix() + '0'.repeat(12 - result.length()) + result;
    }

    /**
     * QueryRequest
     * Encapsulates the parameters required for a SOQL query.
     * Includes details like object name, fields to select, filters, and other query-related parameters.
     */
    public class QueryRequest{
        @AuraEnabled
        public String objectName;
        @AuraEnabled
        public List<String> fields;
        @AuraEnabled
        public List<Filter> filtersIn;
        @AuraEnabled
        public List<Filter> filtersLike;
        @AuraEnabled
        public String orderByField;
        @AuraEnabled
        public String orderByDirection;
        @AuraEnabled
        public Integer limitNo;
        @AuraEnabled
        public Integer offset;
        @AuraEnabled
        public List<Id> recordIds;
        @AuraEnabled
        public Boolean sortNullsLast = true;
        public QueryRequest(){
            this.fields = new List<String>();
            this.filtersIn = new List<Filter>();
            this.filtersLike = new List<Filter>();
        }

    }

    /**
     * Filter
     * Represents a filter condition for a SOQL query.
     * Contains the field name, and the values to filter by.
     */
    public class Filter{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String sObjectField;
        @AuraEnabled
        public List<String> selectedValues;
        public Filter(String sObjectField, List<String> selectedValues){
            this.sObjectField = sObjectField;
            this.selectedValues = selectedValues;
        }

    }

    /**
     * SoqlBuilder
     * A builder class to construct SOQL queries based on a provided query request.
     * Allows for building both count and data retrieval queries.
     */
    public class SoqlBuilder{
        private QueryRequest request;
        public SoqlBuilder(QueryRequest request){
            this.request = request;
        }

        public String buildCountQuery(){
            return 'SELECT Count(Id) result FROM ' + request.objectName + buildWhereClause();
        }

        public String buildQuery(){
            String soql = 'SELECT ' + String.join(request.fields, ',') + ' FROM ' + request.objectName;
            soql += buildWhereClause();
            if (request.orderByField != null && request.orderByDirection != null){
                soql += ' ORDER BY ' + request.orderByField + ' ' + request.orderByDirection;
                if (request.sortNullsLast){
                    soql += ' NULLS LAST';
                }
            }
            if (request.limitNo != null){
                soql += ' LIMIT ' + request.limitNo;
            }
            if (request.offset != null){
                soql += ' OFFSET ' + request.offset;
            }
            return soql;
        }

        private String buildWhereClause(){
            List<String> conditions = new List<String>();
            bindRecordIds = request.recordIds;
            if (request.recordIds != null && !request.recordIds.isEmpty()){
                conditions.add('Id IN :bindRecordIds');
            }
            for (Filter filter : request.filtersIn){
                conditions.add(filter.sObjectField + ' IN (\'' + String.join(filter.selectedValues, '\',\'') + '\')');
            }
            for (Filter filter : request.filtersLike){
                List<String> likeConditions = new List<String>();
                for (String value : filter.selectedValues){
                    likeConditions.add(filter.sObjectField + ' LIKE \'%' + value.toLowerCase() + '%\'');
                }
                conditions.add('(' + String.join(likeConditions, ' OR ') + ')');
            }
            return conditions.isEmpty() ? '' : ' WHERE ' + String.join(conditions, ' AND ');
        }

    }

    /**
     * UnsupportedTypeException
     * Custom exception to be thrown when an unsupported type is encountered.
     */
    public class UnsupportedTypeException extends Exception{
    }

}