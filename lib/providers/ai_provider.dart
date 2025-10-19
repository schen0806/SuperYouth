import 'package:flutter/material.dart';

import '../services/ai_service.dart';

class AIProvider extends ChangeNotifier {
  late final AIService _ai;

  AIProvider() {
    _ai = AIService();
  }

  //provider creates a middle ground for relaying information between UI code
  // and the AI Service
  Future<Map<String, dynamic>> generateContent(String unitTitle) async {
    return _ai.generateContent(unitTitle);
  }

  Future<Map<String, dynamic>> generateFeedback(
    String scenario,
    String userResponse,
  ) async {
    return _ai.generateFeedback(scenario, userResponse);
  }
}
