FROM ubuntu:14.04

MAINTAINER Keke Xiang <greenapplepark@gmail.com>

RUN apt-get update && apt-get install -y \
    software-properties-common \
    python-software-properties \
    build-essential \
    git \
    python \
    python-dev \
    python-setuptools \
    supervisor \
    emacs

RUN easy_install pip

# Handle urllib3 InsecurePlatformWarning
RUN apt-get install -y libffi-dev libssl-dev
ENV PYTHONWARNINGS="ignore:a true SSLContext object"
RUN pip install pyopenssl ndg-httpsclient pyasn1

RUN pip install uwsgi
RUN pip install flask

RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get install -y nginx


# install emacs for myself -.-
RUN cd /root
RUN git clone https://github.com/greenapplepark/.emacs.d.git

# install code
ADD . /home/docker/code/

#set up all the config
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /home/docker/code/config/nginx-flask.conf /etc/nginx/sites-enabled/
RUN ln -s /home/docker/code/config/supervisor-flask.conf /etc/supervisor/conf.d/

EXPOSE 8090
CMD ["supervisord", "-n"]
