require "env_config"

module BBBJoiner
  class_getter config = Config.new(ENV)

  struct Config
    include EnvConfig

    DEFAULT_TTL = 24.hours.total_seconds.to_i

    getter host : String = "0.0.0.0"
    getter port : Int32 = 3000
    getter root_path : String = "/join"
    getter secret : String
    getter bbb_url : String = "/bigbluebutton/api"
    getter bbb_secret : String
    getter link_ttl : Int32 = BBBJoiner::Config::DEFAULT_TTL
    getter redis : Redis
    getter access_token : String

    struct Redis
      include EnvConfig

      getter host : String = "localhost"
      getter port : Int32 = 6379
    end
  end
end
