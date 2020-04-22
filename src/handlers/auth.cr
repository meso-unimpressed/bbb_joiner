require "http/server"
require "crypto/subtle"

module BBBJoiner::Handlers
  class Auth
    include HTTP::Handler

    class ::HTTP::Server::Context
      property? authorized : Bool = false
    end

    def call(context : HTTP::Server::Context)
      context.request.headers["Authorization"]?.try do |authorization|
        type, value = authorization.strip.split(/\s+/)
        context.authorized = (
          type == "Bearer" && Crypto::Subtle.constant_time_compare(
            value, BBBJoiner.config.access_token
          )
        )
      end

      call_next(context)
    end
  end
end
