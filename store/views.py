from django.shortcuts import render, redirect
from .models import Product
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages


# Create your views here.
def home(request):
    products = Product.objects.all()
    return render(request, 'home.html', {'products': products})


# About us page
def about(request):
    return render(request, 'about.html', {})

# Login user view 
def login_user(request):
    if request.method == "POST":
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(request, username=username, password=password)

        if user is not None:
            login(request, user)
            messages.success(request, ("You have Been Logged In Successfully..."))
            return redirect('home')
        else:
            messages.success(request, ("There was an error, please Try again ..." ))
            return redirect('login')

    else:
        return render(request, 'login.html', {})


    return render(request, 'login.html', {})


# logout user view
def logout_user(request):
    logout(request)
    messages.success(request, ("You have been logged out.... Thanks for stopping by.."))
    return redirect('home')


# logout user view
def register_user(request):
    
    return render(request, 'register.html', {})