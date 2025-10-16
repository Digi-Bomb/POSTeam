from flask import Flask
from flask_cors import CORS

def create_app():
    app = Flask(__name__)
    CORS(app)

    from .payment import pay
    app.register_blueprint(pay, url_prefix="/api/payment")

    # Simple health check
    @app.get("/health")
    def health():
        return {"status": "ok"}, 200

    return app