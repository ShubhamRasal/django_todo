#!/bin/bash

. /appenv/bin/activate

# use below command to replace the current process with specified
# command without creating new process 
exec $@

#eg
# entrypoint.sh python manage.py test