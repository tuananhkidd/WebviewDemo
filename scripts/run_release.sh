#!/bin/bash
# Build & run the app with the RELEASE environment.
flutter run --release --dart-define=ENV_FILE=.env.release "$@"
