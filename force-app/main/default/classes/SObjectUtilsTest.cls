@IsTest
public class SObjectUtilsTest{
    @IsTest
    public static void getObjectTypeBasedOnId_shouldReturnCorrectType(){
        //Having
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(AccountId = acc.Id, LastName = 'Test Contact', Email = 'test@example.com');
        insert con;

        //When
        Test.startTest();
        String objectTypeContact = SObjectUtils.getObjectTypeBasedOnId(con.Id);
        String objectTypeAccount = SObjectUtils.getObjectTypeBasedOnId(acc.Id);
        Test.stopTest();

        //Then:
        System.assertEquals('Contact', objectTypeContact);
        System.assertEquals('Account', objectTypeAccount);
    }

    @IsTest
    public static void performQueryBasedOnFields_singleId_shouldReturnResult(){
        //Having
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(AccountId = acc.Id, LastName = 'Test Contact', Email = 'test@example.com');
        insert con;

        SObjectUtils.QueryRequest request = new SObjectUtils.QueryRequest();
        request.objectName = 'Contact';
        request.fields = new List<String>{ 'LastName', 'Email' };
        request.recordIds = new List<Id>{ con.Id };

        //When
        Test.startTest();
        List<SObject> results = SObjectUtils.performQuery(request);
        Test.stopTest();

        //Then
        System.assertEquals(1, results.size());
        System.assertEquals('Test Contact', (String) results[0].get('LastName'));
        System.assertEquals('test@example.com', (String) results[0].get('Email'));
    }

    @IsTest
    public static void performQueryBasedOnFields_noId_shouldReturnResult(){
        //Having
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(AccountId = acc.Id, LastName = 'Test Contact', Email = 'test@example.com');
        insert con;

        SObjectUtils.QueryRequest request = new SObjectUtils.QueryRequest();
        request.objectName = 'Contact';
        request.fields = new List<String>{ 'LastName', 'Email' };

        //When
        Test.startTest();
        List<SObject> results = SObjectUtils.performQuery(request);
        Test.stopTest();

        //Then
        System.assertEquals(1, results.size());
        System.assertEquals('Test Contact', (String) results[0].get('LastName'));
        System.assertEquals('test@example.com', (String) results[0].get('Email'));
    }

    @IsTest
    public static void performLimitOffSetQuery_noId_shouldReturnResults(){
        //Having
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i <= 10; i++){
            contacts.add(new Contact(AccountId = acc.Id, LastName = 'Test Contact No. ' + i, Email = 'test_' + i + '@example.com'));
        }
        insert contacts;

        SObjectUtils.QueryRequest requestPage1 = new SObjectUtils.QueryRequest();
        requestPage1.objectName = 'Contact';
        requestPage1.fields = new List<String>{ 'LastName', 'Email' };
        requestPage1.limitNo = 5;
        requestPage1.offset = 0;

        SObjectUtils.QueryRequest requestPage2 = requestPage1.clone();
        requestPage2.offset = 5;

        SObjectUtils.QueryRequest requestPage3 = requestPage1.clone();
        requestPage3.offset = 10;

        //When
        Test.startTest();
        List<SObject> resultsPage1 = SObjectUtils.performQuery(requestPage1);
        List<SObject> resultsPage2 = SObjectUtils.performQuery(requestPage2);
        List<SObject> resultsPage3 = SObjectUtils.performQuery(requestPage3);
        Test.stopTest();

        //Then
        System.assertEquals(5, resultsPage1.size(), 'Incorrect resultset list size');
        System.assertEquals(5, resultsPage2.size(), 'Incorrect resultset list size');
        System.assertEquals(1, resultsPage3.size(), 'Incorrect resultset list size');
    }

    @IsTest
    public static void performQueryWithFilters_noId_shouldReturnResults(){
        //Having
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i <= 10; i++){
            contacts.add(new Contact(AccountId = acc.Id, LastName = 'Test Contact No. ' + i, Email = 'test_' + i + '@example.com'));
        }
        insert contacts;

        SObjectUtils.QueryRequest request = new SObjectUtils.QueryRequest();
        request.objectName = 'Contact';
        request.fields = new List<String>{ 'LastName', 'Email' };
        request.filtersIn = new List<SObjectUtils.Filter>{ new SObjectUtils.Filter('Email', new List<String>{ 'test_1@example.com', 'test_2@example.com' }), new SObjectUtils.Filter('LastName', new List<String>{ 'Test Contact No. 1', 'Test Contact No. 2' }) };

        //When
        Test.startTest();
        List<SObject> results = SObjectUtils.performQuery(request);
        Test.stopTest();

        //Then
        System.assertEquals(2, results.size(), 'Incorrect Number of items returned');
    }

    @IsTest
    public static void performQueryWithFilters_withOrderBy_shouldReturnResults(){
        //Having
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i <= 10; i++){
            contacts.add(new Contact(AccountId = acc.Id, LastName = 'Test Contact No. ' + i, Email = 'test_' + i + '@example.com'));
        }
        insert contacts;

        SObjectUtils.QueryRequest request = new SObjectUtils.QueryRequest();
        request.objectName = 'Contact';
        request.fields = new List<String>{ 'LastName', 'Email' };
        request.filtersIn = new List<SObjectUtils.Filter>{ new SObjectUtils.Filter('Email', new List<String>{ 'test_1@example.com', 'test_2@example.com' }), new SObjectUtils.Filter('LastName', new List<String>{ 'Test Contact No. 1', 'Test Contact No. 2' }) };
        request.orderByField = 'LastName';
        request.orderByDirection = 'ASC';

        //When
        Test.startTest();
        List<SObject> results = SObjectUtils.performQuery(request);
        Test.stopTest();

        //Then
        System.assertEquals(2, results.size(), 'Incorrect Number of items returned');
    }

    @IsTest
    public static void performQuery_withFiltersLike_shouldReturnResults(){
        //Having
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i <= 10; i++){
            contacts.add(new Contact(AccountId = acc.Id, LastName = 'Test Contact No. ' + i, Email = 'test_' + i + '@example.com'));
        }
        insert contacts;

        SObjectUtils.QueryRequest request = new SObjectUtils.QueryRequest();
        request.objectName = 'Contact';
        request.fields = new List<String>{ 'LastName', 'Email' };
        request.filtersLike = new List<SObjectUtils.Filter>{ new SObjectUtils.Filter('Email', new List<String>{ 'test_1' }) };
        request.orderByField = 'LastName';
        request.orderByDirection = 'ASC';

        //When
        Test.startTest();
        List<SObject> results = SObjectUtils.performQuery(request);
        Test.stopTest();

        //Then
        System.assertEquals(2, results.size(), 'Incorrect Number of items returned');
    }

    @IsTest
    public static void performCountOfItems_shouldReturnResult(){
        //Having
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i <= 10; i++){
            contacts.add(new Contact(AccountId = acc.Id, LastName = 'Test Contact No. ' + i, Email = 'test_' + i + '@example.com'));
        }
        insert contacts;

        SObjectUtils.QueryRequest request = new SObjectUtils.QueryRequest();
        request.objectName = 'Contact';

        //When
        Test.startTest();
        Long totalCount = (Long) SObjectUtils.getTotalCount(request);
        Test.stopTest();

        //Then
        System.assertEquals((Long) contacts.size(), totalCount, 'Incorrect total count result');
    }

    @IsTest
    public static void performCountOfItems_withFilters_shouldReturnResults(){
        //Having
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i <= 10; i++){
            contacts.add(new Contact(AccountId = acc.Id, LastName = 'Test Contact No. ' + i, Email = 'test_' + i + '@example.com'));
        }
        insert contacts;

        SObjectUtils.QueryRequest request = new SObjectUtils.QueryRequest();
        request.objectName = 'Contact';
        request.filtersIn = new List<SObjectUtils.Filter>{ new SObjectUtils.Filter('Email', new List<String>{ 'test_1@example.com', 'test_2@example.com' }) };

        //When
        Test.startTest();
        Long totalCount = (Long) SObjectUtils.getTotalCount(request);
        Test.stopTest();

        //Then
        System.assertEquals(2, totalCount, 'Incorrect total count result');
    }

    @IsTest
    public static void performQueryBasedOnFields_setOfIds_shouldReturnResult(){
        //Having
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(AccountId = acc.Id, LastName = 'Test Contact', Email = 'test@example.com');
        insert con;

        SObjectUtils.QueryRequest request = new SObjectUtils.QueryRequest();
        request.objectName = 'Contact';
        request.fields = new List<String>{ 'LastName', 'Email' };
        request.recordIds = new List<Id>{ con.Id };

        //When
        Test.startTest();
        List<SObject> results = SObjectUtils.performQuery(request);
        Test.stopTest();

        //Then:
        System.assertEquals(1, results.size());
    }

    @IsTest
    public static void performQueryBasedOnFields_mapOfIDsAndFields_shouldReturnResult(){
        //Having
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(AccountId = acc.Id, LastName = 'Test Contact', Email = 'test@example.com');
        insert con;

        SObjectUtils.QueryRequest request = new SObjectUtils.QueryRequest();
        request.objectName = 'Contact';
        request.fields = new List<String>{ 'LastName', 'Email' };
        request.recordIds = new List<Id>{ con.Id };

        //When
        Test.startTest();
        List<SObject> results = SObjectUtils.performQuery(request);
        Test.stopTest();

        //Then
        System.assertEquals(1, results.size());
    }

    @IsTest
    public static void soqlBuilder_shouldBuildQueryWithLimitOne(){
        //Having
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(AccountId = acc.Id, LastName = 'Test Contact', Email = 'test@example.com');
        insert con;

        SObjectUtils.QueryRequest request = new SObjectUtils.QueryRequest();
        request.objectName = 'Contact';
        request.fields = new List<String>{ 'LastName', 'Email' };
        request.recordIds = new List<Id>{ con.Id };
        request.limitNo = 1;

        //When
        Test.startTest();
        List<SObject> results = SObjectUtils.performQuery(request);
        Test.stopTest();

        //Then
        System.assertEquals(1, results.size());
    }

    @IsTest
    public static void castAndCompareObjects_shouldCompareIntegers(){
        //Having
        Integer valueOne = 1;
        Integer valueTwo = 2;
        String comparisonTypeEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.EQUAL;
        String comparisonTypeUnEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.NOT_EQUAL;
        String comparisonTypeGtOrEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.GREATER_THAN_OR_EQUAL;
        String comparisonTypeLsOrEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.LESS_THAN_OR_EQUAL;
        //When
        Boolean resultEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeEqual, String.valueOf(valueTwo));
        Boolean resultUnEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeUnEqual, String.valueOf(valueTwo));
        Boolean resultGtOrEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeGtOrEqual, String.valueOf(valueTwo));
        Boolean resultLsOrEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeLsOrEqual, String.valueOf(valueTwo));
        //Then
        System.assertEquals(false, resultEqual);
        System.assertEquals(true, resultUnEqual);
        System.assertEquals(false, resultGtOrEqual);
        System.assertEquals(true, resultLsOrEqual);
    }

    @IsTest
    public static void castAndCompareObjects_shouldCompareDecimals(){
        //Having
        Decimal valueOne = 1.0;
        Decimal valueTwo = 1.1;
        String comparisonTypeEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.EQUAL;
        String comparisonTypeUnEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.NOT_EQUAL;
        String comparisonTypeGtOrEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.GREATER_THAN_OR_EQUAL;
        String comparisonTypeLsOrEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.LESS_THAN_OR_EQUAL;
        //When
        Boolean resultEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeEqual, String.valueOf(valueTwo));
        Boolean resultUnEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeUnEqual, String.valueOf(valueTwo));
        Boolean resultGtOrEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeGtOrEqual, String.valueOf(valueTwo));
        Boolean resultLsOrEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeLsOrEqual, String.valueOf(valueTwo));
        //Then
        System.assertEquals(false, resultEqual);
        System.assertEquals(true, resultUnEqual);
        System.assertEquals(false, resultGtOrEqual);
        System.assertEquals(true, resultLsOrEqual);
    }

    @IsTest
    public static void castAndCompareObjects_shouldCompareStrings(){
        //Having
        String valueOne = 'a';
        String valueTwo = 'b';
        String comparisonTypeEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.EQUAL;
        String comparisonTypeUnEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.NOT_EQUAL;
        //When
        Boolean resultEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeEqual, valueTwo);
        Boolean resultUnEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeUnEqual, valueTwo);
        //Then
        System.assertEquals(false, resultEqual);
        System.assertEquals(true, resultUnEqual);
    }

    @IsTest
    public static void castAndCompareObjects_shouldCompareDates(){
        //Having
        Date valueOne = Date.today();
        Date valueTwo = valueOne.addDays(1);
        String comparisonTypeEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.EQUAL;
        String comparisonTypeUnEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.NOT_EQUAL;
        String comparisonTypeAfter = PicklistService.getInstance().sObjectUtils.comparisonTypes.AFTER;
        String comparisonTypeBefore = PicklistService.getInstance().sObjectUtils.comparisonTypes.BEFORE;
        //When
        Boolean resultEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeEqual, String.valueOf(valueTwo));
        Boolean resultUnEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeUnEqual, String.valueOf(valueTwo));
        Boolean resultAfter = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeAfter, String.valueOf(valueTwo));
        Boolean resultBefore = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeBefore, String.valueOf(valueTwo));
        //Then
        System.assertEquals(false, resultEqual);
        System.assertEquals(true, resultUnEqual);
        System.assertEquals(false, resultAfter);
        System.assertEquals(true, resultBefore);
    }

    @IsTest
    public static void castAndCompareObjects_shouldCompareDateTimes(){
        //Having
        DateTime valueOne = DateTime.now();
        DateTime valueTwo = valueOne.addSeconds(1);
        String comparisonTypeEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.EQUAL;
        String comparisonTypeUnEqual = PicklistService.getInstance().sObjectUtils.comparisonTypes.NOT_EQUAL;
        String comparisonTypeAfter = PicklistService.getInstance().sObjectUtils.comparisonTypes.AFTER;
        String comparisonTypeBefore = PicklistService.getInstance().sObjectUtils.comparisonTypes.BEFORE;

        //When
        Boolean resultEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeEqual, String.valueOf(valueTwo));
        Boolean resultUnEqual = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeUnEqual, String.valueOf(valueTwo));
        Boolean resultAfter = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeAfter, String.valueOf(valueTwo));
        Boolean resultBefore = SObjectUtils.castAndCompareObjects(valueOne, comparisonTypeBefore, String.valueOf(valueTwo));
        //Then
        System.assertEquals(false, resultEqual);
        System.assertEquals(true, resultUnEqual);
        System.assertEquals(false, resultAfter);
        System.assertEquals(true, resultBefore);
    }

    @isTest
    static void castAndCompareObjects_shouldThrowUnsupportedTypeException(){
        //HAVING
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Integer valueOneI = 1;
        Integer valueTwoI = 2;
        Decimal valueOneD = 1.0;
        Decimal valueTwoD = 1.1;
        String valueOneS = 'a';
        String valueTwoS = 'b';
        Date valueOneDate = Date.today();
        Date valueTwoDate = valueOneDate.addDays(1);
        DateTime valueOneDT = DateTime.now();
        DateTime valueTwoDT = valueOneDT.addSeconds(1);
        //WHEN
        Test.startTest();
        try{
            SObjectUtils.castAndCompareObjects(null, 'EQUAL', String.valueOf(valueTwoI));
            System.assert(true == false, 'Should have thrown exception');
        } catch (IllegalArgumentException e){
            System.assertEquals('Object one of comparison can\'t be NULL', e.getMessage());
        }

        try{
            SObjectUtils.castAndCompareObjects(valueOneI, 'EQUAL', null);
            System.assert(true == false, 'Should have thrown exception');
        } catch (IllegalArgumentException e){
            System.assertEquals('Object two of comparison can\'t be NULL', e.getMessage());
        }

        try{
            SObjectUtils.castAndCompareObjects(acc, 'EQUAL', String.valueOf(valueTwoI));
            System.assert(true == false, 'Should have thrown exception');
        } catch (IllegalArgumentException e){
            System.assertEquals('Unsupported object type for objectOne', e.getMessage());
        }

        try{
            SObjectUtils.castAndCompareObjects(valueOneI, 'XXX', String.valueOf(valueTwoI));
            System.assert(true == false, 'Should have thrown exception');
        } catch (IllegalArgumentException e){
            System.assertEquals('Unsupported comparison type: XXX', e.getMessage());
        }

        try{
            SObjectUtils.castAndCompareObjects(valueOneD, 'XXX', String.valueOf(valueTwoD));
            System.assert(true == false, 'Should have thrown exception');
        } catch (IllegalArgumentException e){
            System.assertEquals('Unsupported comparison type: XXX', e.getMessage());
        }
        try{
            SObjectUtils.castAndCompareObjects(valueOneS, 'XXX', String.valueOf(valueTwoS));
            System.assert(true == false, 'Should have thrown exception');
        } catch (IllegalArgumentException e){
            System.assertEquals('Unsupported comparison type: XXX', e.getMessage());
        }
        try{
            SObjectUtils.castAndCompareObjects(valueOneDate, 'XXX', String.valueOf(valueTwoDate));
            System.assert(true == false, 'Should have thrown exception');
        } catch (IllegalArgumentException e){
            System.assertEquals('Unsupported comparison type: XXX', e.getMessage());
        }
        try{
            SObjectUtils.castAndCompareObjects(valueOneDT, 'XXX', String.valueOf(valueTwoDT));
            System.assert(true == false, 'Should have thrown exception');
        } catch (IllegalArgumentException e){
            System.assertEquals('Unsupported comparison type: XXX', e.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    static void getFakeId_shouldReturnCorrectLengthIdAndPrefix(){
        // Having
        Schema.SObjectType sot = Account.getSObjectType();
        String expectedPrefix = sot.getDescribe().getKeyPrefix();

        // When
        String fakeId = SObjectUtils.getFakeId(sot);

        // Then
        System.assertEquals(15, fakeId.length(), 'Fake Id length should be 15 characters');
        System.assertEquals(expectedPrefix, fakeId.substring(0, 3), 'Fake Id should start with correct key prefix');
    }

}