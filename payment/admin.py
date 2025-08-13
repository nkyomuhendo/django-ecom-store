from django.contrib import admin
from .models import ShippingAddress, Order, OrderItem


# Regisger the model on the admin section page
admin.site.register(ShippingAddress)
admin.site.register(OrderItem)
admin.site.register(Order)
