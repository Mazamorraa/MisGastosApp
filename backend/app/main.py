from flask import Flask
from config.db import db, ma, init_app
from routes.expense_routes import expense_bp
from routes.auth_routes import auth_bp

def create_app():
    app = Flask(__name__)   
    init_app(app)
    app.register_blueprint(expense_bp, url_prefix="/api/expenses")
    app.register_blueprint(auth_bp, url_prefix="/api/auth")

    with app.app_context():
        db.create_all() 
    return app

if __name__ == "__main__":
    app = create_app()
    app.run(host="0.0.0.0", port=5000)