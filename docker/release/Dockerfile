FROM shubhamrasal/python-base:latest


# Copy application artifacts
COPY target /wheelhouse

# Install required libraries
RUN apt-get install -qy libpython3.8
# Install application
RUN . /appenv/bin/activate && \
    pip install --no-index -f /wheelhouse django_todo && \
    rm -rf /wheelhouse

EXPOSE 80

CMD [ "uwsgi", "--http", "0.0.0.0:80","--module django_todo.wsgi", "--master", "--die-on-term"]