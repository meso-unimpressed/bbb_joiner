require "radix"
require "http/server/handler"
require "../actions/*"

module BBBJoiner::Handlers
  class Router
    include HTTP::Handler

    private getter routes : Radix::Tree(Action)

    def initialize
      @routes = Radix::Tree(Action).new.tap do |routes|
        routes.add("POST /link", Actions::CreateLink.new)
        routes.add("POST /:id", Actions::JoinConference.new)
        routes.add("GET /:id", Actions::RenderJoinPage.new)
      end
    end

    def call(context : HTTP::Server::Context)
      root = BBBJoiner.config.root_path.sub(%r|/$|, "")
      path = context.request.path.sub(root, "")

      route = routes.find("#{context.request.method} #{path}")

      (route.payload? || Actions::NotFound.new).call(context, route.params)
    end
  end
end
