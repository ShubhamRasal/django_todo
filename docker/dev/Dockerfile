FROM shubhamrasal/python-base:latest
LABEL Author="Shubham Rasal" Email="shubham.rasal@mindbowser.com"

# Install dev/build dependencies
RUN apt-get update && \
    apt-get install -qy python3-dev gcc 

# Activate virtual environment and install wheel support
RUN . /appenv/bin/activate && \
    pip install wheel --upgrade

# python wheels are application packages
# PIP environment variables (NOTE: must be set after installing wheel)          pip cache
ENV WHEELHOUSE=/wheelhouse PIP_WHEEL_DIR=/wheelhouse PIP_FIND_LINKS=/wheelhouse XDG_CACHE_HOME=/cache 

# OUTPUT: Build artefacts ( Wheels ) are output here
VOLUME /wheelhouse

# OUTPUT: Build Cache 
VOLUME /build

# OUTPUT: Test reports are output here
VOLUME /reports

# Add test entrypoint script
COPY scripts/test.sh /usr/local/bin/test.sh
RUN chmod +x /usr/local/bin/test.sh

# Set defaults for entrypoint and command string
ENTRYPOINT [ "test.sh" ]
CMD [ "python", "manage.py" ,"test" , "--noinput" ]

# Add source code 
COPY src /application
WORKDIR /application