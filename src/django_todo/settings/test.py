from .base import *
import os

INSTALLED_APPS += ('django_nose' , )
TEST_RUNNER = 'django_nose.NoseTestSuiteRunner'
TEST_OUTPUT_DIR = os.environ.get('TEST_OUTPUT_DIR', '.')
NOSE_ARGS = [
    '--verbosity=2',
    '--nologcapture',
    '--with-coverage',
    '--cover-package=todo',
    '--with-spec',
    '--spec-color',
    '--with-xunit',
    '--xunit-file=%s/unittests.xml' % TEST_OUTPUT_DIR,
    '--cover-xml',
    '--cover-xml-file=%s/coverage.xml' % TEST_OUTPUT_DIR,
]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get("DB_NAME" , "postgres"),
        'USER': os.environ.get("DB_USER", "postgres"),
        'PASSWORD': os.environ.get("DB_PASSWORD" , "postgres"),
        'HOST': os.environ.get("DB_HOST" , "localhost"),
        'PORT': os.environ.get("DB_PORT", "5432"),
    }
}