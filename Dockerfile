WORKDIR /usr/local/bouncer
COPY . .
FROM ruby:2.7.2
RUN bundle install
EXPOSE 9292
CMD ["puma"]
