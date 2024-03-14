FROM ubuntu:20.04
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
		build-essential \
		libfreetype6 \
		libfreetype6-dev \
		libgdal-dev \
		libgeos-dev \
		libpng-dev \
		libspatialindex-dev \
		python3-dev \
		python3-gdal \
		python3-minimal \
		python3-pip \
		python3-pyqt5 \
		python3-pyqt5.qtopengl \
		python3-simplejson \
		python3-tk \
		qt5-style-plugins \
		xauth \
		sudo
ADD requirements-freeze.txt /tmp/requirements-freeze.txt
RUN pip3 install -r /tmp/requirements-freeze.txt
ENV PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
ARG USER
ARG UID
ARG GROUP
ARG GID
ARG HOME
RUN addgroup --gid ${GID} ${GROUP} > /dev/null
RUN mkdir ${HOME}
RUN useradd --home-dir ${HOME} --gid ${GID} --no-create-home --shell /bin/bash --uid ${UID} ${USER}
RUN passwd -d ${USER}
RUN gpasswd -a ${USER} sudo
RUN echo 'fornellas ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/${USER}
RUN passwd -d root
RUN chown ${UID}:${GID} ${HOME}
WORKDIR ${HOME}/