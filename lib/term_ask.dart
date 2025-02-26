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

  Stream<String?> askStream(List<String> uprompt, {String? filepath}) {
    var parts = <Part>[
      TextPart(uprompt.join(' ')),
    ];
    if (filepath != null) {
      var mime = lookupMimeType(filepath) ?? _fallbackMimeType(filepath);
      if (mime == null) {
        throw ArgumentError('Could not determine MIME type for $filepath');
      }
      var file = File(filepath);
      parts.insert(0, DataPart(mime, file.readAsBytesSync()));
    }
    var stream = _session.sendMessageStream(Content.multi(parts));
    return stream.map((response) {
      return response.text;
    });
  }

  String? _fallbackMimeType(String path) {
    var filename = path.split('/').last;
    var ext = filename.split('.').last;
    switch (ext) {
      case 'yaml':
        return 'application/x-yaml';
      case 'yml':
        return 'application/x-yaml';
      case 'json':
        return 'application/json';
      case 'tsx':
        return 'text/tsx';
      case 'jsx':
        return 'text/jsx';
      case 'xml':
        return 'application/xml';
      case 'Makefile':
        return 'text/x-makefile';
      case 'dockerfile':
        return 'text/x-dockerfile';
      default:
        return null;
    }
  }
}
