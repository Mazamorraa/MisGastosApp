from flask import Blueprint, request, jsonify
from models.user import User
from config.db import db
from schemas.user_schema import UserSchema

auth_bp = Blueprint('auth', __name__)
user_schema = UserSchema()

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    if User.query.filter_by(email=data['email']).first():
        return jsonify({'message': 'Email already exists'}), 400

    user = User(email=data['email'], password=data['password'])
    db.session.add(user)
    db.session.commit()
    return user_schema.jsonify(user), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    user = User.query.filter_by(email=data['email'], password=data['password']).first()
    if user:
        return user_schema.jsonify(user)
    return jsonify({'message': 'Invalid credentials'}), 401