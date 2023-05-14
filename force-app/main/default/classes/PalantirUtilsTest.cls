@IsTest
public class PalantirUtilsTest {
    
    @IsTest
    public static void recordFilter_shoudReturnRecords_withModeEqual() {
        
        // Having
        List<Lead> leads = new List<Lead> {
            new Lead(FirstName = 'Lead2', LastName = 'Test', Company = 'ApexPalantir.'),
            new Lead(FirstName = 'Lead1', LastName = 'Test', Company = 'ApexPalantir.')
        };

        // When
        List<Lead> filteredLeads = (List<Lead>) new RecordFilter(leads)
            .addFilter(Lead.FirstName, 'Lead1')
            .reduce();

        // Then
        System.assertEquals(1, filteredLeads.size(), 'Wrong number of filtered leads');
        System.assertEquals('Lead1', filteredLeads.get(0).FirstName);
    }

    @IsTest
    public static void recordFilter_shoudReturnRecords_withModeUnEqual() {

        // Having

        // When

        // Then
    }

    @IsTest
    public static void recordFilter_shoudReturnRecords_withModeGreater() {

        // Having

        // When

        // Then
    }

    @IsTest
    public static void recordFilter_shoudReturnRecords_withModeSmaller() {

        // Having

        // When

        // Then
    }

    @IsTest
    public static void recordFilter_shoudReturnRecords_withMixedModes() {

        // Having

        // When

        // Then
    }

    @IsTest
    public static void recordFilter_shoudReturnRecords_withTemplateFilter() {

        // Having
        Lead template = new Lead(FirstName = 'Lead2', LastName = 'Test2', Company = 'ApexPalantir.');
        List<Lead> leads = new List<Lead> {
            new Lead(FirstName = 'Lead2', LastName = 'Test2', Company = 'ApexPalantir.'),
            new Lead(FirstName = 'Lead1', LastName = 'Test', Company = 'ApexPalantir.')
        };

        // When
        List<Lead> filteredLeads = (List<Lead>) new RecordFilter(leads)
            .addFilterTemplate(template)
            .reduce();

        // Then
        System.assertEquals(1, filteredLeads.size(), 'Wrong number of filtered leads');
        System.assertEquals('Lead2', filteredLeads.get(0).FirstName);
        System.assertEquals('Test2', filteredLeads.get(0).LastName);
    }
}