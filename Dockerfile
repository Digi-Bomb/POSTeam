# Use Flutter image
FROM ghcr.io/cirruslabs/flutter:stable

# Install Python + system deps
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv

# Create app directory
WORKDIR /app

# Copy project
COPY . .

# Enable Flutter web
RUN flutter config --enable-web

# Install Flutter dependencies
RUN flutter pub get

# Create Python virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python packages
RUN pip install --upgrade pip
RUN pip install flask psycopg2-binary

# Flutter dev server port
EXPOSE 13000
# Flask backend port
EXPOSE 12500

# Copy startup script into container
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Run both servers
CMD ["/start.sh"]
