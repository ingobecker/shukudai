FROM ruby:3

ARG KANJIDIC2_URL=https://www.edrdg.org/kanjidic/kanjidic2.xml.gz

RUN apt-get update \
  && apt-get install -y fonts-vlgothic fonts-noto-cjk \
  && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home app
USER app
RUN mkdir /home/app/src /home/app/run
WORKDIR /home/app/src

COPY --chown=app:app . .
RUN mkdir -p ~/.local/share/shukudai \
  && cd ~/.local/share/shukudai \
  && curl -s -o kanjidic2.xml.gz $KANJIDIC2_URL \
  && gunzip kanjidic2.xml.gz

RUN gem build shukudai.gemspec && gem install *.gem
WORKDIR /home/app/run

LABEL EXEC="podman run \
  --rm \
  -it \
  --name=shukudai \
  --userns=keep-id \
  -v .:/home/app/run:Z \
  -e LANG=C.UTF-8 \
  IMAGE \
  shukudai"

LABEL SHELL="podman run \
  --rm \
  -it \
  --name=shukudai \
  --userns=keep-id \
  -v .:/home/app/run:Z \
  -e LANG=C.UTF-8 \
  IMAGE \
  bash"
