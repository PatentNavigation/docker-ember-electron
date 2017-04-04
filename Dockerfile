FROM markadams/chromium-xvfb

ENV MONO_VERSION 4.8.0.495

# Node 6 repo
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

# Mono repo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list
RUN echo "deb http://download.mono-project.com/repo/debian wheezy-libjpeg62-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list

RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  openssh-client \
  git \
  zip \
  nodejs \
  # libgconf needed for electron
  libgconf-2-4 \
  fakeroot \
  wine \
  wine32 \
  mono-devel \
  ca-certificates-mono

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENV WINEDEBUG -all,err+all
ENV WINEDLLOVERRIDES winemenubuilder.exe=d

RUN wineboot --init || true
