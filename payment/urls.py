from django.urls import path
from . import views


urlpatterns = [
    path('payment_sucess/', views.payment_success, name='payment_success'),
    path('checkout/', views.checkout, name='checkout'),

]
