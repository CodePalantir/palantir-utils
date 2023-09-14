@IsTest
public class SortByPropListWrapperTest {
    @IsTest
    static void testSortByPropListWrapper_shouldReturnSortedList() {
        //Having:
        List<Account> testAccounts = new List<Account>{ new Account(Name = 'Zeta Company'), new Account(Name = 'Alpha Company'), new Account(Name = 'Gamma Company') };
        insert testAccounts;

        //When
        SortByPropListWrapper wrapper = new SortByPropListWrapper();
        for (Account a : testAccounts) {
            wrapper.add(a);
        }
        List<Object> sortedList = wrapper.sortBy('Name');

        //Then
        System.assertEquals(testAccounts.size(), sortedList.size());
        Account firstAccount = (Account) sortedList[0];
        Account secondAccount = (Account) sortedList[1];
        Account thirdAccount = (Account) sortedList[2];
        System.assertEquals('Alpha Company', firstAccount.Name);
        System.assertEquals('Gamma Company', secondAccount.Name);
        System.assertEquals('Zeta Company', thirdAccount.Name);
    }
}
