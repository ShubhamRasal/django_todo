from django.http import HttpResponse

def print(request):
      return HttpResponse("Hello World!")