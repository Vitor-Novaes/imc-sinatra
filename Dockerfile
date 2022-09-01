FROM ruby:3-alpine

ENV APP_PATH /home/api/imc
ENV PORT 3000

WORKDIR $APP_PATH

COPY Gemfile $APP_PATH/Gemfile
COPY Gemfile.lock $APP_PATH/Gemfile.lock
RUN apk add build-base && gem install bundler && bundle install

COPY . $APP_PATH
EXPOSE $PORT

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "3000"]

