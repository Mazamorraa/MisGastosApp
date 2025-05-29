from config.db import ma
from models.expense import Expense

class ExpenseSchema(ma.SQLAlchemySchema):
    class Meta:
        model = Expense
        load_instance = True

    id = ma.auto_field()
    description = ma.auto_field()
    amount = ma.auto_field()
    category = ma.auto_field()
    date = ma.auto_field()
    user_id = ma.auto_field()