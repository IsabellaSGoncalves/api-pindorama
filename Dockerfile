FROM ruby:3.4.5-bullseye

WORKDIR /rails_app

RUN apt-get update -qq && \
    sed -i 's/ main/ main contrib non-free/' /etc/apt/sources.list && \
    sed -i 's/ main/ main contrib non-free/' /etc/apt/sources.list.d/*.list || true && \
    apt-get update -qq && \
    apt-get install -y \
        nodejs \
        build-essential \
        libpq-dev \
        espeak \
        espeak-ng \
        lame \
        mbrola \
        mbrola-pt1 \
        mbrola-br1 \
        mbrola-br2 \
        mbrola-br3 \
        mbrola-br4 && \
    rm -rf /var/lib/apt/lists/*


COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

# EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
