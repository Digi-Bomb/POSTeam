from flask import Blueprint as Payment
pay = Payment("payment", __name__)

# Import submodules for each payment action
from . import quote, authorize, capture, cancel 