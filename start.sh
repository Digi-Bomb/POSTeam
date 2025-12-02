#!/bin/bash

# Start Flask backend in background
echo "Starting Flask backend..."
python3 backend/app.py &

# Start Flutter web dev server
echo "Starting Flutter web server..."
flutter run -d web-server --web-port=12500 --web-hostname=0.0.0.0
