import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  //leave it uninitialized right now
  late final OpenAI openAI;

  AIService() {
    openAI = OpenAI.instance.build(
      token: dotenv.env['OPENAI_KEY'],
      //times out in case of bad connection
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
    );
  }

  Future<Map<String, dynamic>> generateContent(String unitTitle) async {
    try {
      final request = ChatCompleteText(
        maxToken: 1000,
        model: Gpt4OChatModel(),
        messages: [
          Map.of({
            "role": "system",
            "content":
                "act as an educational content creator for teenagers. "
                "You make engaging and meaningful educational content "
                "for a teen learning platform. ",
          }),
          Map.of({
            "role": "user",
            "content":
                "Generate a challenging and unique social scenario about $unitTitle in 3-5 sentences asking the user what they would do in that situation without stating $unitTitle."
                "Create only one paragraph for the social scenario.",
          }),
        ],
      );

      final response = await openAI.onChatCompletion(request: request);
      //if choices is null, don't run it, use the ? after the variable
      final message = response?.choices.first.message;
      if (message != null) {
        return Map.of({"scenario": message.content});
      } else {
        throw Exception('Error generating content. No response.');
      }
    } on Exception catch (e) {
      throw Exception('Error generating content: $e');
    }
  }

  Future<Map<String, dynamic>> generateFeedback(
    String scenario,
    String userResponse,
  ) async {
    try {
      final request = ChatCompleteText(
        maxToken: 1000,
        model: Gpt4OChatModel(),
        messages: [
          Map.of({
            "role": "system",
            "content":
                "act as an educational content creator for teenagers. "
                "You make engaging and meaningful educational content "
                "for a teen learning platform. ",
          }),
          Map.of({
            "role": "user",
            "content":
                "In a second person perspective, analyze the following social scenario and the user's response to what they would do in that scenario."
                "Scenario: $scenario"
                "User response: $userResponse"
                "format the feedback in a JSON format like this, return only the JSON format and nothing else:"
                "{"
                "   \"score\": (1/10 based on appropriateness and effectiveness)"
                "   \"pros\": (pros of the response)"
                "   \"cons\": (cons of the response)"
                "}",
          }),
        ],
      );
      final feedback = await openAI.onChatCompletion(request: request);
      //if choices is null, don't run it, use the ? after the variable
      final message = feedback?.choices.first.message;
      if (message != null) {
        return jsonDecode(message.content);
      } else {
        throw Exception('Error generating feedback.');
      }
    } on Exception catch (e) {
      print("error: $e");
      throw Exception('Error generating feedback: $e');
    }
  }
}
