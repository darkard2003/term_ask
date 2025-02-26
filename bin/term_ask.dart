import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:args/args.dart';
import 'package:console_markdown/console_markdown.dart';
import 'package:dotenv/dotenv.dart';
import 'package:term_ask/term_ask.dart';
import 'package:path/path.dart' as p;

Future<String> getVersion() async {
  try {
    final file = File('pubspec.yaml');
    final yamlString = await file.readAsString();
    final yaml = loadYaml(yamlString);
    return yaml['version'] ?? 'Unknown';
  } catch (e) {
    return 'Unknown';
  }
}

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
  var parser = ArgParser(
    allowTrailingOptions: false,
  );

  parser.addFlag('help', abbr: 'h', help: 'Display this help message.');
  parser.addMultiOption('file',
      abbr: 'f', help: 'File to use as context for the prompt.');

  parser.addFlag('version',
      abbr: 'v', help: 'Display the version of this program.');

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

  if (argResults.flag('version')) {
    print(await getVersion());
    exit(0);
  }

  var env = DotEnv(includePlatformEnvironment: true, quiet: true)..load();
  var apiKey = env['GEMINI_API_KEY'];

  if (apiKey == null) {
    print('Please set the GEMINI_API_KEY environment variable.');
    exit(1);
  }

  var model = TermAsk(apiKey);

  var filepath =
      argResults.multiOption('file').map((e) => p.absolute(e)).toList();
  var rest = argResults.rest;

  Stream<String?> response;

  if (rest.isNotEmpty) {
    if (filepath.isNotEmpty) {
      response = model.askStream(rest, filepath: filepath);
      filepath = [];
    } else {
      response = model.askStream(rest);
    }
    await prittyPrintResponse(response);
  }

  while (true) {
    stdout.write('> ');
    var input = stdin.readLineSync();
    if (input == null || input == 'exit') {
      break;
    }
    if (input.isEmpty) {
      continue;
    }
    if (filepath.isNotEmpty) {
      response = model.askStream([input], filepath: filepath);
    } else {
      response = model.askStream([input]);
    }
    await prittyPrintResponse(response);
  }
  exit(0);
}
