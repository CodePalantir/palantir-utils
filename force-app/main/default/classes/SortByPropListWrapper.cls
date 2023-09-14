/**
 * SortByPropListWrapper is a utility class that provides functionality to add objects to an internal list
 * and then sort that list based on a specified property of the objects.
 *
 * The class uses a combination of JSON serialization and deserialization, along with custom logic,
 * to achieve the sorting based on the specified property.
 *
 * Example Usage:
 * SortByPropListWrapper wrapper = new SortByPropListWrapper();
 * wrapper.add(new Account(Name='B'));
 * wrapper.add(new Account(Name='A'));
 * List<Object> sortedAccounts = wrapper.sortBy('Name');
 *
 */
public class SortByPropListWrapper{
    private Map<String, Object> innerlist = new Map<String, Object>();
    public void add(Object obj){
        this.innerlist.put(obj.hashCode().format(), obj);
    }

    public List<Object> sortBy(String propertyName){
        String str = JSON.serialize(this.innerlist);

        // NOTE: key is hashcode
        Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(str);

        List<String> hashList = new List<String>();
        hashList.addAll(jsonMap.keySet());

        List<Object> sortList = new List<Object>();
        // NOTE: key is (hashcode + target property)
        Map<String, String> valueKeyMap = new Map<String, String>();

        for (String key : hashList){
            Map<String, Object> objmap = (Map<String, Object>)jsonMap.get(key);
            sortList.add(objmap.get(propertyName));
            valueKeyMap.put(String.format('{0}{1}', new List<Object>{ key, objmap.get(propertyName) }), key);
        }

        // sort
        sortList.sort ();

        Map<String, Object> result = new Map<String, Object>();
        for (Object propValue : sortList){
            for (String key : hashList){
                String targetKey = valueKeyMap.get(String.format('{0}{1}', new List<Object>{ key, propValue }));
                if (targetKey != null && !result.containsKey(key)){
                    result.put(key, this.innerlist.get(key));
                    break;
                }
            }
        }

        return result.values();
    }

}