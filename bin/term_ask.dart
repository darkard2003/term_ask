import 'dart:io';

import 'package:args/args.dart';
import 'package:console_markdown/console_markdown.dart';
import 'package:dotenv/dotenv.dart';
import 'package:term_ask/term_ask.dart';
import 'package:path/path.dart' as p;

Future<void> prittyPrintResponse(Stream<String?> response) async {
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

void main(List<String> args) async {
  var parser = ArgParser();

  parser.addFlag('help', abbr: 'h', help: 'Display this help message.');
  parser.addOption('file',
      abbr: 'f', help: 'File to use as context for the prompt.');

  ArgResults argResults;

  try {
    argResults = parser.parse(args);
  } on FormatException catch (e) {
    print(e.message);
    exit(1);
  }

  if (argResults.flag('help')) {
    print('Usage: term_ask [options] [query]');
    print('');
    print('Options:');
    print(parser.usage);
    exit(0);
  }

  var env = DotEnv(includePlatformEnvironment: true, quiet: true)..load();
  var apiKey = env['GEMINI_API_KEY'];

  if (apiKey == null) {
    print('Please set the GEMINI_API_KEY environment variable.');
    exit(1);
  }

  var model = TermAsk(apiKey);

  var filepath = argResults.option('file');
  var rest = argResults.rest;
  var uri = filepath != null ? p.absolute(filepath) : null;

  if (rest.isNotEmpty) {
    try {
      Stream<String?> response;
      if (uri != null) {
        response = model.askStream(rest, filepath: uri);
        uri = null;
      } else {
        response = model.askStream(rest);
      }
      prittyPrintResponse(response);
    } on ArgumentError catch (e) {
      print(e.message);
      exit(1);
    } catch (e) {
      print('An error occurred: $e');
      exit(1);
    }
  }

  while (true) {
    try {
      stdout.write('> ');
      var input = stdin.readLineSync();
      if (input == null || input == 'exit') {
        break;
      }
      if (input.isEmpty) {
        continue;
      }
      Stream<String?> response;
      if (uri != null) {
        response = model.askStream([input], filepath: uri);
        uri = null;
      } else {
        response = model.askStream([input]);
      }
      await prittyPrintResponse(response);
    } on ArgumentError catch (e) {
      print(e.message);
      exit(1);
    } catch (e) {
      print('An error occurred: $e');
      exit(1);
    }
  }
  exit(0);
}
