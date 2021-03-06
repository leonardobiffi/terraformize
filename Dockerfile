# pull upstream terraform image
FROM hashicorp/terraform:0.12.26 AS terraform

# it's offical so i'm using it + alpine so damn small
FROM python:3.8.3-alpine3.10

# exposing the port
EXPOSE 80

# set python to be unbuffered
ENV PYTHONUNBUFFERED=1

# set terraform automation flag
ENV TF_IN_AUTOMATION=true

# install required packages
RUN apk add --no-cache libffi-dev git openssh openrc

# config ssh
RUN mkdir /root/.ssh
COPY ssh-config/* /root/.ssh/
RUN ssh-keyscan -H bitbucket.org >> /root/.ssh/known_hosts
RUN chmod 700 -R /root/.ssh/
RUN rc-update add sshd default

# copy terraform binary
COPY --from=terraform /bin/terraform /usr/local/bin/terraform

# adding the gunicorn config
COPY config/config.py /etc/gunicorn/config.py

COPY requirements.txt /www/requirements.txt
RUN pip install -r /www/requirements.txt

# copy the codebase
COPY . /www
RUN chmod +x /www/terraformize_runner.py

# and running it
CMD ["gunicorn" ,"--config", "/etc/gunicorn/config.py", "terraformize_runner:app"]
