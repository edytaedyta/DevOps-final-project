from django.http import HttpResponse
from django.urls import path


def home(request):
    return HttpResponse("GOIT DevOps Final Project - Django app is running")


def healthz(request):
    return HttpResponse("ok")


def metrics(request):
    return HttpResponse(
        "app_requests_total 42\napp_health_status 1\n",
        content_type="text/plain; version=0.0.4",
    )


urlpatterns = [
    path("", home),
    path("healthz", healthz),
    path("metrics", metrics),
]
