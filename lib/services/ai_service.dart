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
                "Generate a unique social scenario about $unitTitle in "
                "dialogue form between 2 or more characters asking the user "
                "what they would do in that situation without stating $unitTitle."
                "Use a wide variety of male and female names. "
                "Only respond with the dialogue between the characters in each scenario. Omit the background information "
                "about the scenario and the characters. Only keep the dialogue, remove the word 'scenario'. "
                "Provide your response with plain text without formatting"
                "",
          }),
        ],
      );

      final response = await openAI.onChatCompletion(request: request);
      //if choices is null, don't run it, use the ? after the variable
      final message = response?.choices.first.message;
      if (message != null) {
        return Map.of({"scenario": message.content});
      } else {
        return Future.error('Error generating content. No response.');
      }
    } on Exception catch (e) {
      return Future.error('Error generating content: $e');
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
            "role": "user",
            "content": """
Grade the teen’s answer to the scenario below.

SCENARIO:
$scenario

USER_RESPONSE:
$userResponse

Return ONLY a single compact JSON object with this exact schema:
{"score": 0/10, "pros": , "cons": }

Rules:
- score is an integer from 0 to 10
- pros and cons are an array of short strings (each string 5–20 words). 
e.g. Show how the user response is too broad, straightforward, or off topic
-provide a model response as to how the user should've answered the prompt to earn full credit
- absolutely NO markdown, NO code fences, NO backticks, NO extra text
- absolutely a MAXIMUM of 5 bullet points for every pro/con
""",
          }),
        ],

        // If your chat_gpt_sdk version exposes a response-format option, use it:
        // responseFormat: {"type":"json_object"},
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
