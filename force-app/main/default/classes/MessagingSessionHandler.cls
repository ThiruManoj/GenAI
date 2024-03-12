public with sharing class MessagingSessionHandler {
    
    @InvocableMethod(Label ='Save Conversation History' description='save conversation history')
    public static void saveConversationHistory(List<Requests> requests){
        Requests request = requests[0];
        System.debug(request);
        List<MessagingSession> messagingSessionList = new List<MessagingSession>();
        for(MessagingSession messagingSession : [Select Id,Conversation_History__c from MessagingSession where Id=:request.messagingSessionId]){
            messagingSession.Conversation_History__c = constructHistory(messagingSession.Conversation_History__c, request.inputString, request.conversationType);
            messagingSessionList.add(messagingSession);
        }
        
        if(messagingSessionList.size()>0){
            update messagingSessionList;
        }

        //test
    }

    public static String constructHistory(String oldHistory, String inputString, String conversationType){
        List<ConversationHistory> conversationHistoryList = new List<ConversationHistory>();
        if(String.isNotBlank(oldHistory)){
            conversationHistoryList = (List<ConversationHistory>)JSON.deserialize(oldHistory, List<ConversationHistory>.class);
        }

        ConversationHistory newHistory = new ConversationHistory();
        newHistory.conversationTime = System.now().format();
        newHistory.conversationType = conversationType;
        newHistory.conversationtext = inputString;

        conversationHistoryList.add(newHistory);
        
        return JSON.serialize(conversationHistoryList);
    }

    public class ConversationHistory {
        String conversationtime;
        String conversationType;
        String conversationtext;
    }

    public class Requests {
        @InvocableVariable(label='Messaging Session Id' description='messaging session id' required=true)
        public Id messagingSessionId;

        @InvocableVariable(label='Input String' description='input string' required=true)
        public String inputString;

        @InvocableVariable(label='Conversation Type' description='conversation type' required=true)
        public String conversationType;
    }
}
