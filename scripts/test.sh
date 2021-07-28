#!/bin/bash
# Activate the virtual environment
. /appenv/bin/activate

# Download requirements to build cache
pip download -d /build -r requirements_test.txt --no-input
# Pip downloads the dependencies and also creates copy of application source code in /build folder
# so in /build folder you have full copy of all application dependencies 

# Install application test requirements  [--no-index do not install dependencies from external]
pip install --no-index -f /build -r requirements_test.txt

# RUn test.sh arguments
exec $@


