import 'package:test/test.dart';
import 'package:mime/mime.dart';

void main() {
  group('MIME type detection tests', () {
    test('Common file types', () {
      final testCases = {
        'test.txt': 'text/plain',
        'image.png': 'image/png',
        'script.js': 'text/javascript',
        'style.css': 'text/css',
        'index.html': 'text/html',
        'data.json': 'application/json',
        'doc.pdf': 'application/pdf',
        'code.dart': 'text/x-dart',
        'video.mp4': 'video/mp4',
        'audio.mp3': 'audio/mpeg',
        'archive.zip': 'application/zip',
        'page.jsx': 'text/jsx',
      };

      testCases.forEach((filename, expectedMime) {
        final detectedMime = lookupMimeType(filename);
        print(
            'File: $filename, Detected: $detectedMime, Expected: $expectedMime');
        expect(detectedMime, equals(expectedMime),
            reason: 'Failed to detect correct MIME type for $filename');
      });
    });

    test('Unknown file types', () {
      final unknownFiles = ['noextension', '.hidden', 'file.qwerty'];

      for (final file in unknownFiles) {
        final mime = lookupMimeType(file);
        print('File: $file, Detected: $mime');
        expect(mime, isNull,
            reason: 'Should return null for unknown file type: $file');
      }
    });
  });
}
