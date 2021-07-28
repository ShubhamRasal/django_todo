from os import name
from platform import version
from setuptools import setup,find_packages

with open('requirements.txt') as f:
    requirements = f.read().splitlines()

setup(
    name                    =   "django_todo",
    version                 =   "0.1.0",
    description             =   "Todobackend Django REST service",
    packages                =   find_packages(),  # Find all packages that has __init__.py
    include_package_data    =   True,       # include packages to final build
    scripts                 =   ["manage.py"],
    install_requires        =   requirements , 
    extras_require          = {
                                "test": ["coverage==5.5" ,
                                "django-nose==1.4.7",
                                "colorama==0.4.4",
                                "nose==1.3.7",
                                "pinocchio==0.4.3"
                                ]
                            }
            
)