from flask import Blueprint, request, jsonify
from models.expense import Expense
from config.db import db
from schemas.expense_schema import ExpenseSchema

expense_bp = Blueprint('expenses', __name__)
expense_schema = ExpenseSchema()
expenses_schema = ExpenseSchema(many=True)

@expense_bp.route('/', methods=['POST'])
def create_expense():
    data = request.get_json()
    expense = Expense(
        description=data['description'],
        amount=data['amount'],
        category=data['category'],
        user_id=data['user_id']
    )
    db.session.add(expense)
    db.session.commit()
    return expense_schema.jsonify(expense), 201

@expense_bp.route('/', methods=['GET'])
def get_expenses():
    user_id = request.args.get('user_id')
    expenses = Expense.query.filter_by(user_id=user_id).all()
    return expenses_schema.jsonify(expenses)