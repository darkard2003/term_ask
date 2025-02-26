import 'package:test/test.dart';
import 'package:mime/mime.dart';

class MimeTestResult {
  final String filename;
  final String? expectedMime;
  final String? detectedMime;

  MimeTestResult(this.filename, this.expectedMime, this.detectedMime);

  bool get isDetected => detectedMime == expectedMime;
}

final List<MimeTestResult> _allResults = [];

void main() {
  tearDownAll(() {
    // Print summary of undetectable files
    print('\n=== MIME Detection Summary ===');
    final undetectable = _allResults.where((r) => !r.isDetected).toList();
    print('Total files tested: ${_allResults.length}');
    print('Undetectable files: ${undetectable.length}');

    if (undetectable.isNotEmpty) {
      print('\nList of undetectable files:');
      for (var result in undetectable) {
        print('${result.filename}:');
        print('  Expected: ${result.expectedMime}');
        print('  Detected: ${result.detectedMime}');
      }
    }
  });

  group('Extensive MIME type detection tests', () {
    test('Text and document formats', () {
      final textFiles = {
        'document.txt': 'text/plain',
        'document.md': 'text/markdown',
        'document.rtf': 'application/rtf',
        'document.doc': 'application/msword',
        'document.docx':
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'document.odt': 'application/vnd.oasis.opendocument.text',
        'document.tex': 'application/x-tex',
      };
      _testMimeTypes(textFiles, 'Text Documents');
    });

    test('Programming languages', () {
      final codeFiles = {
        'source.c': 'text/x-c',
        'source.cpp': 'text/x-c',
        'source.java': 'text/x-java',
        'source.py': 'text/x-python',
        'source.rb': 'text/x-ruby',
        'source.php': 'text/x-php',
        'source.go': 'text/x-go',
        'source.rs': 'text/x-rust',
        'source.swift': 'text/x-swift',
        'source.dart': 'text/x-dart',
      };
      _testMimeTypes(codeFiles, 'Programming Languages');
    });

    test('Web technologies', () {
      final webFiles = {
        'file.html': 'text/html',
        'file.htm': 'text/html',
        'style.css': 'text/css',
        'script.js': 'text/javascript',
        'data.json': 'application/json',
        'file.xml': 'application/xml',
        'file.yaml': 'text/yaml',
        'file.yml': 'text/yaml',
        'file.jsx': 'text/jsx',
        'file.tsx': 'text/tsx',
      };
      _testMimeTypes(webFiles, 'Web Technologies');
    });

    test('Image formats', () {
      final imageFiles = {
        'image.jpg': 'image/jpeg',
        'image.jpeg': 'image/jpeg',
        'image.png': 'image/png',
        'image.gif': 'image/gif',
        'image.webp': 'image/webp',
        'image.svg': 'image/svg+xml',
        'image.tiff': 'image/tiff',
        'image.bmp': 'image/bmp',
        'image.ico': 'image/x-icon',
      };
      _testMimeTypes(imageFiles, 'Images');
    });

    test('Audio formats', () {
      final audioFiles = {
        'audio.mp3': 'audio/mpeg',
        'audio.wav': 'audio/x-wav',
        'audio.ogg': 'audio/ogg',
        'audio.m4a': 'audio/mp4',
        'audio.flac': 'audio/flac',
        'audio.aac': 'audio/aac',
      };
      _testMimeTypes(audioFiles, 'Audio');
    });

    test('Video formats', () {
      final videoFiles = {
        'video.mp4': 'video/mp4',
        'video.webm': 'video/webm',
        'video.avi': 'video/x-msvideo',
        'video.mov': 'video/quicktime',
        'video.mkv': 'video/x-matroska',
      };
      _testMimeTypes(videoFiles, 'Video');
    });

    test('Archive formats', () {
      final archiveFiles = {
        'archive.zip': 'application/zip',
        'archive.rar': 'application/x-rar-compressed',
        'archive.7z': 'application/x-7z-compressed',
        'archive.tar': 'application/x-tar',
        'archive.gz': 'application/gzip',
        'archive.bz2': 'application/x-bzip2',
      };
      _testMimeTypes(archiveFiles, 'Archives');
    });

    test('Edge cases', () {
      final edgeCases = {
        '.gitignore': null,
        'Makefile': null,
        'dockerfile': null,
        'file.with.multiple.dots.txt': 'text/plain',
        'file with spaces.pdf': 'application/pdf',
        'UPPERCASE.TXT': 'text/plain',
        '测试文件.txt': 'text/plain',
        '🎉.txt': 'text/plain',
      };
      _testMimeTypes(edgeCases, 'Edge Cases');
    });
  });
}

void _testMimeTypes(Map<String, String?> files, String category) {
  print('\n=== Testing $category ===');
  files.forEach((filename, expectedMime) {
    final detectedMime = lookupMimeType(filename);
    print('File: $filename');
    print('  Expected: $expectedMime');
    print('  Detected: $detectedMime');
    print('  Match: ${detectedMime == expectedMime ? '✅' : '❌'}');

    _allResults.add(MimeTestResult(filename, expectedMime, detectedMime));

    if (expectedMime == null) {
      expect(detectedMime, isNull,
          reason: 'Expected null MIME type for $filename');
    } else {
      expect(detectedMime, equals(expectedMime),
          reason: 'Incorrect MIME type for $filename');
    }
  });
}
