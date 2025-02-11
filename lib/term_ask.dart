import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';

class TermAsk {
  final String _apiKey;
  late GenerativeModel _model;

  final prompts = [
    "You are a helpful person.",
    "You have knowledge about computer, linux, windows, and mac.",
    "You are a software developer.",
    "You can help me with my computer problems.",
    "You can also help with general knowledge.",
    "Your response must be concise and helpful.",
    "Format your responses using Markdown where appropriate to improve readability, including code blocks for code snippets.",
    "User: Can you help me with"
  ];

  TermAsk(this._apiKey) {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
    );
  }

  Future<String?> ask(List<String> prompt) async {
    final promptContent = prompt.map((e) => Content.text(e));
    final content = [...promptContent, Content.text('')];
    final response = await _model.generateContent(content);
    return response.text;
  }

  Stream<String?> askStream(List<String> uprompt) {
    final promptContent = prompts.map((e) => Content.text(e));
    final userPrompt = uprompt.map((e) => Content.text(e));
    final content = [...promptContent, ...userPrompt];
    final response = _model.generateContentStream(content);
    return response.map((e) => e.text);
  }
}
