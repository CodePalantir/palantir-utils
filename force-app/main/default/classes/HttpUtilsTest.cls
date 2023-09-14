@IsTest
public class HttpUtilsTest {
    public class HttpCalloutMockImpl implements HttpCalloutMock {
        Boolean shouldFail;
        String responseBody;
        Integer statusCode;

        public HttpCalloutMockImpl(Boolean shouldFail, String responseBody, Integer statusCode) {
            this.shouldFail = shouldFail;
            this.responseBody = responseBody;
            this.statusCode = statusCode;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            if (shouldFail) {
                res.setStatusCode(400);
                res.setBody('{"error":"Mocked Error"}');
            } else {
                res.setStatusCode(statusCode);
                res.setBody(responseBody);
            }
            return res;
        }
    }

    public class TestBody {
        String key { get; set; }
    }

    @IsTest
    static void requestBuilder_shouldBuildCorrectly() {
        //Having
        HttpUtils.HttpRequestBuilder builder = HttpUtils.requestBuilder();
        builder.setUrl('http://test.com');
        builder.setMethod('GET');
        builder.setRequestBody('{"key":"value"}');
        builder.addHeader('Content-Type', 'application/json');
        //When
        HttpRequest req = builder.build();
        //Then:
        System.assertEquals('http://test.com', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        System.assertEquals('{"key":"value"}', req.getBody());
        System.assertEquals('application/json', req.getHeader('Content-Type'));
    }

    @isTest
    public static void parseResponse_shouldReturnParsedObject() {
        //Having
        String body = '{"key":"value"}';
        Boolean deserializeStrict = true;

        //When
        TestBody result = (TestBody) HttpUtils.parseResponse(body, TestBody.class, deserializeStrict);

        //Then
        System.assertEquals('value', result.key, 'parseResponse should have returned a correctly parsed object');
    }

    @isTest
    public static void parseResponse_shouldThrowException_WhenBodyIsEmpty() {
        //Having
        String body = null;
        Type targetType = Map<String, Object>.class;
        Boolean deserializeStrict = false;
        Boolean exceptionCaught = false;

        //When
        try {
            HttpUtils.parseResponse(body, targetType, deserializeStrict);
        } catch (Exception e) {
            exceptionCaught = true;
        }

        //Then
        System.assertEquals(true, exceptionCaught, 'parseResponse should have thrown an exception when body is null');
    }

    @isTest
    public static void parseResponse_shouldThrowException_WhenBodyStructureIsInvalid() {
        //Having
        String body = '{"key":"value"}';
        Type targetType = List<Object>.class;
        Boolean deserializeStrict = false;
        Boolean exceptionCaught = false;

        //When
        try {
            HttpUtils.parseResponse(body, targetType, deserializeStrict);
        } catch (Exception e) {
            exceptionCaught = true;
        }

        //Then
        System.assertEquals(true, exceptionCaught, 'parseResponse should have thrown an exception when body structure is invalid');
    }

    // Test for sendRequest method

    @isTest
    public static void sendRequest_shouldReturnResponseBody() {
        //Having
        HttpUtils.HttpRequestBuilder builder = HttpUtils.requestBuilder();
        builder.setUrl('http://test.com');
        builder.setMethod('GET');
        builder.setRequestBody('{"key":"value"}');
        builder.setTimeout(60000);
        builder.addHeader('Content-Type', 'application/json');
        HttpRequest req = builder.build();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl(false, '{"key":"value"}', 200));

        //When
        String response = HttpUtils.sendRequest(req);

        //Then
        System.assertEquals('{"key":"value"}', response, 'sendRequest should have returned response body');
    }

    @isTest
    public static void sendRequest_shouldThrowException_whenResponseIsError() {
        //Having
        HttpUtils.HttpRequestBuilder builder = HttpUtils.requestBuilder();
        builder.setUrl('http://test.com');
        builder.setMethod('GET');
        builder.setRequestBody('{"key":"value"}');
        builder.setTimeout(60000);
        builder.addHeader('Content-Type', 'application/json');
        HttpRequest req = builder.build();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl(true, null, null));
        Boolean exceptionCaught = false;

        //When
        try {
            HttpUtils.sendRequest(req);
        } catch (Exception e) {
            exceptionCaught = true;
        }

        //Then
        System.assertEquals(true, exceptionCaught, 'sendRequest should have thrown an exception when response is an error');
    }

}
