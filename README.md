# term_ask

A command-line tool that uses the Gemini API to answer your questions.

## Getting Started

1.  **Install Dart:**  Make sure you have the Dart SDK installed.  You can download it from [https://dart.dev/get-dart](https://dart.dev/get-dart).

2.  **Ensure Dart binaries are in your PATH:**  Add the Dart SDK to your system's PATH environment variable. This ensures that you can run Dart commands from any terminal window.

    ```bash
    export PATH="$PATH:/path/to/dart-sdk/bin"
    ```

3.  **Get an API Key:** You'll need an API key from Google AI Studio.  You can get one at [https://makersuite.google.com/app/apikey](https://makersuite.google.com/app/apikey).  Set the `GEMINI_API_KEY` environment variable with your API key.

    ```bash
    export GEMINI_API_KEY="YOUR_API_KEY"
    ```

4.  **Install the package:**

    ```bash
    dart pub global activate term_ask
    ```

## Usage

Just type `term_ask` followed by your question.

