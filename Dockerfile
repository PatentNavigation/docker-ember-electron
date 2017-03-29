FROM markadams/chromium-xvfb

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
# libgconf needed for electron
RUN apt-get install -y git nodejs libgconf-2-4
