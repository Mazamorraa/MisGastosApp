import os
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from dotenv import load_dotenv

db = SQLAlchemy()
ma = Marshmallow()

def init_app(app):
    load_dotenv()

    user = os.getenv('DB_USER', 'root')
    password = os.getenv('DB_PASSWORD', 'root')
    host = os.getenv('DB_HOST', 'db')
    dbname = os.getenv('DB_NAME', 'mis_gastos')

    app.config['SQLALCHEMY_DATABASE_URI'] = f'mysql+pymysql://{user}:{password}@{host}/{dbname}'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.secret_key = os.getenv('SECRET_KEY', 'movil2')

    db.init_app(app)
    ma.init_app(app)