FROM ruby:3.2.2

WORKDIR /rails_app

COPY . .

RUN bundle install

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# EXPOSE 3000

CMD ["sh", "-c", "rails server -b 0.0.0.0 -p ${PORT:-3000}"]