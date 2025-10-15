# Use the official Dart image with Flutter pre-installed
FROM ghcr.io/cirruslabs/flutter:stable

# Set working directory
WORKDIR /app

# Copy Flutter project files into container
COPY . .

RUN flutter create . --platforms web
# Get dependencies
RUN flutter pub get

# Build the Flutter web app
RUN flutter build web

# Install Python and venv
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv

# Create virtual environment for Python
RUN python3 -m venv /opt/venv

# Ensure venv binaries are first in PATH
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip in the venv and install Flask + psycopg2-binary there
RUN pip install --upgrade pip
RUN pip install flask psycopg2-binary

# Expose port
EXPOSE 12500

# Run Flask backend
CMD ["python", "lib/databaseConnect.py"]



