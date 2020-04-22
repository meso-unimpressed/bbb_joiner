require "docker"
Docker.setup

require "openssl"
require "json"
require "redis"
require "http/server"
require "ecr"
require "radix"
require "./config"
require "./handlers/static_files"
require "./handlers/router"
require "./handlers/auth"

module BBBJoiner
  extend self

  class_getter redis = Redis.new(config.redis.host, config.redis.port)

  def run
    server = HTTP::Server.new([
      HTTP::LogHandler.new(STDOUT),
      HTTP::CompressHandler.new,
      Handlers::StaticFiles.new,
      Handlers::Auth.new,
      Handlers::Router.new,
    ])
    server.listen(config.host, config.port)
  end

  run
end
