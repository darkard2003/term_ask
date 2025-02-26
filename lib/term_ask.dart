import 'dart:async';
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';

class TermAsk {
  final String _apiKey;
  late GenerativeModel _model;
  late ChatSession _session;

  final prompts = [
    "You are a helpful person.",
    "You have knowledge about computer, linux, windows, and mac.",
    "You are a software developer.",
    "You can help me with my computer problems.",
    "You can also help with general knowledge.",
    "Your response must be concise and helpful.",
    "Format your responses using Markdown where appropriate to improve readability, including code blocks for code snippets.",
    "User: Can you help me with",
  ];

  TermAsk(this._apiKey) {
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey);
    _session = _model.startChat();
  }

  Stream<String?> askStream(List<String> uprompt,
      {List<String> filepath = const []}) {
    var parts = <Part>[
      TextPart(uprompt.join(' ')),
    ];
    for (var filepath in filepath) {
      parts.add(TextPart(readFile(filepath)));
    }
    var stream = _session.sendMessageStream(Content.multi(parts));
    return stream.map((response) {
      return response.text;
    });
  }

  String readFile(String filepath) {
    var file = File(filepath);
    try {
      var content = file.readAsStringSync();
      return 'File: ${file.path}\n\n$content';
    } catch (e) {
      throw Exception('Error reading file: $filepath');
    }
  }
}
