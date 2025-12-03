from flask import Flask, send_from_directory, jsonify
import psycopg2  # Only needed if connecting to PostgreSQL
import os

app = Flask(__name__, static_folder='/app/build/web',static_url_path='')

# Serve Flutter frontend
@app.route('/')
def serve_index():
    print("🚀 Reached serve_index() route!")
    try:
        if not os.path.exists('/app/build/web/index.html'):
            return jsonify({"status": "error", "details": "index.html not found at 'build/web/index.html'"}), 404
        
        with open('build/web/index.html', 'r') as f:
            preview = f.read(200)  # Read first 200 chars
            print(f"📄 index.html preview: {preview[:100]}...")

        return send_from_directory('/app/build/web', 'index.html')
    except Exception as e:
        return jsonify({"status": "error", "details": str(e)}), 500

@app.route('/<path:path>')
def serve_static(path):
    return send_from_directory('build/web', path)

# test link to access database
@app.route('/health')
def health():
    try:
     
        # Database test:
        conn = psycopg2.connect(
            host="10.172.55.12",  # DB team's IP
            port=5432,
            user="classadmin",
            password="ProjectV2025",
            dbname="classdb", 
        )
        conn.close()
        return jsonify({"status": "ok"}), 200
    except Exception as e:
        return jsonify({"status": "error", "details": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=12500)
