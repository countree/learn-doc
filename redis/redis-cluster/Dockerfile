from ruby
  run gem sources -l && \
        gem sources --remove https://rubygems.org/ --add https://gems.ruby-china.org/  && \
      gem install redis && \
    wget -O /redis-trib.rb  "http://download.redis.io/redis-stable/src/redis-trib.rb" && \
    chmod +x /redis-trib.rb
ENTRYPOINT ["/redis-trib.rb"]
