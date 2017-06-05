FROM markadams/chromium-xvfb

ENV MONO_VERSION 4.8.0.495

# Node 6 repo
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

# Yarn repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Mono repo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian jessie main" | tee /etc/apt/sources.list.d/mono-official.list

RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  autoconf \
  openssh-client \
  # libssl-dev, libcurl4-openssl-dev and libgsf-1-dev needed to build osslsigntool
  libssl-dev \
  libcurl4-openssl-dev \
  libgsf-1-dev \
  golang \
  vim \
  git \
  unzip \
  zip \
  nodejs \
  yarn \
  # libgconf needed for electron
  libgconf-2-4 \
  fakeroot \
  wine \
  wine32 \
  mono-devel \
  ca-certificates-mono

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# build osslsigntool
RUN curl -L "http://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fosslsigncode%2Ffiles%2Fosslsigncode%2F&ts=1413463046&use_mirror=optimate" | tar -xz
WORKDIR osslsigncode-1.7.1
RUN ./configure && make && make install

# build stubbed signtool.exe which can run under wine and call osslsigntool
COPY ./main.go /gosigntool/main.go
COPY ./osslsign.sh /gosigntool/osslsign.sh
WORKDIR /gosigntool
RUN GOOS=windows GOARCH=386 go build -o signtool.exe main.go
RUN cp signtool.exe /usr/local/bin/signtool.exe
RUN chmod +x osslsign.sh
RUN cp osslsign.sh /usr/local/bin/osslsign.sh

ENV WINEDEBUG -all,err+all
ENV WINEDLLOVERRIDES winemenubuilder.exe=d

RUN wineboot --init || true

WORKDIR /root
