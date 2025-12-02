# Stage 1: Build the Flutter web app
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy pubspec and get dependencies first (for caching)
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the app
COPY . .

# Enable web support and ensure web platform exists
RUN flutter config --enable-web
RUN flutter create . --platforms web

# Build release web app
RUN flutter build web --release

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy built web app to nginx folder
COPY --from=build /app/build/web /usr/share/nginx/html

# Change Nginx to listen on port 12500
RUN sed -i 's/listen       80;/listen 12500;/g' /etc/nginx/conf.d/default.conf

# Expose port 12500 externally
EXPOSE 12500

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
