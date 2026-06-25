import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Loads dotenv with test-safe values so that [EnvConfig] accessors work
/// during unit / widget tests without requiring a real `.env.*` asset file.
///
/// Call this in `setUp` or `setUpAll` before any code that touches
/// `EnvConfig`, `ApiEndpoints.baseUrl`, or `ApiEndpoints.companyWebsite`.
void loadTestEnv() {
  dotenv.testLoad(
    fileInput: '''
ENV=develop
APP_NAME=Webview Demo [TEST]
BASE_URL=https://jsonplaceholder.typicode.com
WEBSITE_URL=https://test.sgcarmart.com
ENABLE_LOGGING=false
''',
  );
}
