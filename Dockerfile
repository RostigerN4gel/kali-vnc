FROM kalilinux/kali-linux-docker:latest

USER root 
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

RUN apt-get update -y && apt-get clean all
RUN apt-get install -y software-properties-common && apt-get update -y && apt-get clean all
RUN apt-get install -y git colordiff colortail unzip vim tmux xterm zsh curl && apt-get clean all
RUN apt-get install -y kali-linux-all && apt-get clean all

RUN git clone https://github.com/jasonchaffee/dotfiles.git /.dotfiles

RUN /.dotfiles/config install

RUN chsh -s $(which zsh)
RUN rm -f ${HOME}/.profile
RUN su -s /bin/zsh -c '. ~/.zshrc' root

 #===== # VNC #===== 
RUN apt-get update -qqy \
    && apt-get -qqy install \
    x11vnc \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
#================= # Locale settings #================= 
ENV LANGUAGE en_US.UTF-8 ENV LANG en_US.UTF-8 
RUN locale-gen en_US.UTF-8 \
    && dpkg-reconfigure --frontend noninteractive locales \
    && apt-get update -qqy \
    && apt-get -qqy --no-install-recommends install \
        language-pack-en \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
#======= # Fonts #======= 
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    fonts-ipafont-gothic \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-cyrillic \
    xfonts-scalable \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#========= # fluxbox # A fast, lightweight and responsive window manager #========= 
RUN apt-get update -qqy \
  && apt-get -qqy install \
    fluxbox \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#============================== # test Generating the VNC password as seluser # So the service can be started with seluser #============================== 
RUN mkdir -p ~/.vnc \
  && x11vnc -storepasswd secret ~/.vnc/passwd

CMD ["/bin/zsh"]

EXPOSE 5900