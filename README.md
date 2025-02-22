# term_ask

A command-line tool that uses the Gemini API to answer your questions.

## Getting Started

1.  **Install Dart:**  Make sure you have the Dart SDK installed.  You can download it from [https://dart.dev/get-dart](https://dart.dev/get-dart).

2.  **Get an API Key:** You'll need an API key from Google AI Studio.  You can get one at [https://makersuite.google.com/app/apikey](https://makersuite.google.com/app/apikey).  Set the `GEMINI_API_KEY` environment variable with your API key.

    ```bash
    export GEMINI_API_KEY="YOUR_API_KEY"
    ```

3.  **Install the package:**

    ```bash
    dart pub global activate term_ask
    ```

## Usage

Just type `ask` followed by your question.

Can also ask questions about files:

```bash
ask -f README.md -f CHANGELOG.md what does these files do
```