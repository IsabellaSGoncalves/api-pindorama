FROM ruby:3.4.5

WORKDIR /rails_app

RUN apt-get update -qq && apt-get install -y nodejs build-essential libpq-dev

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

# EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]