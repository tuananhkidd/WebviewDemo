#!/bin/bash
# Run the app with the STAGING environment.
flutter run --dart-define=ENV_FILE=.env.staging "$@"
