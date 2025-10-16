from . import create_app
app = create_app()

if __name__ == "__main__":
    import os
    port = int(os.getenv("PORT", "12501"))
    app.run(host="0.0.0.0", port=port)