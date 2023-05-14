public without sharing class RecordFilter {

    public enum FilterMode { EQUAL, UNEQUAL, GREATER, SMALLER }

    private List<SObject> records;
    private List<FilterCriteria> criterias;

    public RecordFilter(List<SObject> records) {
        this.records = records;
        this.criterias = new List<FilterCriteria>();
    }

    public RecordFilter addFilterTemplate(SObject filterRecord) {
        return this.addFilterTemplate(filterRecord, FilterMode.EQUAL);
    }

    public RecordFilter addFilterTemplate(SObject filterRecord, FilterMode mode) {
        Map<String, Object> recordData = filterRecord.getPopulatedFieldsAsMap();
        for(String field : recordData.keySet()) {
            if(field != 'Id') {
                this.criterias.add(new FilterCriteria(field, mode, recordData.get(field)));
            }
        }
        return this;
    }

    public RecordFilter addFilter(Schema.SObjectField field, Object value) {
        this.criterias.add(new FilterCriteria(field.getDescribe().getName(), FilterMode.EQUAL, value));
        return this;
    }

    public RecordFilter addFilter(Schema.SObjectField field, Object value, FilterMode mode) {
        this.criterias.add(new FilterCriteria(field.getDescribe().getName(), mode, value));
        return this;
    }

    public List<SObject> reduce() {
        List<SObject> filtered = new List<SObject>();
        for(SObject record : records) {
            Boolean isValid = true;
            for(FilterCriteria criteria : criterias) {
                isValid &= checkCriteria(record, criteria);
                if(!isValid) {
                    break;
                }
            }
            if(isValid) {
                filtered.add(record);
            }
        }
        return filtered;
    }

    private Boolean checkCriteria(SObject record, FilterCriteria filter) {
        Object value = record.get(filter.field);
        Object target = filter.value;
        switch on filter.mode {
            when EQUAL {
                return value.equals(target);
            }
            when UNEQUAL {
                return !value.equals(target);
            }
            when else {
                return false;
            }
        }
    }

    private class FilterCriteria {

        public Object value;
        public FilterMode mode;
        public String field;

        public FilterCriteria(String field, FilterMode mode, Object obj) {
            this.value = obj;
            this.mode = mode;
            this.field = field;
        }
    }
}