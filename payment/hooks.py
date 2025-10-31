from paypal.standard.models import ST_PP_COMPLETED
from paypal.standard.ipn.signals import valid_ipn_received
from django.dispatch import receiver
from django.conf import settings
import time
from .models import Order


@receiver(valid_ipn_received)
def paypal_payment_received(sender, **kwargs):
    # Add a 10 Second pause for paypal to send IPN data
    time.sleep(20) # Could test out with 5 sec pause for Paypal ipn to send back data
    # Grab the info that paypal sends
    paypal_obj = sender
    

    print(paypal_obj)
    print(f'Amount paid: {paypal_obj.mc_gross}')
    print(f'Invoice paid: {paypal_obj.invoice}')
    
    # Grab the invoice
    my_invoice = str(paypal_obj.invoice)

    # Match the paypal invoice to the Order invoice
    # Look up the Order
    my_Order = Order.objects.get(invoice=my_invoice)

    # Record the Order was paid
    my_Order.paid = True
    # Save the Order
    my_Order.save()

    # print(paypal_obj)
    # print(f'Amount paid: {paypal_obj.mc_gross}')


