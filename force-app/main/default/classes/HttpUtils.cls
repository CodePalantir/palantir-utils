/**
 * HttpUtils is a utility class that provides methods to facilitate HTTP request creation, sending, and response parsing.
 * It offers a builder pattern for constructing HTTP requests and methods to send requests and parse responses.
 *
 * Example Usage:
 * HttpRequest request = HttpUtils.requestBuilder()
 *     .setUrl(getOneDocumentUrl)
 *     .setMethod('GET')
 *     .build();
 * String responseBody = HttpUtils.sendRequest(request);
 * DocumentReference returnedValue = (DocumentReference) HttpUtils.parseResponse(
 *     responseBody,
 *     DocumentReference.class,
 *     false
 * );
 */
public class HttpUtils{
    /**
     * Parses the provided HTTP response body into an object of the specified type.
     *
     * @param responseBody The HTTP response body as a string.
     * @param targetType The Apex Type to deserialize the response into.
     * @param deserializeStrict If true, uses JSON.deserializeStrict, otherwise uses JSON.deserialize.
     * @return An object of the specified targetType.
     * @throws IllegalArgumentException If the responseBody is empty or if there's an error during deserialization.
     */
    public static Object parseResponse(String responseBody, Type targetType, Boolean deserializeStrict){
        if (String.isBlank(responseBody)){
            throw new IllegalArgumentException('Response body is empty');
        }
        try{
            if (!deserializeStrict){
                return (Object) JSON.deserialize(responseBody, targetType);
            } else{
                return (Object) JSON.deserializeStrict(responseBody, targetType);
            }
        } catch (Exception e){
            throw new IllegalArgumentException('Invalid response body structure: ' + e.getMessage());
        }
    }

    /**
     * Returns a new instance of HttpRequestBuilder to facilitate the creation of HttpRequest objects.
     *
     * @return A new HttpRequestBuilder instance.
     */
    public static HttpRequestBuilder requestBuilder(){
        return new HttpRequestBuilder();
    }

    /**
     * HttpRequestBuilder is an inner class that provides a fluent API for building HttpRequest objects.
     * It allows setting various HttpRequest properties and headers.
     */
    public class HttpRequestBuilder{
        private String url;
        private String method;
        private String requestBody;
        private Map<String, String> headers;
        private Integer timeout;
        private String clientCertificateName;

        public HttpRequestBuilder(){
            this.headers = new Map<String, String>();
        }

        public HttpRequestBuilder setUrl(String url){
            this.url = url;
            return this;
        }

        public HttpRequestBuilder setMethod(String method){
            this.method = method;
            return this;
        }

        public HttpRequestBuilder setRequestBody(String requestBody){
            this.requestBody = requestBody;
            return this;
        }

        public HttpRequestBuilder setTimeout(Integer timeout){
            this.timeout = timeout;
            return this;
        }

        public HttpRequestBuilder setClientCertificateName(String clientCertificateName){
            this.clientCertificateName = clientCertificateName;
            return this;
        }

        public HttpRequestBuilder addHeader(String name, String value){
            this.headers.put(name, value);
            return this;
        }

        public HttpRequest build(){
            HttpRequest req = new HttpRequest();
            req.setEndpoint(this.url);
            req.setMethod(this.method);
            if (!String.isBlank(this.requestBody)){
                req.setBody(this.requestBody);
            }
            if (this.timeout != null){
                req.setTimeout(this.timeout);
            }
            if (!String.isBlank(this.clientCertificateName)){
                req.setClientCertificateName(this.clientCertificateName);
            }
            if (this.headers.size() > 0){
                for (String headerKey : this.headers.keySet()){
                    req.setHeader(headerKey, this.headers.get(headerKey));
                }
            }
            return req;
        }

    }

    /**
     * Sends the provided HttpRequest and returns the HttpResponse.
     *
     * @param request The HttpRequest to send.
     * @return The HttpResponse received.
     * @throws HttpRequestException If there's an error during the request sending.
     */
    private static HttpResponse send(HttpRequest request){
        try{
            Http http = new Http();
            return http.send(request);
        } catch (Exception e){
            throw new HttpRequestException('An error occurred while sending the request: ' + e.getMessage());
        }
    }

    /**
     * Sends the provided HttpRequest and returns the response body as a string.
     *
     * @param request The HttpRequest to send.
     * @return The response body as a string.
     * @throws HttpRequestException If the request fails or if the status code indicates an error.
     */
    public static String sendRequest(HttpRequest request){
        HttpResponse response = send(request);
        if (response.getStatusCode() == 200 || (request.getMethod() == 'POST' && response.getStatusCode() == 201)){
            return response.getBody();
        } else{
            if (!String.isBlank(response.getBody())){
                System.debug(response.getBody());
            }
            throw new HttpRequestException('Request method ' + request.getMethod() + ' for URL ' + request.getEndpoint() + ' failed with status code: ' + response.getStatusCode());
        }
    }

    /**
     * Custom exception class to handle HTTP request related exceptions.
     */
    public class HttpRequestException extends Exception{
    }

}