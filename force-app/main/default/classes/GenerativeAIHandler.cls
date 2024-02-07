public with sharing class GenerativeAIHandler {

    @InvocableMethod(Label ='Get AI Response' description='return AI response' callout=true)
    public static List<String> getAIResponse(List<String> question){
        Http http = new Http();
	
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://ron-swanson-quotes.herokuapp.com/v2/quotes');
        
        HttpResponse response = http.send(request);
        String body = response.getBody();
        System.debug(body);
        return new List<String>{body};	          
    }
}