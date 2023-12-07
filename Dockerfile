#FROM ubuntu:20.04
FROM ubuntu:23.10
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
		sudo \
		build-essential \
		python3-minimal \
		python3-pip \
		python3-tk \
		python3-dev \
		libfreetype6 \
		libfreetype6-dev \
		libgdal-dev \
		libgeos-dev \
		libpng-dev \
		libspatialindex-dev \
		qt5-style-plugins
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
WORKDIR ${HOME}/flatcam