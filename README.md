# Requirements

- Install Python
- Install awscli (`pip install botocore boto3 awscli`)
- Configure aws cli (`aws configure`)

# Problem Statement

* * *

## Application Provisioning

- Create a simple Django/RoR rest app backed by RDS for production and docker-compose for local testing.
- Containerize the application using docker.
- Use make files to run tests, create docker images and push to docker registry.
- Use Ansible's dynamic inventory to provision the application on three service boxes.
- The application should be reachable behind ALB.

# Build and Deploy Pipeline

Use the Jenkins setup to create a multi-branch CI/CD pipeline.

Create a declarative CI pipeline with the following stages:

- Lint code
- Run tests
- Build Docker image for the application
- Push to the docker registry

Re-use the make file created earlier in pipeline stages.

Extend the CD pipeline

- Deploy on AWS Infrastructure via Jenkins using Ansible.

* * *

* * *

## Directory Structure

├── ansible                             # contains ansible playbook for deployment over aws ec2 instances behind ELB

├── docker                             #  contains docker files for diff environments such as local, dev and release

├── Jenkinsfile                       # Jenkins pipeline

├── Makefile                           # contains commands for test, build, publish and deploy

├── scripts                              # scripts used by docker container

├── src                                   # django application source code

└── venv                                # virtual environement

* * *

## Quick Start

1.  ## Build base docker image
    

- Change path to base Dockerfile

    `$ cd docker/base`

-  Build base docker image (use your account/registry name)

  `$ docker build -t shubhamrasal/python-base:latest .`

- Publish docker image to docker hub

`$ docker push shubhamrasal/python-base:latest`

## 2\. Run unit test

`$ make test`

above command uses docker/dev/docker-compose.yml and docker/dev/Dockerfile and setup testing environment to run tests.

It will create reports folder in root directory with unit test and coverage report.

## 3\. Generate

`$ make build`

This command will generate python wheels in target folder of our application using docker/docker-compose.yml file.

Also, it will create docker image with latest python wheels and tag the image with timestamp(default) using docker/release/Dockerfile.

## 4\. Create docker image and publish to registry

`$ export DOCKER_REGISTRY=<your registry url eg.docker.io>`

`$ make publish`

above command will push latest docker image (created in build stage) to registry.

Note: Considering you already logged in to docker registry using `$ docker login`

## 5\. Deploy App to EC2 servers behind ALB

Update ansible/app_vars.yml file. Add your values to given parametes.

```yaml
aws_target_group: "<aws ec2 instance target group>"
service_container_name: "< container name>"
service_container_published_port: "< port on which service is deployed(you can find it in docker/release/Dockerfile) >"
host_container_published_port: "<port of ec2 instance from where your service will be accessible>"
database_name: <database name>
database_port: <database port eg. 5432 default port for postgress >
```

Add database variables in db_vars.yml

`$ echo "yourpassword" > password.txt`

`$ chmod 700 password.txt`

`$ ansible-vault create db_vars.yml --vault-pass-file=password.txt`

This command will open your default command line editor.

Add following variables into it.

```yaml
database_user: <db user name>
database_password: < database password >
database_url: <database host url>
```

Save and close.

Note: do not add password.txt file to git. (keep it safe)

RUN Deploy command to deploy our docker container.

`$ make deploy`

This command will deregister EC2 instance from target group of loadbalancer, deploy our latest image container and if it is successful it will register again to target group.

Note: Update ansible/inventory/inventory\_aws\_ec2.yml file for selecting ec2 instances based on tags. In my case my ec2 instances are taged as 'server'.

To run this command, we need to configure awscli.

## 6\. Clean the environment

`$ make clean`

It will delete all the container created while test and build phase.