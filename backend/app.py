from flask import Flask
from flask_cors import CORS
from user_routes import user_bp
from profile_picture_routes import picture_bp

app = Flask(__name__)
CORS(app)
app.register_blueprint(picture_bp)
app.register_blueprint(user_bp)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

