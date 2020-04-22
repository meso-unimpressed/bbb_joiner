module BBBJoiner
  module Action
    abstract def call(context : HTTP::Server::Context, params : Hash(String, String))
  end
end
