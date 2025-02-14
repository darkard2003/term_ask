import 'dart:io';

import 'package:console_markdown/console_markdown.dart';
import 'package:dotenv/dotenv.dart';
import 'package:term_ask/term_ask.dart';

void main(List<String> args) async {
  print('Hello from term_ask!');
  print('Arguments received: $args');

  var env = DotEnv(includePlatformEnvironment: true, quiet: true)..load();
  var apiKey = env['GEMINI_API_KEY'];

  if (apiKey == null) {
    print('Please set the GEMINI_API_KEY environment variable.');
    exit(1);
  }

  var model = TermAsk(apiKey);

  if (args.isEmpty) {
    while (true) {
      stdout.write('> ');
      var input = stdin.readLineSync();
      if (input == null || input == 'exit') {
        break;
      }
      if (input.isEmpty) {
        continue;
      }
      var response = model.askStream([input]);
      StringBuffer buffer = StringBuffer();
      await for (var text in response) {
        if (text == null) {
          break;
        }
        buffer.write(text);
        var lines = buffer.toString().split('\n');
        if (lines.length > 1) {
          for (int i = 0; i < lines.length - 1; i++) {
            stdout.writeln(lines[i].trim().toConsole());
          }
          buffer.clear();
          buffer.write(lines.last);
        }
      }
      if (buffer.isNotEmpty) {
        stdout.writeln(buffer.toString().trim().toConsole());
      }
      stdout.writeln();
    }
    exit(0);
  }

  var response = model.askStream(args);

  StringBuffer buffer = StringBuffer();
  await for (var text in response) {
    if (text == null) {
      break;
    }
    buffer.write(text);
    var lines = buffer.toString().split('\n');
    if (lines.length > 1) {
      for (int i = 0; i < lines.length - 1; i++) {
        stdout.writeln(lines[i].trim().toConsole());
      }
      buffer.clear();
      buffer.write(lines.last);
    }
  }
  if (buffer.isNotEmpty) {
    stdout.writeln(buffer.toString().trim().toConsole());
  }
}
