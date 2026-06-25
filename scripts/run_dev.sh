#!/bin/bash
# Run the app with the DEVELOP environment.
flutter run --dart-define=ENV_FILE=.env.develop "$@"
