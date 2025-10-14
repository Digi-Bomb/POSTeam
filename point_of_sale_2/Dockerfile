# Use the official Dart image with Flutter pre-installed
FROM ghcr.io/cirruslabs/flutter:stable

# Set working directory
WORKDIR /app

# Copy Flutter project files into container
COPY . .

# Get dependencies
RUN flutter pub get

# Build the Flutter web app
RUN flutter build web

# Use a simple web server (you can swap this with nginx if you prefer)
# Here, using the Python HTTP server for simplicity
RUN apt-get update && apt-get install -y python3

# Expose port
EXPOSE 12500

# Start a web server to serve the built app
CMD ["python3", "-m", "http.server", "12500", "--directory", "build/web"]
