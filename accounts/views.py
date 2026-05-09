from rest_framework import generics, permissions
from rest_framework.response import Response
from .serializers import RegisterSerializer
from django.shortcuts import render
from django.contrib.auth import get_user_model

User = get_user_model()

class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    permission_classes = (permissions.AllowAny,)
    serializer_class = RegisterSerializer

def login_view(request):
    return render(request, 'accounts/login.html')

def register_view(request):
    return render(request, 'accounts/register.html')

def welcome_view(request):
    return render(request, 'accounts/welcome.html')
