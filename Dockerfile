FROM ubuntu:20.04
LABEL AboutImage "Ubuntu20.04_Fluxbox_NoVNC"
LABEL Maintainer "Apoorv Vyavahare <apoorvvyavahare@pm.me>"
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive \
#VNC Server Password
	VNC_PASS="samplepass" \
#VNC Server Title(w/o spaces)
	VNC_TITLE="Ubuntu_Desktop" \
#VNC Resolution(720p is preferable)
	VNC_RESOLUTION="800x600" \
#Local Display Server Port
	DISPLAY=:0 \
#NoVNC Port
	NOVNC_PORT=$PORT \
#Ngrok Token (It's advisable to use your personal token, else it may clash with other users & your tunnel may get terminated)
	NGROK_TOKEN="1tNm3GUFYV1A4lQFXF1bjFvnCvM_4DjiFRiXKGHDaTGBJH8VM" \
#Locale
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	TZ="Asia/Kolkata"
COPY . /app
RUN rm -rf /etc/apt/sources.list && \
#All Official Focal Repos
	bash -c 'echo -e "deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse\ndeb http://archive.canonical.com/ubuntu focal partner\ndeb-src http://archive.canonical.com/ubuntu focal partner" >/etc/apt/sources.list' && \
	rm /bin/sh && ln -s /bin/bash /bin/sh && \
	apt-get update && \
	apt-get install -y \
#Packages Installation
	tzdata \
	software-properties-common \
	apt-transport-https \
	wget \
	git \
	curl \
	vim \
	zip \
	net-tools \
	iputils-ping \
	build-essential \
	python3 \
	python3-pip \
	python-is-python3 \
	perl \
	ruby \
	golang \
	lua5.3 \
	scala \
	mono-complete \
	r-base \
	default-jre \
	default-jdk \
	clojure \
	php \
	firefox \
	gnome-terminal \
	gnome-calculator \
	gnome-system-monitor \
	gedit \
	vim-gtk3 \
	mousepad \
	pcmanfm \
	terminator \
	websockify \
	supervisor \
	x11vnc \
	xvfb \
	gnupg \
	dirmngr \
	gdebi-core \
	nginx \
	novnc \
	openvpn \
	ffmpeg \
#Fluxbox
	/app/fluxbox-heroku-mod.deb && \
#TimeZone
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \
#NoVNC
	cp /usr/share/novnc/vnc.html /usr/share/novnc/index.html && \
	openssl req -new -newkey rsa:4096 -days 36500 -nodes -x509 -subj "/C=IN/ST=Maharastra/L=Private/O=Dis/CN=www.google.com" -keyout /etc/ssl/novnc.key  -out /etc/ssl/novnc.cert && \
#Ngrok
	chmod +x /app/ngrok_install.sh && \
	/app/ngrok_install.sh && \
	
	apt-get autoclean && \
    	apt-get autoremove && \
    	rm -rf /var/lib/apt/lists/*
	
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list
RUN wget --no-check-certificate https://dl.google.com/linux/linux_signing_key.pub -P /app
RUN apt-key add /app/linux_signing_key.pub
RUN set -ex; \
    apt-get update \
    && apt-get install -y \
        google-chrome-stable

ENTRYPOINT ["supervisord", "-c"]

CMD ["/app/supervisord.conf"]
